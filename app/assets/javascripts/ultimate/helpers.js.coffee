###
 *  global front-end js helpers
###

@DEBUG_MODE ?= false
@TEST_MODE ?= false
@LOG_TODO ?= true

@cout = =>
  args = _.toArray(arguments)
  method = if args[0] in ['log', 'info', 'warn', 'error', 'assert', 'clear'] then args.shift() else 'log'
  if @DEBUG_MODE and console?
    method = console[method]
    if method.apply?
      method.apply(console, args)
    else
      method(args)
  return args[0]

@_cout = =>
  console.log(arguments)  if console?
  arguments[0]

@deprecate = (subject, instead = null) =>
  @cout 'error', "`#{subject}` DEPRECATED!#{if instead then " Use instead `#{instead}`" else ''}"

@todo = (subject, location = null, numberOrString = null) =>
  if @LOG_TODO
    @cout 'warn', "TODO: #{subject}#{if location then " ### #{location}" else ''}#{if numberOrString then (if _.isNumber(numberOrString) then ":#{numberOrString}" else " > #{numberOrString}") else ''}"

@logicalXOR = (a, b) ->
  ( a and not b ) or ( not a and b )

@bound = (number, min, max) ->
  Math.max(min, Math.min(max, number))



@getParams = (searchString = location.search) ->
  q = searchString.replace(/^\?/, '').split('&')
  r = {}
  for e in q
    t = e.split('=')
    r[decodeURIComponent(t[0])] = decodeURIComponent(t[1])
  r

@respondFormat = (url, format = null) ->
  aq = url.split('?')
  ah = aq[0].split('#')
  ad = ah[0].split('.')
  currentFormat = if ad.length > 1 and not /\//.test(ad[ad.length - 1]) then ad.pop() else ''
  return currentFormat  unless format?
  return url  if format is currentFormat
  ad.push format  if format
  ah[0] = ad.join('.')
  aq[0] = ah.join('#')
  aq.join('?')
