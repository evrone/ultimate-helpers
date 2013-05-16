#= require ultimate/base

@Ultimate.Helpers ||=
  version: '0.2.0'

  globalizeScopes: (include = false, exclude = false) ->
    for scopeName, scope of @  when /^[A-Z]/.test(scopeName)
      if (not include or scopeName in include) and not (exclude and scopeName in exclude)
        _.extend window, scope

  scopes: ->
    _.filter( _.keys(@), (key) -> /^[A-Z]/.test(key) )

#  underscored version
#  globalizeScopes: (include = false, exclude = false) ->
#    keys = _.filter( _.keys(@), (key) -> /^[A-Z]/.test(key) )
#    keys = _.intersection(keys, include)  if include
#    keys = _.difference(keys, exclude)  if exclude
#    for scopeName in keys
#      _.extend window, @[scopeName]
