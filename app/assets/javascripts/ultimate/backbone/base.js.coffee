#= require ultimate/helpers

(@Ultimate ||= {}).Backbone =

  debugMode: false

  debug: ->
    if @debugMode
      a = ["info", "Ultimate.Backbone"]
      Array::push.apply a, arguments  if arguments.length > 0
      cout.apply @, a

  isView: (viewClass) -> viewClass instanceof Backbone.View

  isViewClass: (viewClass) -> (viewClass::) instanceof Backbone.View
