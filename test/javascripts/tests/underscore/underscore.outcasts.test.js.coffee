#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.outcasts

# Include Underscore.outcasts methods to Underscore namespace
_.mixin(_.outcasts.exports())

module('Underscore.outcasts')

test "delete", ->
  obj = a: 'Apple', b: 'Banana'
  equal _.delete(obj, 'a'), 'Apple'
  deepEqual obj, {b: 'Banana'}

test "blockGiven", ->
  do (v1 = 111, v2 = 222, v3 = 333) ->
    strictEqual _.blockGiven(arguments), null
    strictEqual _.blockGiven([]), null
  do (v1 = 111, v2 = 222, block = (_v) -> "block #{_v}") ->
    ok _.isFunction(_.blockGiven(arguments))
    equal _.blockGiven(arguments)('given'), "block given"

test "sortHash", ->
  deepEqual _.sortHash({}), []
  deepEqual _.sortHash(title: 'cadabra', alt: 'bubble', href: 'abra'), [['alt', 'bubble'], ['href', 'abra'], ['title', 'cadabra']]
  deepEqual _.sortHash(title: 'cadabra', alt: 'bubble', href: 'abra', true), [['href', 'abra'], ['alt', 'bubble'], ['title', 'cadabra']]
