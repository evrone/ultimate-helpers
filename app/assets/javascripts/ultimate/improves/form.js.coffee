( ( $ ) ->

  # TODO try optimize, excepting Edge and search in siblings for next cycle
  $.fn.nearestFind = (selector, extremeEdgeSelector = 'form, body') ->
    jEdge = @
    jResult = jEdge.find selector
    until jResult.length or jEdge.is extremeEdgeSelector
      jEdge = jEdge.parent()
      jResult = jEdge.find selector
    jResult
  


  $.fn.closestEdge = (edgeSelector = '.input-line, .field, .field-line, tr, fieldset, .g-box, form') ->
    # TODO remove and extract edgeSelector, else undeprecate
    deprecate 'closestEdge', '$().closest(\'your selector\')'
    @closest edgeSelector



  # @param strongById: Boolean = false
  $.fn.closestLabel = ( strongById = false, passCache = false ) ->
    (if @is(':input') then @ else @find(':input')).filter(':not(input[type="hidden"])').map ->
      jInput = $ @
      jLabel = jInput.data 'closestLabel'  unless passCache
      unless jLabel
        if jLabel is false
          jLabel = length: 0
        else
          jLabel = length: 0
          jEdge = jInput.closestEdge()   # TODO may be need params
          inputId = jInput.attr 'id'
          if inputId
            # try search label by id linkage
            labelSelectorByFor = "label[for=\"#{inputId}\"]"
            # at first search in the edge area
            jLabel = jEdge.find labelSelectorByFor
            unless jLabel.length
              # try search in the closest form
              jLabel = jInput.closest('form').find labelSelectorByFor
              # trust only unique label on the form
              jLabel = length: 0  if jLabel.length > 1
          # try get first labet in the edge area
          jLabel = jEdge.find('label:first')  unless jLabel.length
          # taken!
          if jLabel.length
            # oh, this label already linked
            if jLabel.data 'closestInput'
              jLabel = length: 0
            else
              jLabel.data 'closestInput', jInput
          jInput.data 'closestLabel', jLabel
      jLabel = length: 0  if strongById and jLabel.length and jLabel.attr('for') isnt jInput.attr('id')
      if jLabel.length then jLabel[0] else null



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
      params = arguments
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
      replacers['id'].push   [ new RegExp "_#{nestedField}_#{oldIndex}_",          "_#{nestedField}_#{index}_"  ]
      replacers['name'].push [ new RegExp "\\[#{nestedField}\\]\\[#{oldIndex}\\]", "[#{nestedField}][#{index}]" ]
    ( if @is(':input') then @filter('[name]') else @find(':input[name]') ).map ->
      jInput = $ @
      for replacerAttr, replacerPairs of replacers
        if attr = jInput.attr replacerAttr
          newAttr = attr
          for pair in replacerPairs
            newAttr = newAttr.replace pair[0], pair[1]
          if newAttr isnt attr
            jInput.attr replacerAttr, newAttr
            jInput.closestLabel(true).attr('for', newAttr)  if replacerAttr is 'id'
    @



  $.fillTabIndexesCounter = 0

  # TODO this may be .is 'input'
  $.fn.fillTabIndexes = (onlyVisible = false) ->
    if @length
      @find("input:not([readonly])#{if onlyVisible then ':visible' else ''}").each ->
        $(@).attr 'tabindex', ++$.fillTabIndexesCounter
    @

)( jQuery )
