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

( ($) =>

  $.regexp ||= {}

  $.regexp.rorId ||= /(\w+)_(\d+)$/

  @ror_id = (jObjOrString) ->
    if isJQ jObjOrString
      id = jObjOrString.data 'ror_id'
      unless id
        id = jObjOrString.attr 'id'
        if id
          matchResult = id.match $.regexp.rorId
          id = if matchResult then matchResult[2] else ''
          jObjOrString.data 'ror_id', id
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
        word = matchResult[1] if matchResult = thisId.match $.regexp.rorId
      @data('ror_id', id).attr 'id', word + '_' + id
      @
    else
      ror_id @

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

  # TODO replace usages tounderscore methods and using distribution
  unless $.isRegExp
    $.isRegExp = (candidate) ->
      typeof candidate is "object" and typeof candidate.test is "function"

  unless $.isBoolean
    $.isBoolean = (v) ->
      typeof v is "boolean"

  unless $.isString
    $.isString = (v) ->
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



###
 * Обновляет состояния checked, readonly и disabled элементов.
 *
 * @param {jQuery} jRoot корневые jQuery объекты, в которых будет осуществляться поиск по selector
 * @param {String} [selector=".g-text-field,.g-text-area,.g-select,.g-checkbox,.g-radio"] селектор для поиска декорированных элементов
 * @returns {void}
 *
###
@refresh_states = (jRoot, selector = '.g-text-field, .g-text-area, .g-select, .g-checkbox, .g-radio') ->
  # TODO проверить все места использования refresh_states на предмет возможной оптимизации за счёт введения параметра selector
  # TODO сделать рефреш регистрируемых компонентов
  jComponents = jRoot.find(selector)
  jDisabled = jComponents.filter(':not(.disabled):has(:input:disabled)').addClass 'disabled'
  jEnabled = jComponents.filter('.disabled:not(:has(:input:disabled))').removeClass 'disabled'
  jDisabled.find('input.datepicker.hasDatepicker').datepicker 'disable' if $.fn.datepicker
  jDisabled.closestLabel().addClass 'disabled'
# commented while testing previous string
#  jDisabled.find(':input[id]').each( function () {
#    $(this).closest('form').find('label[for="' + this.id + '"]').addClass('disabled'); // May be use closestLabel()
#  } );
  jEnabled.find('input.datepicker.hasDatepicker').datepicker 'enable' if $.fn.datepicker
  jEnabled.closestLabel().removeClass 'disabled'
# commented while testing previous string
#  jEnabled.find(':input[id]').each( function () {
#    $(this).closest('form').find('label[for="' + this.id + '"]').removeClass('disabled'); // May be use closestLabel()
#  } );
  jRoot.find('.g-text-field, .g-text-area')
  .filter(':not(.readonly):has(input[type="text"][readonly], textarea[readonly])').addClass('readonly')
  .end().filter('.readonly:not(:has(input[type="text"][readonly], textarea[readonly]))').removeClass('readonly')
  jRoot.find('.g-checkbox, .g-radio')
  .filter(':not(.checked):has(input:checked)').addClass('checked')
  .end().filter('.checked:not(:has(input:checked))').removeClass('checked')



$ =>
  @refresh_states $ 'body'
