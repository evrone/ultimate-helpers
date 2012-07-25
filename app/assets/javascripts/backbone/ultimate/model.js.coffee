Backbone.Ultimate ||= {}

class Backbone.Ultimate.Model extends Backbone.Model

  ready: (callback, context = @) ->
    if _.isEmpty(@attributes)
      @readyDeferred ||= $.Deferred()
      @readyDeferred.done =>
        callback.apply context, [@]
      @fetch success: (=> @readyDeferred.resolve()), silent: true
    else
      callback.apply context, [@]
