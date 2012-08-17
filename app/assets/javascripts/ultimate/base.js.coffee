###
 *  front-end ui-components routines
 *
 *   @version 0.5.5.alpha / 2010-2012
 *   @author Karpunin Dmitry / Evrone.com
 *   @email koderfunk_at_gmail_dot_com
 *
 *   TODO register components
 *   TODO using underscore.js
 *
###

do ($ = jQuery) =>

  $.regexp ||= {}

  $.regexp.rorId ||= /(\w+)_(\d+)$/

  @ror_id = (jObjOrString) ->
    if jObjOrString instanceof jQuery
      id = jObjOrString.data('rorId') # Maybe use "id"
      unless id
        id = jObjOrString.attr('id')
        if id
          matchResult = id.match($.regexp.rorId)
          id = if matchResult then matchResult[2] else null
          jObjOrString.data 'rorId', id
          id
        else 
          null
    else
      matchResult = jObjOrString.match($.regexp.rorId)
      if matchResult then matchResult[2] else null

  $.fn.rorId = ->
    if arguments.length
      id = arguments[0]
      word = 'ror_id'
      thisId = @attr('id')
      if thisId
        word = matchResult[1]  if matchResult = thisId.match($.regexp.rorId)
      @data('rorId', id).attr 'id', "${word}_#{id}"
      @
    else
      ror_id @

  $.fn.getClasses = ->
    _.words @attr("class")

  # Get hash of html-dom attributes from first matched element or false, if no elements
  $.fn.getAttributes = ->
    if @length
      attrs = {}
      attrs[attr.nodeName] = attr.nodeValue for attr in this[0].attributes
      attrs
    else
      false

  # [showOrHide[, duration[, callback]]]
  $.fn.slideToggleByState = ->
    if @length
      if arguments.length > 0
        a = args(arguments)
        if a.shift()
          @slideDown.apply @, a
        else
          @slideUp.apply @, a
      else
        @slideToggle()
    @

  unless $.isHTML
    $.regexp.HTML = /^\s*<(\w+)[\S\s]*<\/(\w+)>\s*$/
    $.isHTML = (content, strong = false) ->
      return false  unless _.isString(content)
      matches = content.match($.regexp.HTML)
      matches and not strong or matches[1] is matches[2]

  # TODO replace usages to underscore methods and using distribution
  unless $.isRegExp
    $.isRegExp = (candidate) ->
      deprecate '$.isRegExp', '_.isRegExp'
      typeof candidate is "object" and typeof candidate.test is "function"

  unless $.isBoolean
    $.isBoolean = (v) ->
      deprecate '$.isBoolean', '_.isBoolean'
      typeof v is "boolean"

  unless $.isString
    $.isString = (v) ->
      deprecate '$.isString', '_.isString'
      typeof v is "string"

  if typeof $.isEmptyString is "undefined"
    $.isEmptyString = (v) ->
      deprecate '$.isEmptyString', '_.isBlank'
      regexpSpace.test v
