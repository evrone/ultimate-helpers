# TODO this is part of custom forms
# TODO registrable

( ( $ ) ->

  $.errorableFields = {}
  $.errorableFieldsSelector = ''
  
  $.registerErrorableField = (selector, events, errorCleaner) ->
    $.errorableFields[selector.split(/\s+/)[0]] = arguments
    $.errorableFieldsSelector = _.keys($.errorableFields).join(', ')
    true

  $.fieldWithErrorsWrapperClass = 'field_with_errors'

  #  [ selector: String = '.g-select, .g-text-field, .g-text-area' ]
  #  [ [, ]errors: Array = [] ]
  $.fn.setFormErrors = ->
    # dafault parameters
    selector = $.errorableFieldsSelector # '.g-select, .g-text-field, .g-text-area'
    errors = []
    # parsing arguments
    a = args arguments
    if a.length
      first = a.shift()
      if _.isString first
        selector = first
        if a.length
          first = a.shift()
          if _.isString first
            first = [first]
      if _.isArray first
        errors = _.uniq first
    # ui process
    @clearFormErrors selector
    jErrorWrappers = @find(selector).wrap(selectorToHtml ".#{$.fieldWithErrorsWrapperClass}").parent()
    jErrorWrappers.append (content_tag('div', err, class: 'error')  for err in errors).join("\n")
    jErrorWrappers.closestLabel().addClass('with-error')

  $.fn.setErrors = ->
    deprecate('jQ.setErrors(...)', 'jQ.setFormErrors(...)')
    @setFormErrors.apply(@, arguments)

  # [selector]
  $.fn.clearFormErrors = (selector) ->
    selector ||= $.errorableFieldsSelector # '.g-select, .g-text-field, .g-text-area'
    fullSelector = ".#{$.fieldWithErrorsWrapperClass}:has(#{selector})"
    jErrorWrappers = @find fullSelector
    jErrorWrappers = @closest  unless jErrorWrappers.length
    jErrorWrappers.closestLabel().removeClass('with-error')
    jErrorWrappers.children('.error').remove()
    jErrorWrappers.children(selector).unwrap()
    @

  $.fn.clearFromErrors = ->
    deprecate('jQ.clearFromErrors(...)', 'jQ.clearFormErrors(...)')
    @clearFormErrors.apply(@, arguments)

  $.ujsAjaxError = (event, jqXHR) ->
    jForm = $(@).clearFormErrors()
    try
      responseJSON = $.parseJSON jqXHR.responseText
      errors = responseJSON['errors'] or responseJSON
      if errors
        jFields = jForm.find '[name*="["]:input:visible'
        if jFields.length
          for fieldErrors, fieldName of errors
            jField = jFields.filter "[name$=\"[#{fieldName}]\"]"
            if jField.length
              jField.closestEdge().setErrors fieldErrors
    catch e
      # nop
    true


  $.fn.customErrorsHandler = (suspend = true, eventName = 'ajax:error', selector = 'form[data-remote="true"]') ->
    if @length
      if @is 'form'
        jForms = @filter selector
        jForms.off eventName, $.ujsAjaxError
        jForms.on eventName, $.ujsAjaxError  if suspend
      else  
        @off eventName, selector, $.ujsAjaxError
        @on eventName, selector, $.ujsAjaxError  if suspend
    @



    
  $.fn.errorCleaners = (suspend = true) ->
    if @length
      jDocks = if @is ':input' then @closestEdge() else @
      for fieldWrapperSelector, [selector, events, errorCleaner] of $.errorableFields
        fullSelector = ".#{$.fieldWithErrorsWrapperClass} > #{selector}"
        jDocks.off events, fullSelector
        jDocks.on events, fullSelector, errorCleaner  if suspend
    @



  $.registerErrorableField '.g-text-field input:visible', 'change keyup', ->
    # text-fields error cleaner
    jTextField = $ @
    unless jTextField.val() is '' # TODO may be use isEmptyString()
      jTextField.closestEdge().clearFormErrors('.g-text-field')
      jTextField.change().focus() # unwraping break change, and there changing continue

  $.registerErrorableField '.g-select select', 'change', ->
    # selects error cleaner
    jSelect = $ @
    unless jSelect.val() is '' # TODO may be use isEmptyString() 
      jSelect.closestEdge().clearFormErrors('.g-select')

)( jQuery )
