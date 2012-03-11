@Classes =
  Proto: {}
  Widgets: {}
  LazyWidgets: {}

@Widgets = []

@getWidget = (widgetClassName, instanceIndex = 0) ->
  if widgetClass = Classes.Widgets[widgetClassName] or Classes.LazyWidgets[widgetClassName]
    widgetClass.instances[instanceIndex]

( ( $ ) ->

  $.fn.bindWidgets = (widgetClass = null) ->
    return @  unless @length
    bindedWidgets = []
    if widgetClass
      @find(widgetClass.selector).each ->
        jContainer = $ @
        widgets = jContainer.data('widgets') or []
        unless _.any widgets, (w) -> w.constructor is widgetClass
          bindedWidgets.push new widgetClass $ @
    else
      for widgetName, widgetClass of Classes.LazyWidgets
        @bindWidgets widgetClass
    window.Widgets = window.Widgets.concat bindedWidgets
    bindedWidgets

)( jQuery )

$ ->
  for widgetName, widgetClass of Classes.Widgets
    $(widgetClass.selector).each ->
      Widgets.push new widgetClass $ @
      true

class Classes.Proto.Widget

  # commented because must be uniq for independent widgets
  #@instances: [] TODO try =
  @defaultOptions: {}
  options: {}
  @events: {}
  @loadingWidthMethodName: 'innerWidth'
  @loadingHeightMethodName: 'innerHeight'

  constructor: (@jContainer, options = {}) ->
    @jLoadingContainer = @jContainer
    widgets = @jContainer.data('widgets') or []
    widgets.push @
    @jContainer.data 'widgets', widgets # MB not needed
    @constructor.instances = []  unless @constructor.instances
    @constructor.instances.push @
    @options = $.extend {}, @constructor.defaultOptions, @jContainer.data(), options
    $.each @constructor.events, (eventRoute, eventName) =>
      # TODO match direct binding without delegate-selector
      matchedEventRoute = eventRoute.match /^\s*([\w:]+)\s+(.+?)\s*$/
      if matchedEventRoute
        @jContainer.on matchedEventRoute[1], matchedEventRoute[2], @[eventName]
        #cout 'bindevent', @jContainer, "#{matchedEventRoute[1]} *** #{matchedEventRoute[2]} *** #{eventName}", @[eventName]
      else
        $.error "Bad event route: [#{eventRoute}]"

  loading: (state, text = '') ->
    if @jLoadingContainer and @jLoadingContainer.length
      @jLoadingContainer.children('.loading-overlay').remove()
      if state
        width = @jLoadingContainer[@constructor.loadingWidthMethodName]()
        height = @jLoadingContainer[@constructor.loadingHeightMethodName]()
        text = '<span class="text">' + text + '</span>'  if text
        style = "width: #{width}px; height: #{height}px; line-height: #{height}px;"
        @jLoadingContainer.append '<div class="loading-overlay" style="' + style + '"><span class="circle"></span>' + text + '</div>'



class Classes.Proto.Widget
