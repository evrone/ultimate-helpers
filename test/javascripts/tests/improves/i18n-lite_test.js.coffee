#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/improves/i18n-lite

module "ultimate/improves/i18n-lite"

I18n.translations =
  models:
    post:
      title: "Post title"
      body: "Post body"

test "locale", ->
  equal I18n.locale, 'en'

test "translate", ->
  ok _.isFunction(I18n.translate)
  ok _.isFunction(I18n.t)
  equal I18n.translate('models.post.missing_key'), 'models.post.missing_key'
  equal I18n.translate('models.post.missing_key', default: 'Default value'), 'Default value'
  equal I18n.translate('models.post.missing_key', default: 0), 0
  equal I18n.translate('models.post.missing_key', default: ''), ''
  equal I18n.translate('models.post.body'), 'Post body'
  equal I18n.t('models.post.body'), 'Post body'
  deepEqual I18n.t('models.post'), title: 'Post title', body: 'Post body'
