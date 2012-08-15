#= require ./base

class Ultimate.Backbone.App
  @App: null

  name: null

  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  scopes: ["Models", "Collections", "Routers", "Views"]

  constructor: (name = null) ->
    Ultimate.Backbone.debug ".App.constructor()", @
    if @constructor.App
      throw new Error("Can't create new Ultimate.Backbone.App because the single instance has already been created");
    else
      @constructor.App = @
      @name = name
      _.extend @[scope], Backbone.Events  for scope in @scopes



_.extend Ultimate.Backbone.App::, Backbone.Events
