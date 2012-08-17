#= require ./base

class Ultimate.Backbone.View extends Backbone.View

  @defaultLocales:
    en: {}
    ru: {}

  locale: "en"
  translations: {}

  loadingState: null
  loadingWidthMethodName: "innerWidth"
  loadingHeightMethodName: "innerHeight"
  loadingStateClass: "loading"
  loadingOverlayClass: "loading-overlay"

  viewOptions: -> []

  constructor: ->
    Ultimate.Backbone.debug ".View.constructor()", @
    super



  # Overload parent method Backbone.View.setElement() as hook for findNodes() and trick for data("views").
  setElement: (element, delegate, sideCall = false) ->
    if @$el?.length and not sideCall
      views = @$el.data("views")
      for view in views  when view isnt @
        view.setElement element, delegate, true
      @$el.data("views", [])
    super
    if @$el.length
      if views = @$el.data("views")
        views.push @
      else
        @$el.data "views", [@]
    @findNodes()
    @

  findNodes: (jRoot = @$el, nodes = @nodes) ->
    jNodes = {}
    nodes = nodes()  if _.isFunction(nodes)
    if _.isObject(nodes)
      for nodeName, selector of nodes
        _isObject = _.isObject(selector)
        if _isObject
          nestedNodes = selector
          selector = _delete(nestedNodes, "selector")
        jNodes[nodeName] = @[nodeName] = jRoot.find(selector)
        if _isObject
          _.extend jNodes, @findNodes(jNodes[nodeName], nestedNodes)
    jNodes



  # Overload and proxy parent method Backbone.View.delegateEvents() as hook for normalizeEvents().
  delegateEvents: (events) ->
    args = []
    Array::push.apply args, arguments  if arguments.length > 0
    args[0] = @normalizeEvents(events)
    super args...

  # Cached regex to split keys for `delegate`, from backbone.js.
  delegateEventSplitter = /^(\S+)\s*(.*)$/

  normalizeEvents: (events) ->
    events = getValue(@, "events")  unless events
    if events
      normalizedEvents = {}
      for key, method of events
        [[], eventName, selector] = key.match(delegateEventSplitter)
        selector = getValue(@, selector)
        selector = selector.selector if selector instanceof jQuery
        if _.isString(selector)
          key = "#{eventName} #{selector}"
        normalizedEvents[key] = method
      events = normalizedEvents
    events



  # Overload parent method Backbone.View._configure() as hook for reflectOptions().
  _configure: (options) ->
    super
    @initTranslations()
    @reflectOptions()

  reflectOptions: (viewOptions = getValue(@, "viewOptions"), options = @options) ->
    @[attr] = options[attr]  for attr in viewOptions  when typeof options[attr] isnt "undefined"
    @[attr] = value  for attr, value of options  when typeof @[attr] isnt "undefined"
    @

  updateOptions: (options) ->
    @_configure(options)
    @options

  # use I18n, and modify locale and translations in options
  # modify and return merged data
  initTranslations: (options = @options) ->
    # if global compatible I18n
    if I18n? and I18n.locale and I18n.t
      options["locale"] ||= I18n.locale
      if options["locale"] is I18n.locale
        # pointing to defaults locales of language specified in I18n
        _defaultLocales = @constructor.defaultLocales?[I18n.locale] ||= {}
        unless _defaultLocales["loaded"]
          _defaultLocales["loaded"] = true
          # try read localized strings
          if _localesFromI18n = I18n.t(options["i18nKey"] or _.underscored(@constructor.pluginName or @constructor.name))
            # fill it from I18n
            _.extend _defaultLocales, _localesFromI18n
    @locale = options["locale"] if options["locale"]
    translations = if @locale then @constructor.defaultLocales?[@locale] or {} else {}
    $.extend true, options, translations: translations, options
    options

  t: (key) ->
    # TODO maybe use I18n there
    @translations[key]


  # Overloadable getter for jQuery-container that will be blocked.
  getJLoadingContainer: -> @$el

  loading: (state, text = "", circle = true) ->
    jLoadingContainer = @getJLoadingContainer()
    if jLoadingContainer and jLoadingContainer.length
      jLoadingContainer.removeClass @loadingStateClass
      jLoadingContainer.children(".#{@loadingOverlayClass}").remove()
      if @loadingState = state
        jLoadingContainer.addClass @loadingStateClass
        width = jLoadingContainer[@loadingWidthMethodName]()
        height = jLoadingContainer[@loadingHeightMethodName]()
        text = "<span class=\"text\">#{text}</span>"  if text
        circle = "<span class=\"circle\"></span>"  if circle
        style = "width: #{width}px; height: #{height}px; line-height: #{height}px;"
        jLoadingContainer.append "<div class=\"#{@loadingOverlayClass}\" style=\"#{style}\">#{circle}#{text}</div>"



  # Improve templating.
  jst: (name, context = @) ->
    JST["backbone/templates/#{name}"] context
