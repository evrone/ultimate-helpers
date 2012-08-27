#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/helpers/tag

module "Ultimate.Helpers.Tag"

_.extend @, Ultimate.Helpers.Tag

test "tag_options", ->
  strictEqual tag_options(), ""
  strictEqual tag_options({}), ""
  ok /title="Some title"/.test tag_options(class: "some-class", title: "Some title")
  strictEqual tag_options(class: ["song", "play>"]), ' class="song play&gt;"'
  strictEqual tag_options(disabled: true, itemscope: false, multiple: true, readonly: true),  ' disabled="disabled" multiple="multiple" readonly="readonly"'
  strictEqual tag_options(data: {remote: true}, role: "ajax"),  ' data-remote="true" role="ajax"'
  strictEqual tag_options(data: {inner: {section: true}}),  ' data-inner="{&quot;section&quot;:true}"'
  strictEqual tag_options(data: {inner: {section: true}}, false),  ' data-inner="{"section":true}"'
  strictEqual tag_options(included: ''), ' included=""'

test "tag", ->
  strictEqual tag('br'), '<br />'
  strictEqual tag('br', null, true), '<br>'
  strictEqual tag('input', type: 'text', disabled: true), '<input disabled="disabled" type="text" />'
  strictEqual tag('img', src: 'open & shut.png'), '<img src="open &amp; shut.png" />'
#  strictEqual tag("img", {src: "open &amp; shut.png"}, false, false), '<img src="open &amp; shut.png" />'
#  strictEqual tag("div", data: {name: 'Stephen', city_state: "(Chicago IL)"}), '<div data-name="Stephen" data-city-state="[&quot;Chicago&quot;,&quot;IL&quot;]" />'

test "content_tag", ->
  strictEqual content_tag('div', '', class: ['some', 'class']), '<div class="some class"></div>'
  strictEqual content_tag('div', '<Inner content>', class: 'some class'), '<div class="some class">&lt;Inner content&gt;</div>'
  strictEqual content_tag('div', '<Inner content>', class: 'some class', false), '<div class="some class"><Inner content></div>'
  strictEqual content_tag('div', class: 'some class', -> '<Inner content>'), '<div class="some class">&lt;Inner content&gt;</div>'
  strictEqual content_tag('div', class: 'some class', false, -> '<Inner content>'), '<div class="some class">&lt;Inner content&gt;</div>'
