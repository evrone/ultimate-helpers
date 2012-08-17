#= require ../view
#= require ultimate/improves/typed-fields

Ultimate.Backbone.Observers ||= {}

class Ultimate.Backbone.Observers.TypedFields extends Ultimate.Backbone.View

  selector: "input:text[data-data-type], input:text[data-regexp-mask]"

  events: ->
    "keypress   selector": "onKeyPress"
    "change     selector": "onChange"
    "paste      selector": "onPasteOrDrop"
    "drop       selector": "onPasteOrDrop"

  viewOptions: ["selector"]

  onKeyPress: (event) ->
    if event.metaKey
      @onPasteOrDrop event
      return true
    return true  unless event.charCode
    jField = $(event.currentTarget)
    oldValue = jField.val()
    newValue = oldValue.substring(0, @selectionStart) + String.fromCharCode(event.charCode) + oldValue.substring(@selectionEnd)
    return false  unless jField.getRegExpMask().test(newValue)
    jField.data "value", newValue

  onChange: (event) ->
    jField = $(event.currentTarget)
    if jField.getRegExpMask().test(jField.val())
      jField.data "value", jField.val()
    else
      jField.val jField.data("value")

  onPasteOrDrop: (event) ->
    setTimeout ( -> $(event.currentTarget).trigger "change", arguments ), 100



Ultimate.Backbone.createJQueryPlugin? "typedFields", Ultimate.Backbone.Observers.TypedFields
