# TODO list:
#       * load all locales
#       * pluralize

@I18n = $.extend true,
  {
    locale: "en"
    translations: {}

    translate: (path, options = {}) ->
      path = path.split('.')  if _.isString(path)
      scope = @translations
      for step in path
        scope = scope[step]
        return options['default'] ? path.join('.')  unless scope?
      scope

    t: -> @translate arguments...

  }, @I18n
