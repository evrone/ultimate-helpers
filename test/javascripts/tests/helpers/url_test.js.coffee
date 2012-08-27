#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/helpers/url

module "Ultimate.Helpers.Url"

_.extend @, Ultimate.Helpers.Url

test "url_for", ->
  strictEqual url_for(), 'javascript:;'
  strictEqual url_for({}), 'javascript:;'
  strictEqual url_for(gamma: 2.2), '?gamma=2.2'
  strictEqual url_for(gamma: 2.2, url: 'some_url'), 'some_url?gamma=2.2'
#  strictEqual url_for(host: "www.example.com"), 'http://www.example.com/'
  strictEqual url_for(url: -> 'some_url'), 'some_url'
  options = gamma: 2.2, anchor: 'comments', url: 'some_url', lambda: false
  strictEqual url_for(options), 'some_url?gamma=2.2&lambda=false#comments'
  deepEqual options, gamma: 2.2, anchor: 'comments', url: 'some_url', lambda: false
  strictEqual url_for("back"), 'javascript:history.back();'
  strictEqual url_for("/back"), '/back'

test "link_to", ->
  strictEqual link_to('Hello', 'http://www.example.com'), '<a href="http://www.example.com">Hello</a>'
  strictEqual link_to('Test Link', '/'), '<a href="/">Test Link</a>'
  strictEqual link_to(null, 'http://ya.ru/'), '<a href="http://ya.ru/">http://ya.ru/</a>'
  strictEqual link_to('caption'), '<a href="javascript:;">caption</a>'
  strictEqual link_to("Hello", "http://www.example.com", class: "red", data: {confirm: 'You cant possibly be sure,\n can you?'}),
              '<a class="red" data-confirm="You cant possibly be sure,\n can you?" href="http://www.example.com">Hello</a>'
