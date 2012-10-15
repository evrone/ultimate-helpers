#= require ./base

# TODO minimize requirements
# requirements stats:
# 1 _.extend
# 1 _.isString
# 1 _.isBoolean
# 1 _.toArray
# 1 _.last

###*
 * Make $.fn.pluginName() as adapter to plugin object (instance of Ultimate.Plugin or Backbone.View).
 * First call on jQuery object invoke View functionality for the first element in the set of matched elements.
 * Subsequent calls forwarding on view methods or return view property.
 * If last argument {Boolean} true, then returns {Plugin or View}.
 * @usage
 *   construction    .pluginName([Object options = {}])           : {jQuery} jContainer
 *   updateOptions   .pluginName({Object} options)                : {Object} view options
 *   get options     .pluginName("options")                       : {Object} view options
 *   some method     .pluginName("methodName", *methodArguments)  : {jQuery} chanin object or {AnotherType} method result
###

Ultimate.createJQueryPlugin = (pluginName, pluginClass) ->
  Ultimate.debug(".createJQueryPlugin()", pluginName, pluginClass)  if $.isFunction(Ultimate.debug)
  pluginClass.pluginName ||= pluginName
  jQuery.fn[pluginName] = -> @ultimatePluginAdapter pluginName, pluginClass, arguments



do ($ = jQuery) ->

  $.fn.ultimatePluginAdapter = (pluginName, pluginClass, pluginArgs) ->
    args = _.toArray(pluginArgs)
    # Shall return the Plugin, if have arguments and last argument of the call is a Boolean true.
    _returnPlugin =
      if args.length and _.isBoolean(_.last(args))
        args.pop()
      else
        false
    unless @length
      return if _returnPlugin then null else @
    # get the first
    jContainer = @first()
    # try to get the plugin object, controlling everything that happens in our magical container
    plugin = jContainer.data(pluginName)
    if plugin? and plugin.$el[0] is jContainer[0]
      command = null
      if args.length and _.isString(args[0])
        command = args.shift()
      else
        if args.length and $.isPlainObject(args[0])
          command = "_configure"
        else
          return if _returnPlugin then plugin else jContainer
      if command of plugin
        value = plugin[command]
        return if $.isFunction(value)
            plugin.$el.removeData(pluginName)  if command is "destroy"
            result = value.apply(plugin, args)
            if command is "_configure" then plugin.options else result
          else
            value
      else
        $.error "Command [#{command}] does not exist on jQuery.#{pluginName}()"
    else
      options = args[0] or {}
      if $.isPlainObject(options)
        plugin = new pluginClass(_.extend(options, el: jContainer[0]))
        plugin.$el.data(pluginName, plugin)
      else
        $.error "First argument of jQuery.#{pluginName}() must be plain object"
    if _returnPlugin then plugin else jContainer
