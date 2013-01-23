#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/jquery.base

module "ultimate/jquery.base"

test "ror_id", ->
  strictEqual ror_id("some_id_123"), "123"
  strictEqual ror_id("some_id"), null
  strictEqual ror_id($('')), null
  strictEqual ror_id(), null
  strictEqual ror_id($('<div></div>')), null
  jObj = $('<div id="some_123"></div>')
  strictEqual ror_id(jObj), "123"
  strictEqual jObj.data("rorId"), "123"

test "$.fn.rorId", ->
  jObj = $('<div></div>')
  strictEqual jObj.rorId(), null
  strictEqual jObj.rorId(123)[0], jObj[0]
  strictEqual jObj.attr("id"), undefined
  strictEqual jObj.rorId(), 123
  strictEqual jObj.rorId(777, "book").attr("id"), "book_777"
  strictEqual jObj.rorId(), 777

test "$.fn.getClasses", ->
  jObj = $('<div class="apple banana coconut"></div>')
  deepEqual jObj.getClasses(), ["apple", "banana", "coconut"]
  deepEqual jObj.attr('class', '').getClasses(), []

test "$.fn.getAttributes", ->
  deepEqual $("").getAttributes(), {}
  deepEqual $("<div></div>").getAttributes(), {}
  deepEqual $('<div id="some_id_123" class="apple" data-loading-text="Loading..."></div>').getAttributes(), {id: "some_id_123", class: "apple", "data-loading-text": "Loading..."}

test "$.isHTML", ->
  strictEqual $.isHTML(''), false
  strictEqual $.isHTML('Some plain text'), false
  strictEqual $.isHTML('Some plain text with <html></html>'), false
  strictEqual $.isHTML('<span></span><p></p>'), true
  strictEqual $.isHTML('<span></span><p></p>', true), false
  strictEqual $.isHTML('<p><span></span></p>', true), true
