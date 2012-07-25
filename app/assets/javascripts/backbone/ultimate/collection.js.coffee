Backbone.Ultimate ||= {}

class Backbone.Ultimate.Collection extends Backbone.Collection

  ready: (callback, context = @) ->
    unless @length
      @readyDeferred ||= $.Deferred()
      @readyDeferred.done =>
        callback.apply context, [@]
      @fetch success: (=> @readyDeferred.resolve()), silent: true
    else
      callback.apply context, [@]
