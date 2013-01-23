# TODO: register components

do ($ = jQuery) =>

  $.regexp ||= {}

  $.regexp.rorId ||= /(\w+)_(\d+)$/

  @ror_id = (jObjOrString) ->
    if jObjOrString instanceof jQuery
      id = jObjOrString.data("rorId") # Maybe use "id"
      unless id?
        id = ror_id(jObjOrString.attr("id"))
        jObjOrString.data("rorId", id)  if id?
      id
    else if _.isString(jObjOrString)
      matchResult = jObjOrString.match($.regexp.rorId)
      if matchResult then matchResult[2] else null
    else
      null

  $.fn.rorId = (id = null, prefix = null) ->
    if arguments.length
      jThis = @first()
      thisId = @attr("id")
      if not prefix? and _.isString(thisId)
        prefix = matchResult[1]  if matchResult = thisId.match($.regexp.rorId)
      @data("rorId", id)
      if prefix?
        jThis.attr "id", "#{prefix}_#{id}"
      jThis
    else
      ror_id @

  $.fn.getClasses = ->
    _.string.words @attr("class")

  # Get hash of html-dom attributes from first matched element or false, if no elements
  $.fn.getAttributes = ->
    attrs = {}
    if @length
      attrs[attr.nodeName] = attr.nodeValue  for attr in this[0].attributes
    attrs

  # [showOrHide[, duration[, callback]]]
  $.fn.slideToggleByState = ->
    if @length
      if arguments.length > 0
        a = _.toArray(arguments)
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
      return false  unless matches?
      not strong or matches[1] is matches[2]
