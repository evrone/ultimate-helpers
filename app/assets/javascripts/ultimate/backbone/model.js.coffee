#= require ./base

class Ultimate.Backbone.Model extends Backbone.Model

  constructor: ->
    Ultimate.Backbone.debug ".Model.constructor()", @
    super

  ready: (callback, context = @) ->
    if _.isEmpty(@attributes)
      @readyDeferred ||= $.Deferred()
      @readyDeferred.done =>
        callback.apply context, [@]
      @fetch success: (=> @readyDeferred.resolve()), silent: true
    else
      callback.apply context, [@]
