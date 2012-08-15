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
        command = "updateSettings"
      if view[command]
        return getValue(view, command)
      else
        $.error "Command [#{command}] does not exist on jQuery.#{pluginName}()"
    else
      options = if argsLength then a[0] else {}
      if $.isPlainObject(options)
        view = new viewClass(_.extend({}, options, el: jContainer[0]))
      else
        $.error "First argument of jQuery.#{pluginName}() must be plain object"
    if _returnView then view else jContainer


# TODO rewrite docs
###
 * Invoke Ultimate Flash functionality for the first element in the set of matched elements.
 * If last argument {Boolean} true, then returns {View}.
 * @usage
 *** standart actions ***
 * construction    .ultimateFlash([Object options = {}])                  ~ {jQuery} jContainer
 * show            .ultimateFlash("show", String type, String text)       ~ {jQuery} jFlash | {Boolean} false
 * notice          .ultimateFlash("notice", String text)                  ~ {jQuery} jFlash | {Boolean} false
 * alert           .ultimateFlash("alert", String text)                   ~ {jQuery} jFlash | {Boolean} false
 *** extended actions ***
 * getSettings     .ultimateFlash("getSettings")                          ~ {Object} settings
 * setSettings     .ultimateFlash("setSettings", {Object} settings)       ~ {jQuery} jContainer
 * updateSettings  .ultimateFlash({Object} options)                       ~ {Object} settings
 * auto            .ultimateFlash("auto", {ArrayOrObject} obj)            ~ {Array} ajFlashes | {Boolean} false
 * ajaxSuccess     .ultimateFlash("ajaxSuccess"[, Arguments successArgs = []])
 * ajaxError       .ultimateFlash("ajaxError"[, String text = settings.translations.defaultErrorText][, Arguments errorArgs = []])
###

Ultimate.Backbone.createJQueryPlugin = (pluginName, viewClass) ->
  cout "info", "Ultimate.Backbone.createJQueryPlugin", pluginName, viewClass
  if Ultimate.Backbone.isViewClass(viewClass)
    jQuery.fn[pluginName] = -> @ultimateBackboneViewPluginAdapter pluginName, viewClass, arguments
  else
    jQuery.error "Second argument of Ultimate.Backbone.createJQueryPlugin() must be View class inherited from Backbone.View"
