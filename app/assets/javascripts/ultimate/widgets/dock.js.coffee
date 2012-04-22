@Ultimate =
  Proto: {}
  Widgets: {}
  LazyWidgets: {}
  Observers: {}
  Plugins: {}

  widgetsHeap: []

  # get last instance by default
  getWidgetByName: (widgetClassName, instanceIndex = -1) ->
    if widgetClass = @Widgets[widgetClassName] or @LazyWidgets[widgetClassName]
      instanceIndex += widgetClass.instances.length  if instanceIndex < 0
      widgetClass.instances[instanceIndex]

  gcWidgets: ->
    newHeap = []
    garbage = []
    for widget in @widgetsHeap
      if widget.isGarbage()
        instances = widget.constructor.instances
        i = _.indexOf instances, widget
        instances.splice i, 1  if i >= 0
        garbage.push widget
      else
        widget.heapIndex = newHeap.push widget
    @widgetsHeap = newHeap  if garbage.length
    garbage

  isWidget: (candidate) ->
    candidate instanceof @Proto.Widget

  isWidgetClass: (candidate) ->
    (candidate::) instanceof @Proto.Widget

  #  This is the best way to create an instance of the widget.
  createWidget: (widgetClass, jContainer, options = {}) ->
    widget = null
    if widgetClass.canCreateInstance()
      unless jContainer.hasWidget widgetClass
        widget = new widgetClass jContainer, options
        widget.heapIndex = @widgetsHeap.push widget
      else
        warning "Ultimate.createWidget() can't create widget on passed jContainer, because it already has widget #{widgetClass.name}"
    else
      warning "Ultimate.createWidget() can't create widget, because blocked by widgetClass.canCreateInstance()"
    widget


#
_.bindAll Ultimate

#@Widgets = []
#
#@getWidgetByName = (widgetClassName, instanceIndex = -1) ->
#  if widgetClass = Classes.Widgets[widgetClassName] or Classes.LazyWidgets[widgetClassName]
#    instanceIndex += widgetClass.instances.length  if instanceIndex < 0
#    widgetClass.instances[instanceIndex]
#
#@gcWidgets = =>
#  newHeap = []
#  garbage = []
#  for widget in @Widgets
#    if widget.isGarbage()
#      instances = widget.constructor.instances
#      i = _.indexOf instances, widget
#      instances.splice i, 1  if i >= 0
#      garbage.push widget
#    else
#      widget.heapIndex = newHeap.push widget
#  @Widgets = newHeap  if garbage.length
#  garbage
#
#@isWidget = (candidate) ->
#  candidate instanceof Classes.Proto.Observer
#
#@isWidgetClass = (candidate) ->
#  (candidate::) instanceof Classes.Proto.Observer
