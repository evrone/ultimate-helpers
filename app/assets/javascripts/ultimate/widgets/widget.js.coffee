#  require:
#    jquery ~> 1.7.0
#    underscore ~> 1.3.0

# TODO inheritance:
#   ? class Classes.Proto.Observer see jU-widget

console.log 'Ultimate.Proto.Widget', Ultimate  if console?

class Ultimate.Proto.Widget extends Ultimate.Proto.Gear

  @className: 'Widget' # set during bindWidgets()

  @defaults:
    locales:
      'en':
        description: 'Proto Widget'
      'ru':
        description: 'Прото Виджет'

  # TODO move to @defaults.options :
  @loadingWidthMethodName: 'innerWidth'
  @loadingHeightMethodName: 'innerHeight'
  loadingState: false

  eventsMatcher = /^(\S+)\s*(.*)$/ # /^\s*([\w\.:]+)(\s+(.+?))?\s*$/
  @events: {}
  eventsNamespace: null

  @nodes:
    jNoInfo: '.no-info'

  jContainer: null

  constructor: (@jContainer, options = {}) ->
    data = @jContainer.data()
    if data
      widgets = _delete data, 'widgets'
      options = $.extend true, {}, data, options
    super options
    if widgets
      widgets.push @
    else
      @jContainer.data 'widgets', [@]
    @eventsNamespace = ".widget-#{@uniqId}"
    @bindEvents()
    @findNodes()

  isGarbage: -> not (@jContainer and @jContainer.parent().length)

  unbindEvents: ->
    @jContainer.off @eventsNamespace

  bindEvents: (events = @constructor.events) ->
    # TODO check IE key with unwordchars ('ajax:error'), and Array.forEach() functionality
    @unbindEvents()
    _.each events, (method, eventRoute) =>
      if _.isString method
        if _.isFunction @[method]
          method = @[method]
        else
          $.error "Method \"#{method}\" does not exist in #{@constructor.className}.bindEvents()"
      if _.isFunction method
        matchedEventRoute = eventRoute.match eventsMatcher
        if matchedEventRoute
          matchedEventRoute.shift()
          [eventName, selector] = matchedEventRoute
          eventName = "#{eventName}#{@eventsNamespace}"
          method = _.bind method, @
          if selector
            @jContainer.on eventName, selector, method
          else
            @jContainer.on eventName, method
          # http://37signals.com/svn/posts/3137-using-event-capturing-to-improve-basecamp-page-load-times
        else
          $.error "Bad event route \"#{eventRoute}\" in #{@constructor.className}.bindEvents()"
      else
        $.error "No method for route \"#{eventRoute}\" in #{@constructor.className}.bindEvents()"

  findNodes: (jRoot = @jContainer, nodes = @constructor.nodes) ->
    jNodes = {}
    for nodeName, selector of nodes
      _isObject = _.isObject selector
      if _isObject
        nestedNodes = selector
        selector = _delete nestedNodes, 'selector'
      jNodes[nodeName] = @[nodeName] = jRoot.find(selector)
      if _isObject
        _.extend jNodes, @findNodes(jNodes[nodeName], nestedNodes)
    jNodes

  replaceContainer: (jNewContainer, sideCall = false) ->
    unless sideCall
      widgets = @jContainer.data 'widgets'
      jNewContainer.data 'widgets', widgets
      @jContainer.replaceWith jNewContainer
      for widget in widgets  when widget isnt @
        widget.replaceContainer jNewContainer, true
    @jContainer = jNewContainer
    @unbindEvents()
    @bindEvents()

  # overloadable
  getJLoadingContainer: -> @jContainer

  loading: (state, text = '') ->
    jLoadingContainer = @getJLoadingContainer()
    if jLoadingContainer and jLoadingContainer.length
      jLoadingContainer.children('.loading-overlay').remove()
      if @loadingState = state
        width = jLoadingContainer[@constructor.loadingWidthMethodName]()
        height = jLoadingContainer[@constructor.loadingHeightMethodName]()
        text = "<span class=\"text\">#{text}</span>"  if text
        style = "width: #{width}px; height: #{height}px; line-height: #{height}px;"
        jLoadingContainer.append "<div class=\"loading-overlay\" style=\"#{style}\"><span class=\"circle\"></span>#{text}</div>"
