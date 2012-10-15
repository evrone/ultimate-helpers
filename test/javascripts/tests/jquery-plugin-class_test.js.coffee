#= require ultimate/jquery-plugin-class

module "Ultimate.Plugin"

class EmptyPlugin extends Ultimate.Plugin

test "EmptyPlugin", ->
  cout 'EmptyPlugin'
  $('#qunit-fixture').html '<div class="test-plugin"><div class="test-plugin__inner"></div></div>'
  plugin = new EmptyPlugin(el: '.test-plugin')

  throws (-> new EmptyPlugin), "plugin can't build without `el` as option"
  ok /^ultimatePlugin_\d+$/.test(plugin.cid)
  ok plugin.$el.length is 1
  jDiv = plugin.$('div')
  ok jDiv.length is 1
  ok jDiv.hasClass('test-plugin__inner')
  strictEqual plugin.locale, 'en'
  strictEqual plugin.t('smokeString'), 'Smoke string'



class TestPlugin extends Ultimate.Plugin
  someOption: null
  reflectableOptions: -> ['thirdOption']
  @defaultLocales =
    en:
      someMessage: 'English message.'
    ru:
      someMessage: 'Сообщение на русском.'


test "TestPlugin", ->
  cout 'warn', 'TestPlugin'
  $('#qunit-fixture').html '<div class="test-plugin"><a class="action one" href="javascript:;">action one</a><div class="test-plugin__inner"></div></div>'
  plugin = new TestPlugin
    el: '.test-plugin'
    someOption: 'bingo!'
    otherOption: 'ringo!'
    thirdOption: 'dingo!'
    locale: 'de'

  equal plugin.someOption, 'bingo!'
  ok typeof plugin.otherOption is 'undefined'
  equal plugin.thirdOption, 'dingo!'
  equal plugin.locale, 'de'
  deepEqual plugin.translations, {}
#  equal plugin.t('someMessage'), 'Some message'
#  plugin._configure locale: 'ru'
#  deepEqual plugin.translations, {someMessage: 'Сообщение на русском.'}
#  equal plugin.t('someMessage'), 'Сообщение на русском.'

#test "TestPlugin locale from I18n", ->
#  cout 'warn', 'TestPlugin locale from I18n'
#  window.I18n ||= {}
#  _storedI18nLocale = I18n.locale
#  cout '_storeI18nLocale', _storedI18nLocale
#  I18n.locale = 'de'
#  plugin = new TestPlugin el: '.test-plugin'
#  strictEqual plugin.locale, 'en'
#  equal plugin.t('someMessage'), 'English message.'
##  I18n.locale = 'ru'
##  plugin = new TestPlugin el: '.test-plugin'
##  strictEqual plugin.locale, 'ru'
##  equal plugin.t('someMessage'), 'Сообщение на русском.'
#  I18n.locale = _storedI18nLocale
