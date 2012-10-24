#= require ./base

class Ultimate.Backbone.Collection extends Backbone.Collection

  readyDeferred: null
  loaded: false
  loadedTimeStamp: null
  expireTime: Infinity

  constructor: (models, options = {}) ->
    Ultimate.Backbone.debug ".Collection.constructor()", @
    @expireTime = options.expireTime  if options.expireTime?
    super

  reset: (models, options) ->
    @loadedTimeStamp = new Date()
    @loaded = true
    super

  ready: (callback, fetchOptions) ->
    lifeTime = if @loadedTimeStamp then (new Date() - @loadedTimeStamp) else 0
    if expired = lifeTime > @expireTime
      @readyDeferred = null
    if (not @length and not @loaded) or expired
      @readyDeferred ||= @fetch(fetchOptions)
      @readyDeferred.done =>
        callback.apply @
    else
      callback.apply @
