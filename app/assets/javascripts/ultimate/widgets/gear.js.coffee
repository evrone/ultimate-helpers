# Ultimate base object
#   * base OOP improves
#   * instances controls
#   * options and settings controls
#   * translations

console.log 'Ultimate.Proto.Gear', Ultimate  if console?

class Ultimate.Proto.Gear

  @className: 'Gear'

  # commented because must be uniq for independent widgets
  #@instances: []
  @maxInstances: Infinity  # 0 for intrfaces, 1 for singleton

  @canCreateInstance = ->
    cout 'info', 'Gear.canCreateInstance', @name, @instances, @maxInstances
    (@instances or []).length < @maxInstances

  @pushInstance = (instance) ->
    @instances ||= []
    @instances.push instance



  @defaults:
    constants: {}
    locales:
      'en':
        description: 'Base Ultimate js Class'
      'ru':
        description: 'Базовай Ultimate js-класс'
    options:
      locale: 'en'
      translations: {}

  settings: {}

  uniqId: null

  debugMode: false

  constructor: (options = {}) ->
    @uniqId = _.uniqueId @constructor.className
    @constructor.pushInstance @
    @updateSettings @constructor.defaults.options
    @updateSettings @initTranslations(options)
    @debug "#{@constructor.className}.constructor()", @uniqId, options

  # use I18n, and modify locale and translations in options
  # modify and return merged data
  initTranslations: (options) ->
    # if global compatible I18n
    if I18n? and I18n.locale and I18n.t
      options['locale'] ?= I18n.locale
      if options['locale'] is I18n.locale
        # pointing to defaults locales of language specified in I18n
        _defaultLocales = @constructor.defaults.locales[I18n.locale]
        unless _defaultLocales['loaded']
          _defaultLocales['loaded'] = true
          # try read localized strings
          if _localesFromI18n = I18n.t options['i18nKey'] or _.underscored(@constructor.className)
            # fill it from I18n
            _defaultLocales[_.camelize key] = value  for key, value of _localesFromI18n
    options

  getSettings: ->
    @settings

  setSettings: (settings) ->
    @settings = settings

  updateSettings: (options) ->
    cout 'updateSettings', options
    for optionsKey, optionsValue of options when optionsKey in @ then @[optionsKey] = optionsValue
    translations = if (l = options['locale']) then @constructor.defaults.locales[l] or {} else {}
    $.extend true, @settings, translations: translations, options

  debug: ->
    if @settings.debugMode
      a = ["DEBUG | #{@constructor.className}   >>> "]
      Array::push.apply a, arguments
      cout.apply @, a
