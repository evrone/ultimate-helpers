@Classes =
  Proto: {}
  Widgets: {}
  LazyWidgets: {}

@Widgets = []

@getWidgetByName = (widgetClassName, instanceIndex = -1) ->
  if widgetClass = Classes.Widgets[widgetClassName] or Classes.LazyWidgets[widgetClassName]
    instanceIndex += widgetClass.instances.length  if instanceIndex < 0
    widgetClass.instances[instanceIndex]

@gcWidgets = =>
  newHeap = []
  garbage = []
  for widget in @Widgets
    if widget.isGarbage()
      instances = widget.constructor.instances
      i = _.indexOf instances, widget
      instances.splice i, 1  if i >= 0
      garbage.push widget
    else
      widget.heapIndex = newHeap.push widget
  @Widgets = newHeap  if garbage.length
  garbage



( ( $ ) ->

  $.fn.getWidgets = ->
    if not @length
      []
    else if @length is 1
      @data('widgets') or []
    else
      # TODO check work and perf tests
      _.flatten($(o).data('widgets') or []  for o in @, true)
      #2: @map -> $(@).data('widgets') or []
      #3: _.flatten ( @map -> $(@).data('widgets') or [] ), true

  $.fn.hasWidget = (widgetClass) ->
    for o in @
      return true  if _.any $(o).data('widgets') or [], (w) -> w.constructor is widgetClass
    false

  $.fn.bindWidget = (widgetClass, options = {}) ->
    gcWidgets()
    bindedWidgets = []
    if @length
      ( if @is(widgetClass.selector) then @ else @find(widgetClass.selector) ).filter(':not(.prevent-binding)').each ->
        if widgetClass.canCreateInstance()
          jContainer = $ @
          unless jContainer.hasWidget widgetClass
            widget = new widgetClass jContainer, options
            bindedWidgets.push widget
            widget.heapIndex = window.Widgets.push widget
        else
          false
    bindedWidgets

  $.fn.bindWidgets = (widgetClasses = Classes.LazyWidgets, options = {}) ->
    bindedWidgets = []
    if @length
      bindedWidgets = for widgetName, widgetClass of widgetClasses
        @bindWidget widgetClass, options
    _.flatten bindedWidgets, true

)( jQuery )



$ ->
  $('body').bindWidgets Classes.Widgets



class Classes.Proto.Widget

  # commented because must be uniq for independent widgets
  #@instances: []
  @maxInstances: Infinity  # 0 for unlimit, 1 for singleton
  @defaultOptions: {}
  options: {}
  @events: {}
  @loadingWidthMethodName: 'innerWidth'
  @loadingHeightMethodName: 'innerHeight'

  jContainer: null

  constructor: (@jContainer, options = {}) ->
    @jLoadingContainer = @jContainer

    widgets = @jContainer.data('widgets') or []
    widgets.push @
    @jContainer.data 'widgets', widgets
      
    @bindEvents()

    @constructor.instances = []  unless @constructor.instances
    @constructor.instances.push @

    @options = $.extend {}, @constructor.defaultOptions, @jContainer.data(), options

  bindEvents: (events = @constructor.events) ->
    for eventRoute, methodName of events
      if _.isFunction @[methodName]
        matchedEventRoute = eventRoute.match /^\s*([\w\.:]+)(\s+(.+?))?\s*$/
        if matchedEventRoute
          # TODO fold logic and try forwarding event methods without => (see bb)
          events = matchedEventRoute[1]
          if selector = matchedEventRoute[3]
            @jContainer.on events, selector, @[methodName]
          else
            @jContainer.on events, @[methodName]
          # http://37signals.com/svn/posts/3137-using-event-capturing-to-improve-basecamp-page-load-times
        else
          $.error "Bad event route: [#{eventRoute}]"
      else
        $.error "No method in bindEvents(): [#{methodName}]"

  canCreateInstance: -> @constructor.instances.length < @constructor.maxInstances

  isGarbage: -> not (@jContainer and @jContainer.parent().length)

  replaceContainer: (jNewContainer, sideCall = false) ->
    unless sideCall
      widgets = @jContainer.data 'widgets'
      jNewContainer.data 'widgets', widgets
      @jContainer.replaceWith jNewContainer
      widget.replaceContainer jNewContainer, true  for widget in widgets  when widget isnt @
    @jContainer = jNewContainer
    @jLoadingContainer = @jContainer
    @bindEvents()

  loading: (state, text = '') ->
    if @jLoadingContainer and @jLoadingContainer.length
      @jLoadingContainer.children('.loading-overlay').remove()
      if state
        width = @jLoadingContainer[@constructor.loadingWidthMethodName]()
        height = @jLoadingContainer[@constructor.loadingHeightMethodName]()
        text = '<span class="text">' + text + '</span>'  if text
        style = "width: #{width}px; height: #{height}px; line-height: #{height}px;"
        @jLoadingContainer.append '<div class="loading-overlay" style="' + style + '"><span class="circle"></span>' + text + '</div>'
