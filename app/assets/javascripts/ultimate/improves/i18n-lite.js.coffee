# TODO list
#       * load all locales

@I18n ||=
  locale: "en"
  translations: {}

  t: (path) ->
    path = path.split('.')  if _.isString(path)
    scope = @translations
    for step in path
      scope = scope[step]
      return path.join('.')  unless scope
    scope
