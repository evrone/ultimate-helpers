###
 *  front-end ui-components routines
 *
 *   @version 0.5.5.alpha / 2010-2011
 *   @author Karpunin Dmitry / Evrone.com
 *   @email koderfunk_at_gmail_dot_com
 *
 *   TODO register components
 *   TODO using underscore.js
 *
###

@_delete = (object, key) ->
  value = object[key]
  delete object[key]
  value

# TODO do ($ = jQuery) =>
( ($) =>

  $.regexp ||= {}

  $.regexp.rorId ||= /(\w+)_(\d+)$/

  @ror_id = (jObjOrString) ->
    if isJQ jObjOrString
      id = jObjOrString.data 'rorId'
      unless id
        id = jObjOrString.attr 'id'
        if id
          matchResult = id.match $.regexp.rorId
          id = if matchResult then matchResult[2] else ''
          jObjOrString.data 'rorId', id
        else 
          id = ''
    else
      matchResult = jObjOrString.match $.regexp.rorId
      id = if matchResult then matchResult[2] else ''
    id

  $.fn.rorId = ->
    if arguments.length
      id = arguments[0]
      word = 'ror_id'
      thisId = @attr 'id'
      if thisId
        word = matchResult[1]  if matchResult = thisId.match $.regexp.rorId
      @data('rorId', id).attr 'id', word + '_' + id
      @
    else
      ror_id @

  $.fn.getClasses = ->
    return []  unless @length
    classAttr = $.trim @attr 'class'
    if classAttr then classAttr.split(/\s+/) else []

  # Get hash of html-dom attributes from first matched element or false, if no elements
  $.fn.getAttributes = ->
    if @length
      attrs = {}
      #TRY attrs[attr.nodeName] = attr.nodeValue for attr in this[0].attributes
      $.each this[0].attributes, (index, attr) ->
        attrs[attr.nodeName] = attr.nodeValue
      attrs
    else
      false

  # [showOrHide[, duration[, callback]]]
  $.fn.slideToggleByState = ->
    if @length
      if arguments.length > 0
        a = args arguments
        if a.shift()
          @slideDown.apply @, a
        else
          @slideUp.apply @, a
      else
        @slideToggle()
    @

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

  unless $.isHTML
    $.regexp.HTML = new RegExp "^\\s*<(\\w+)[\\S\\s]*</(\\w+)>\\s*$"
    $.isHTML = (v) ->
      matches = $.regexp.HTML.exec v
      matches and matches[1] is matches[2]

  if typeof $.isEmptyString is "undefined"
    $.isEmptyString = (v) ->
      regexpSpace.test v

)( jQuery )
