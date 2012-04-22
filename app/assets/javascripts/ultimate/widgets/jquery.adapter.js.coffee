# jQueryPluginAdapter

do ($ = jQuery) ->
  $.fn.pluginAdapter = (widgetClass, pluginName, pluginArgs) ->
    a = args pluginArgs
    argsLength = a.length
    # Shall return the Widget, if have arguments and last argument of the call is a Boolean true.
    _returnWidget =
      if argsLength and _.isBoolean a[argsLength - 1]
        argsLength--
        a.pop()
      else
        false
    unless @length
      return if _returnWidget then undefined else @
    # get the first   TODO analize, maybe each?
    jContainer = @first()
    # try to get the Widget-object, controlling everything that happens in our magical container
    widget = jContainer.getWidget(widgetClass)
    if widget and widget.jContainer[0] is jContainer[0]
      command = null
      if argsLength and _.isString a[0]
        command = a.shift()
      else
        return widget  if _returnWidget
        return jContainer  unless argsLength
        command = 'updateSettings'
      if _.isFunction widget[command]
        return widget[command].apply widget, a
      else
        $.error "Command [#{command}] does not exist on jQuery.#{pluginName}()"
    else
      options = if argsLength then a[0] else {}
      if $.isPlainObject options
        widget = Ultimate.createWidget widgetClass, jContainer, options
      else
        $.error "First argument of jQuery.#{pluginName}() must be plain object"
    if _returnWidget then widget else jContainer


# TODO rewrite docs
###
 * Invoke Ultimate Flash functionality for the first element in the set of matched elements.
 * If last argument {Boolean} true, then returns {Widget}.
 * @usage
 *** standart actions ***
 * construction    .ultimateFlash([Object options = {}])                  ~ {jQuery} jContainer
 * show            .ultimateFlash('show', String type, String text)       ~ {jQuery} jFlash | {Boolean} false
 * notice          .ultimateFlash('notice', String text)                  ~ {jQuery} jFlash | {Boolean} false
 * alert           .ultimateFlash('alert', String text)                   ~ {jQuery} jFlash | {Boolean} false
 *** extended actions ***
 * getSettings     .ultimateFlash('getSettings')                          ~ {Object} settings
 * setSettings     .ultimateFlash('setSettings', {Object} settings)       ~ {jQuery} jContainer
 * updateSettings  .ultimateFlash({Object} options)                       ~ {Object} settings
 * auto            .ultimateFlash('auto', {ArrayOrObject} obj)            ~ {Array} ajFlashes | {Boolean} false
 * ajaxSuccess     .ultimateFlash('ajaxSuccess'[, Arguments successArgs = []])
 * ajaxError       .ultimateFlash('ajaxError'[, String text = settings.translations.defaultErrorText][, Arguments errorArgs = []])
###

Ultimate.createPlugin = (widgetClass, pluginName = widgetClass.name) ->
  cout "Ultimate.createPlugin", (typeof widgetClass), pluginName
  jQuery.fn[pluginName] = -> @pluginAdapter widgetClass, pluginName, arguments
