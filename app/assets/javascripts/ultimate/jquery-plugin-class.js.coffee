# TODO simlify translations infrastructure
# `pluginClass` must store propery `$el` as jQuery object wrapped on the target DOM-object in his instance.

#= require ./base

# TODO minimize requirements
# requirements stats:
# 4 _.result
# 3 _.extend
# 2 _.isFunction
# 2 _.isObject
# 1 _.isString
# 1 _.bind
# 1 _.clone
# 1 _.outcasts.delete
# 1 _.string.underscored
# 1 _.string.startsWith

class Ultimate.Plugin
  $el: null
  nodes: {}
  events: {}

  options: {}

  locale: "en"
  translations: {}

  constructor: (options) ->
    @$el = $(options.el)
    @findNodes()
    @initialize arguments...
    @delegateEvents()


  # jQuery delegate for element lookup, scoped to DOM elements within the
  # current plugin. This should be prefered to global lookups where possible.
  $: (selector) ->
    @$el.find(selector)

  # Initialize is an empty function by default. Override it with your own
  # initialization logic.
  initialize: ->

  findNodes: (jRoot = @$el, nodes = @nodes) ->
    jNodes = {}
    nodes = if _.isFunction(nodes) then @nodes.call(@) else _.clone(nodes)
    if _.isObject(nodes)
      for nodeName, selector of nodes
        _isObject = _.isObject(selector)
        if _isObject
          nestedNodes = selector
          selector = _.outcasts.delete(nestedNodes, "selector")
        jNodes[nodeName] = @[nodeName] = jRoot.find(selector)
        if _isObject
          _.extend jNodes, @findNodes(jNodes[nodeName], nestedNodes)
    jNodes

  undelegateEvents: ->
    @$el.unbind ".delegateEvents#{@cid}"

  # Cached regex to split keys for `delegate`, from backbone.js.
  delegateEventSplitter = /^(\S+)\s*(.*)$/

  # delegateEvents() from backbone.js
  _delegateEvents: (events = _.result(@, "events")) ->
    return  unless events
    @undelegateEvents()
    for key, method of events
      method = @[events[key]]  unless _.isFunction(method)
      throw new Error("Method \"#{events[key]}\" does not exist")  unless method
      [[], eventName, selector] = key.match(delegateEventSplitter)
      method = _.bind(method, @)
      eventName += ".delegateEvents#{@cid}"
      if selector is ''
        @$el.bind(eventName, method)
      else
        @$el.delegate(selector, eventName, method)

  # Overload and proxy parent method Backbone.View.delegateEvents() as hook for normalizeEvents().
  delegateEvents: (events) ->
    args = []
    Array::push.apply args, arguments  if arguments.length > 0
    args[0] = @normalizeEvents(events)
    @_delegateEvents args...

  normalizeEvents: (events) ->
    events = _.result(@, "events")  unless events
    if events
      normalizedEvents = {}
      for key, method of events
        [[], eventName, selector] = key.match(delegateEventSplitter)
        selector = _.result(@, selector)
        selector = selector.selector  if selector instanceof jQuery
        if _.isString(selector)
          selector = selector.replace(@$el.selector, '')  if _.string.startsWith(selector, @$el.selector)
          key = "#{eventName} #{selector}"
        normalizedEvents[key] = method
      events = normalizedEvents
    events

  _configure: (options) ->
    _.extend @options, options
    @initTranslations()
    @reflectOptions()

  reflectOptions: (viewOptions = _.result(@, "viewOptions"), options = @options) ->
    @[attr] = options[attr]  for attr in viewOptions  when typeof options[attr] isnt "undefined"
    @[attr] = value  for attr, value of options  when typeof @[attr] isnt "undefined"
    @

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
          if _localesFromI18n = I18n.t(options["i18nKey"] or _.string.underscored(@constructor.pluginName or @constructor.name))
            # fill it from I18n
            _.extend _defaultLocales, _localesFromI18n
    @locale = options["locale"]  if options["locale"]
    translations = if @locale then @constructor.defaultLocales?[@locale] or {} else {}
    $.extend true, options, translations: translations, options
    options
