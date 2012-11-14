#  * Require ./../underscore/underscore.string
#  * Require ./../underscore/underscore.inflection
#= require ./base

class Ultimate.Backbone.Model extends Backbone.Model

  readyDeferred: null
  loaded: false
  loadedTimeStamp: null
  expireTime: Infinity

  constructor: (attributes, options = {}) ->
    Ultimate.Backbone.debug ".Model.constructor()", @
    @expireTime = options.expireTime  if options.expireTime?
    @on 'sync', =>
      @loadedTimeStamp = new Date()
      @loaded = true
    super

  ready: (callback, fetchOptions) ->
    lifeTime = if @loadedTimeStamp then (new Date() - @loadedTimeStamp) else 0
    if expired = lifeTime > @expireTime
      @readyDeferred = null
    if @id and (not @loaded or expired)
      @readyDeferred ||= @fetch(fetchOptions)
      @readyDeferred.done =>
        callback.apply @
    else
      callback.apply @

  abort: ->
    if @readyDeferred?
      if @readyDeferred.state() is 'pending'
        @readyDeferred.abort()
        @readyDeferred = null

  singular: ->
    modelName = @constructor.modelName or @modelName or @className or @constructor.name or 'Model'
    _.singularize(_.string.underscored(modelName))
