#  require:
#    jquery ~> 1.7.0
#    underscore ~> 1.3.0

#= require ultimate/helpers

@Ultimate ||= {}

@Ultimate.Backbone =

  debugMode: false

  debug: ->
    if @debugMode
      a = ["info", "Ultimate.Backbone"]
      Array::push.apply a, arguments  if arguments.length > 0
      cout.apply @, a

  isView: (view) -> view instanceof Backbone.View

  isViewClass: (viewClass) -> (viewClass::) instanceof Backbone.View

  isModel: (model) -> model instanceof Backbone.Model

  isCollection: (collection) -> collection instanceof Backbone.Collection

  isRouter: (router) -> router instanceof Backbone.Router
