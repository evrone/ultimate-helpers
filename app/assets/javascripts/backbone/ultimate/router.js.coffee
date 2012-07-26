Backbone.Ultimate ||= {}

class Backbone.Ultimate.Router extends Backbone.Router

  namedParam    = /:\w+/g
  splatParam    = /\*\w+/g
  escapeRegExp  = /[-[\]{}()+?.,\\^$|#\s]/g

  _routeToRegExp: (route) ->
    route = route.replace(escapeRegExp, '\\$&')
                 .replace(namedParam, '([^\/]+)')
                 .replace(splatParam, '(.*?)')
    new RegExp("^\/?#{route}\/?$")
