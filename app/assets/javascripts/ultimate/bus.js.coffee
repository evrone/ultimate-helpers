# TODO bus as class
# TODO may be, settable maxInstances
# TODO tree presentative logic in eventName syntax provided by ':', '.', ...
# require underscore

class EventBus

  events: {}

  #constructor: ->

  bind: (eventName, callback) ->
    if @events[eventName]
      @events[eventName].push callback
    else
      @events[eventName] = [callback]
    true

  # TODO simplify logic
  unbind: (eventName, callback = null) ->
    if eventName
      if eventsHeap = @events[eventName]
        if callback
          i = _.indexOf eventsHeap, callback
          if i >= 0
            eventsHeap.splice i, 1
            true
          else
            false
        else
          delete @events[eventName]
      else
        false
    else
      if callback
        # TODO return boolean
        @unbind eventName, callback  for eventName, eventsHeap of @events
      else
        false

  has: (eventName, callback = null) ->
    if eventsHeap = @events[eventName]
      if callback
         _.include eventsHeap, callback
      else
        true
    else
      false

  trigger: (eventName, callbackArguments...) ->
    for callback in @events[eventName] or []
      callback.apply(@, callbackArguments)



# transitional instance
@bus = new EventBus
