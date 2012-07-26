Backbone.Ultimate ||= {}

class Backbone.Ultimate.App
  @App: null

  name: null

  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  scopes: ["Models", "Collections", "Routers", "Views"]

  constructor: (name = null) ->
    if @constructor.App
      throw new Error("Can't create new Backbone.Ultimate.App because the single instance has already been created");
    else
      @constructor.App = @
      @name = name
      _.extend @[scope], Backbone.Events  for scope in @scopes



_.extend Backbone.Ultimate.App::, Backbone.Events
