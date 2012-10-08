###
  Underscore.outcasts
  (c) 2012 Dmitry Karpunin <koderfunk aet gmail dot com>
  Underscore.outcasts is freely distributable under the terms of the MIT license.
  Documentation: https://github.com/KODerFunk/underscore.outcasts
  Some code is borrowed from outcasts pull requests to Underscore.
  Version '0.1.2'
###

'use strict'



# Defining underscore.outcasts

UnderscoreOutcasts =

  VERSION: '0.1.2'

  delete: (object, key) ->
    value = object[key]
    delete object[key]
    value

  blockGiven: (args) ->
    block = _.last(args)
    if _.isFunction(block) then block else null

  sortHash: (hash, byValue = false) ->
    _.sortBy(_.map(hash, (value, key) -> [key, value]), (pair) -> pair[if byValue then 1 else 0])

  regexpValidKey: /^[\w\-]+$/

  invert: (object) ->
    result = {}
    for key, value of object
      if _.isArray(value)
        for newKey in value when UnderscoreOutcasts.regexpValidKey.test(newKey)
          result[newKey] = key
      else if UnderscoreOutcasts.regexpValidKey.test(value)
        if _.has(result, value)
          if _.isArray(result[value])
            result[value].push key
          else
            result[value] = [result[value], key]
        else
          result[value] = key
    result

  scan: (str, pattern) ->
    block = @blockGiven(arguments)
    result = []
    while str.length
      matches = str.match(pattern)
      if matches
        cut = matches.shift()
        str = str.slice(matches.index + cut.length)
        result.push if block
            if matches.length then block(matches...) else block(cut)
          else
            if matches.length then matches else cut
      else
        str = ''
    result

  ###
   Split array into slices of <number> elements.
   Map result by iterator if last given.

     >>> eachSlice [1..10], 3, (a) -> cout a
     [1, 2, 3]
     [4, 5, 6]
     [7, 8, 9]
     [10]
  ###
  eachSlice: (array, number) ->
    size = array.length
    index = 0
    slices = []
    while index < size
      nextIndex = index + number
      slices.push array.slice(index, nextIndex)
      index = nextIndex
    if block = @blockGiven(arguments) then _.map(slices, block) else slices

  ###
   Splits or iterates over the array in groups of size +number+,
   padding any remaining slots with +fill_with+ unless it is +false+.

     >>> inGroupsOf [1..7], 3, (group) -> cout group
     [1, 2, 3]
     [4, 5, 6]
     [7, null, null]

     >>> inGroupsOf [1..3], 2, '&nbsp;', (group) -> cout group
     [1, 2]
     [3, "&nbsp;"]

     >>> inGroupsOf [1..3], 2, false, (group) -> cout group
     [1, 2]
     [3]
  ###
  inGroupsOf: (array, number, fillWith = null) ->
    return array  if number < 1
    unless fillWith is false
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - array.length % number) % number
      if padding
        fillWith = null  if _.isFunction(fillWith)
        array = array.slice()
        array.push(fillWith)  while padding-- > 0
    @eachSlice array, number, @blockGiven(arguments)

  exports: ->
    result = {}
    for prop of @
      continue  if not @hasOwnProperty(prop) or prop.match(/^(?:include|contains|reverse)$/)
      result[prop] = @[prop]
    result



# CommonJS module is defined
if exports?
  if module?.exports
    # Export module
    module.exports = UnderscoreOutcasts
  exports.UnderscoreOutcasts = UnderscoreOutcasts
else if define?.amd
  # Register as a named module with AMD.
  define 'underscore.outcasts', [], -> UnderscoreOutcasts
else
  # Integrate with Underscore.js if defined
  # or create our own underscore object.
  @_ ||= {}
  @_.outcasts = @_.out = UnderscoreOutcasts
