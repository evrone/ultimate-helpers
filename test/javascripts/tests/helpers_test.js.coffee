#= require ultimate/underscore/underscore
#= require ultimate/helpers

module "ultimate/helpers"

test "cout", ->
  ok _.isBoolean(window.DEBUG_MODE), "global DEBUG_MODE is Boolean"
  window.DEBUG_MODE = true
  strictEqual cout(123), 123, "cout() must return first argument"
  window.DEBUG_MODE = false
  for method in ['log', 'info', 'warn', 'error', 'assert', 'clear']
    strictEqual cout(method, 123), 123, "cout() must return second argument if first is `#{method}` as method"
  window.DEBUG_MODE = true

test "_cout", ->
  strictEqual _cout(123), 123, "_cout() must return first argument"
  for method in ['log', 'info', 'warn', 'error', 'assert', 'clear']
    strictEqual _cout(method, 123), method, "_cout() on so strong that it does not use the method `#{method}` as first argument, and return first argument always"

test "deprecate", ->
  equal deprecate('first thing'), "`first thing` DEPRECATED!", "log and return message about deprecated function"
  equal deprecate('first thing', 'second thing'), "`first thing` DEPRECATED! Use instead `second thing`", "log and return message about deprecated function, and hint about using instead"

test "todo", ->
  ok _.isBoolean(window.LOG_TODO), "global LOG_TODO is Boolean"
  window.LOG_TODO = true
  equal todo('some todo'), "TODO: some todo", "log and return todo"
  equal todo('some todo', "helpers_test.js.coffee"), "TODO: some todo ### helpers_test.js.coffee", "log and return todo with location string"
  equal todo('some todo', "helpers_test.js.coffee", "test \"deprecate\""), "TODO: some todo ### helpers_test.js.coffee > test \"deprecate\"", "log and return todo with description of function"
  equal todo('some todo', "helpers_test.js.coffee", 12), "TODO: some todo ### helpers_test.js.coffee:12", "log and return message with string number"
  window.LOG_TODO = false
  equal todo('some todo'), undefined, "don't log and return `undefined` if global LOG_TODO == false"
  window.LOG_TODO = true

test "logicalXOR", ->
  strictEqual logicalXOR(false, false), false,  "false  XOR false === false"
  strictEqual logicalXOR(false, true),  true,   "false  XOR true  === true"
  strictEqual logicalXOR(true, false),  true,   "true   XOR false === true"
  strictEqual logicalXOR(true, true),   false,  "true   XOR true  === false"

test "bound", ->
  equal bound(0, 10, 100), 10
  equal bound(100, 10, 100), 100
  equal bound(50, 10, 100), 50
  equal bound(-20, -10, 100), -10
  equal bound(-20, 10, -10), 10
  equal bound(20, 10, -10), 10
