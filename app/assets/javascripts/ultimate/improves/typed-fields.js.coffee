do ($ = jQuery) ->

  # ========= max & min  =========
  $('input:text[data-gte], input:text[data-lte]').live 'change focusout blur', ->
    jField = $(@)
    realValue = jField.val()
    if realValue isnt ''
      # TODO refactor this
      min = parseFloat(jField.data('gte'))
      max = parseFloat(jField.data('lte'))
      oldValue = parseFloat(realValue)
      v = oldValue
      v = 0  if isNaN(v)
      v = min  if not isNaN(min) and v < min
      v = max  if not isNaN(max) and v > max
      jField.val(v).change()  unless v is oldValue

  $.fn.setFieldBounds = (min, max) ->
    @filter('input:text')
      .attr
        'data-gte': min
        'data-lte': max
      .data
        'gte': min
        'lte': max

  # ========= regexpMask  =========

  $.regexp = {}  unless $.regexp
  $.regexp.typedField =
    'integer'   : /^$|^\d+$/
    'float'     : /^$|^\d+(\.\d*)?$/
    'currency'  : /^$|^\d+(\.\d{0,2})?$/
    'text'      : /^.*$/

  $.fn.getRegExpMask = ->
    mask = @data('regexpMask')
    if _.isString(mask)
      try
        mask = new RegExp(mask)
        @data 'regexpMask', mask
      catch e
        # nop
    else
      dataType = @data('dataType')
      mask = $.regexp.typedField[dataType]  if dataType
    unless mask
      @val 'unknown dataType'
      mask = $.regexp.typedField['text']
    mask

  $.fn.dropRegExpMask = ->
    @
      .removeAttr('data-regexp-mask')
      .removeData('regexpMask')
      .removeData('value')

  $.fn.setRegExpMask = (mask) ->
    stringMask = 'true'
    if _.isString(mask)
      stringMask = mask
      try
        mask = new RegExp(mask)
      catch e
        # nop
    if _.isRegExp(mask)
      @
        .dropRegExpMask()
        .attr('data-regexp-mask', stringMask)
        .data('regexpMask', mask)
        .change()
    @
