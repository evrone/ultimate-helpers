#= require ./jquery-ext

do ($ = jQuery) ->
  $.fn.ultimateBackboneViewPluginAdapter = (pluginName, viewClass, pluginArgs) ->
    a = []
    Array::push.apply a, pluginArgs  if pluginArgs.length > 0
    argsLength = a.length
    # Shall return the View, if have arguments and last argument of the call is a Boolean true.
    _returnView =
      if argsLength and _.isBoolean(_.last(a))
        argsLength--
        a.pop()
      else
        false
    unless @length
      return if _returnView then undefined else @
    # get the first   TODO analize, maybe each?
    jContainer = @first()
    # try to get the View-object, controlling everything that happens in our magical container
    view = jContainer.getView(viewClass)
    if view and view.$el[0] is jContainer[0]
      command = null
      if argsLength and _.isString(a[0])
        command = a.shift()
      else
        return view  if _returnView
        return jContainer  unless argsLength
        command = "_configure"
      if view[command]
        return _.result(view, command)
      else
        $.error "Command [#{command}] does not exist on jQuery.#{pluginName}()"
    else
      options = if argsLength then a[0] else {}
      if $.isPlainObject(options)
        view = new viewClass(_.extend({}, options, el: jContainer[0]))
      else
        $.error "First argument of jQuery.#{pluginName}() must be plain object"
    if _returnView then view else jContainer


###*
 * Make $.fn.pluginName() as wrapper under Backbone.View.
 * First call on jQuery object invoke View functionality for the first element in the set of matched elements.
 * Subsequent calls forwarding on view methods or return view property.
 * If last argument {Boolean} true, then returns {View}.
 * @usage
 *   construction    .pluginName([Object options = {}])           : {jQuery} jContainer
 *   updateOptions   .pluginName({Object} options)                : {Object} view options
 *   get options     .pluginName("options")                       : {Object} view options
 *   some method     .pluginName("methodName", *methodArguments)  : {jQuery} chanin object || {AnotherType} method result
###

Ultimate.Backbone.createJQueryPlugin = (pluginName, viewClass) ->
  Ultimate.Backbone.debug ".createJQueryPlugin()", pluginName, viewClass
  if Ultimate.Backbone.isViewClass(viewClass)
    viewClass.pluginName = pluginName
    jQuery.fn[pluginName] = -> @ultimateBackboneViewPluginAdapter pluginName, viewClass, arguments
  else
    jQuery.error "Second argument of Ultimate.Backbone.createJQueryPlugin() must be View class inherited from Backbone.View"
