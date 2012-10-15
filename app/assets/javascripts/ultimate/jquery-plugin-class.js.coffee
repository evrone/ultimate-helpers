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
# 1 _.isArray
# 1 _.bind
# 1 _.clone
# 1 _.outcasts.delete
# 1 _.string.underscored
# 1 _.string.startsWith

class Ultimate.Plugin
  el: null
  $el: null
  nodes: {}
  events: {}

  options: {}

  # @defaultLocales: { en: {} }
  locale: 'en'
  translations: {}

  constructor: (options) ->
    throw new Error('Property `el` must be specified at first argument of Ultimate.Plugin.constructor')  unless options?.el
    @cid = _.uniqueId('ultimatePlugin_')
    @_configure options
    @$el = $(@el)
    @findNodes()
    @initialize? arguments...
    @delegateEvents()

  # jQuery delegate for element lookup, scoped to DOM elements within the
  # current plugin. This should be prefered to global lookups where possible.
  $: (selector) ->
    @$el.find(selector)

  findNodes: (jRoot = @$el, nodes = @nodes) ->
    jNodes = {}
    nodes = if _.isFunction(nodes) then @nodes.call(@) else _.clone(nodes)
    if _.isObject(nodes)
      for nodeName, selector of nodes
        _isObject = _.isObject(selector)
        if _isObject
          nestedNodes = selector
          selector = _.outcasts.delete(nestedNodes, 'selector')
        jNodes[nodeName] = @[nodeName] = jRoot.find(selector)
        if _isObject
          _.extend jNodes, @findNodes(jNodes[nodeName], nestedNodes)
    jNodes

  undelegateEvents: ->
    @$el.unbind ".delegateEvents_#{@cid}"

  # Cached regex to split keys for `delegate`, from backbone.js.
  delegateEventSplitter = /^(\S+)\s*(.*)$/

  # Overload and proxy parent method Backbone.View.delegateEvents() as hook for normalizeEvents().
  delegateEvents: (events) ->
    args = _.toArray(arguments)
    args[0] = @_normalizeEvents(events)
    @_delegateEvents args...

  # delegateEvents() from backbone.js
  _delegateEvents: (events = _.result(@, "events")) ->
    return  unless events
    @undelegateEvents()
    for key, method of events
      method = @[events[key]]  unless _.isFunction(method)
      throw new Error("Method \"#{events[key]}\" does not exist")  unless method
      [[], eventName, selector] = key.match(delegateEventSplitter)
      method = _.bind(method, @)
      eventName += ".delegateEvents_#{@cid}"
      if selector is ''
        @$el.bind(eventName, method)
      else
        @$el.delegate(selector, eventName, method)

  _normalizeEvents: (events) ->
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
    #cout '@options', @options
    @_reflectOptions()
    @_initTranslations()

  _reflectOptions: (reflectableOptions = _.result(@, "reflectableOptions"), options = @options) ->
    if _.isArray(reflectableOptions)
      @[attr] = options[attr]  for attr in reflectableOptions  when not _.isUndefined(options[attr])
    @[attr] = value  for attr, value of options  when not _.isUndefined(@[attr])

  # use I18n, and modify locale and translations
  _initTranslations: ->
    if @constructor.defaultLocales?
      if not @options["locale"] and I18n?.locale of @constructor.defaultLocales
        @locale = I18n.locale
        #cout '!!!Set LOCALE FROM I18N ', @locale
      defaultTranslations = if @locale then @constructor.defaultLocales[@locale] or {} else {}
      #cout '!!!defaultTranslations', @locale, defaultTranslations
      _.defaults @translations, defaultTranslations

  t: (key) ->
    @translations[key] or _.string.humanize(key)
