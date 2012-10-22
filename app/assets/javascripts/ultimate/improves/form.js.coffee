do ( $ = jQuery ) ->

  # TODO try optimize, excepting Edge and search in siblings for next cycle
  $.fn.nearestFind = (selector, extremeEdgeSelector = 'form, body') ->
    jEdge = @
    jResult = jEdge.find(selector)
    until jResult.length or jEdge.is(extremeEdgeSelector)
      jEdge = jEdge.parent()
      jResult = jEdge.find selector
    jResult
  


  $.fn.closestEdge = (edgeSelector = '.input-line, .field, .field-line, tr, li, fieldset, .g-box, form') ->
    # TODO remove and extract edgeSelector, else undeprecate
    deprecate 'closestEdge', '$().closest(\'your selector\')'
    @closest edgeSelector



  # @param strongById: Boolean = false
  $.fn.closestLabel = ( strongById = false, passCache = false ) ->
    (if @is(':input') then @ else @find(':input')).filter(':not(input[type="hidden"])').map ->
      jInput = $(@)
      jLabel = jInput.data('closestLabel')  unless passCache
      unless jLabel
        if jLabel is false
          return null
        else
          jLabel = {length: 0}
          inputId = jInput.attr('id')
          if inputId
            # try search label by id linkage
            jLabel = jInput.nearestFind("label[for=\"#{inputId}\"]:first")
          # try get first labet in the edge area
          unless jLabel.length
            jLabel = jInput.nearestFind('label')
            if jLabel.length is 1
              jReverseInput = jLabel.nearestFind(':input')
              unless jReverseInput.length is 1 and jReverseInput[0] is jInput[0]
                jLabel = {length: 0}
            else if jLabel.length > 1
              jLabel = {length: 0}
          # taken!
          if jLabel.length
            # oh, this label already linked
            if jLabel.data('closestInput')
              jLabel = {length: 0}
            else
              jLabel.data 'closestInput', jInput
          jInput.data 'closestLabel', jLabel
      if jLabel.length
        if strongById and jLabel.attr('for') isnt jInput.attr('id')
          null
        else
          jLabel[0]
      else
        null



  $.linkedLabelsClick = ->
    jLabel = $ @
    jInput = jLabel.data 'closestInput'

    unless jInput
      attrFor = jLabel.attr 'for'
      jInput = jLabel.nearestFind ":input##{attrFor}"
      jInput = jLabel.nearestFind ':input'  unless jInput.length is 1
      jLabel.data 'closestInput', jInput  if jInput.length

    if jInput and jInput.length is 1
      if jInput.is 'input:checkbox, input:radio'
        jInput.click()
      else if jInput.is 'select'
          # TODO try: jInput.click() в любом случае свести к универсальносит
        jInput.closest('.g-select').click()
      else
        jInput.focus()
      false

  # Cacheble bulletproof labels
  # example: $('body').linkedLabels();
  $.fn.linkedLabels = (suspend = true, eventName = 'click.linked-labels') ->
    if @is 'label'
      jLabels = @filter 'label'
      jLabels.off eventName
      jLabels.on eventName, $.linkedLabelsClick  if suspend
    else
      @off eventName, 'label'
      @on eventName, 'label', $.linkedLabelsClick  if suspend
    @



  # [ additionAttr: String = 'data-nested-addition' ]
  $.fn.setNestedAdditions = (additionAttr = 'data-nested-addition') ->
    @find(":input[#{additionAttr}]").each ->
      jInput = $ @
      inputId = jInput.attr 'id'
      if inputId
        newId = "#{inputId}_#{jInput.attr additionAttr}"
        jInput.attr 'id', newId
        jLabel = jInput.closestLabel(true)
        jLabel.attr 'for', newId  if jLabel.length
        jInput.removeAttr additionAttr
    @



  # setNestedIndex(params = {nestedField: index || [index, old_index]})
  # setNestedIndex(nestedField, index, [old_index])
  $.fn.setNestedIndex = ->
    params = {}
    if arguments.length is 1
      params = arguments[0]
    else
      params[arguments[0]] = (if arguments.length > 2 then [arguments[1], arguments[2]] else arguments[1])
    replacers =
      name: []
      id: []
    for nestedField, index of params
      if $.isArray index
        [index, oldIndex] = index
      else
        oldIndex = '\\d*'
      replacers['id'].push   [ (new RegExp "_#{nestedField}_#{oldIndex}"),           "_#{nestedField}_#{index}"  ]
      replacers['name'].push [ (new RegExp "\\[#{nestedField}\\]\\[#{oldIndex}\\]"), "[#{nestedField}][#{index}]" ]
    ( if @is(':input') then @filter('[name]') else @find(':input[name]') ).map ->
      jInput = $ @
      for replacerAttr, replacerPairs of replacers
        # if extract attribute
        if attr = jInput.attr replacerAttr
          # dup attr
          newAttr = attr
          for pair in replacerPairs
            newAttr = newAttr.replace pair[0], pair[1]
          if newAttr isnt attr
            jInput.closestLabel(true).attr('for', newAttr)  if replacerAttr is 'id'
            jInput.attr replacerAttr, newAttr
    @



  $.fillTabIndexesCounter = 0

  # TODO this may be .is 'input'
  $.fn.fillTabIndexes = (onlyVisible = false) ->
    if @length
      @find("input:not([readonly])#{if onlyVisible then ':visible' else ''}").each ->
        $(@).attr 'tabindex', ++$.fillTabIndexesCounter
    @
