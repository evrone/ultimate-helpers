#= require ./helpers

@Ultimate ||=

  debugMode: false

  debug: ->
    if @debugMode
      a = ["info", "Ultimate"]
      Array::push.apply a, arguments  if arguments.length > 0
      cout.apply @, a
