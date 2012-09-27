#= require ultimate/underscore/underscore
#= require ultimate/jquery-plugin-class
#= require ultimate/jquery-plugin-adapter

module "jquery-plugin-adapter"

class TestPlugin extends Ultimate.Plugin

test "Ultimate.createJQueryPlugin", ->
  testPlugin = Ultimate.createJQueryPlugin("testPlugin", TestPlugin)
  ok _.isFunction(testPlugin)
