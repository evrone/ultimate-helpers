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

test "invert", ->
  deepEqual _.invert(a: 1, b: 2, c: 0), {1: 'a', 2: 'b', 0: 'c'}
  obj =
    a: 1
    b: 2
    c: 0
    d: 1
    2: 'e-1'
    f: -> 'func'
  deepEqual _.invert(obj), {1: ['a', 'd'], 2: 'b', 0: 'c', 'e-1': '2'}
  deepEqual _.invert(_.invert(obj)), {a: '1', b: '2', c: '0', d: '1', 2: 'e-1'}
  deepEqual _.invert(), {}

test "scan", ->
  a = "cruel world"
  deepEqual _.scan(a, /\w+/)      , ["cruel", "world"]
  deepEqual _.scan(a, /.../)      , ["cru", "el ", "wor"]
  deepEqual _.scan(a, /(...)/)    , [["cru"], ["el "], ["wor"]]
  deepEqual _.scan(a, /(..)(..)/) , [["cr", "ue"], ["l ", "wo"]]
  equal _.scan(a, /\w+/, (w) -> "<<#{w}>> ").join(''), '<<cruel>> <<world>> '
  equal _.scan(a, /(.)(.)/, (x, y) -> y + x).join(''), 'rceu lowlr'
