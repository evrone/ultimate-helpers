$ ->
  cout '>>> go $(\'body\').bindWidgets Ultimate.Widgets'
  cout '>>> binded', $('body').bindWidgets Ultimate.Widgets



do ($ = jQuery) ->


  # TODO arguments
  $.fn.getWidgets = (widgetClass = null, inheritance = false, domDeep = false) ->
    if not @length
      return []
    else if @length is 1
      widgets = @data('widgets') or []
    else
      # TODO check work and perf tests
      widgets = _.flatten($(o).data('widgets') or []  for o in @, true)
      #2: @map -> $(@).data('widgets') or []
      #3: _.flatten ( @map -> $(@).data('widgets') or [] ), true
    if widgetClass?
      _.filter widgets, if inheritance then (w) -> w instanceof widgetClass else (w) -> w.costructor is widgetClass
    else
      widgets

  $.fn.getWidget = (widgetClass, inheritance = false) ->
    if _.isString widgetClass
      for o in @
        widgets = $(o).data('widgets') or []
        for w in widgets
          return w  if w.constructor.name is widgetClass
    else if Ultimate.isWidgetClass widgetClass
      for o in @
        widgets = $(o).data('widgets') or []
        if inheritance
          for w in widgets
            return w  if w instanceof widgetClass
        else
          for w in widgets
            return w  if w.constructor is widgetClass
    false

  $.fn.hasWidget = (widgetClass) ->
    if _.isString widgetClass
      for o in @
        return true  if _.any $(o).data('widgets') or [], (w) -> w.constructor.name is widgetClass
    else if Ultimate.isWidgetClass widgetClass
      for o in @
        return true  if _.any $(o).data('widgets') or [], (w) -> w.constructor is widgetClass
    false

  $.fn.bindOneWidget = (widgetClass, options = {}) ->
    Ultimate.gcWidgets()
    bindedWidget = null
    if widgetClass.canCreateInstance()
      if @length
        selector = "#{widgetClass.selector}:not(.prevent-binding)"
        jContainer = if @is(selector) then @filter(selector) else @find(selector)
        if (l = jContainer.length)
          if l is 1
            bindedWidget = Ultimate.createWidget widgetClass, jContainer, options
          else
            warning "$.fn.bindOneWidget() found #{l} elements by #{selector}, when need only 1"
        else
          warning "$.fn.bindOneWidget() not found elements by #{selector}"
      else
        warning "$.fn.bindOneWidget() call from empty jQuery()"
    else
      warning "Widget #{widgetClass.name} can't create call from empty jQuery()"
    bindedWidget

  $.fn.bindWidget = (widgetClass, options = {}) ->
    Ultimate.gcWidgets()
    bindedWidgets = []
    if @length
      ( if @is(widgetClass.selector) then @ else @find(widgetClass.selector) ).filter(':not(.prevent-binding)').each ->
        if widgetClass.canCreateInstance()
          jContainer = $ @
          if widget = Ultimate.createWidget widgetClass, jContainer, options
            bindedWidgets.push widget
        else
          false
    bindedWidgets

  $.fn.bindWidgets = (widgetClasses = Ultimate.LazyWidgets, options = {}) ->
    cout 'info', 'bindWidgets begin'
    bindedWidgets = []
    if @length
      bindedWidgets = for widgetName, widgetClass of widgetClasses when widgetClass.canCreateInstance()
        cout 'info', 'bindWidgets: widget = ', widgetClass.name, widgetName
        widgetClass.constructor.className = widgetName
        @bindWidget widgetClass, options
    _.flatten bindedWidgets, true



  # TODO filtering by widgetClass
  # TODO enother algorithm with enother projection
  $.fn.closestWidgets = (widgetClass = null) ->
    widgets = []
    jTry = @
    jTry = jTry.parent()  while jTry.length and not (widgets = jTry.getWidgets()).length
    widgets
