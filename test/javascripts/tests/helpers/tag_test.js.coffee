#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/helpers/tag

module "Ultimate.Helpers.Tag"

_.extend @, Ultimate.Helpers.Tag

test "tag_options", ->
  strictEqual tag_options(), ""
  strictEqual tag_options({}), ""
  ok /title="Some title"/.test tag_options(class: "some-class", title: "Some title")
  equal tag_options(class: ["song", "play>"]), ' class="song play&gt;"'
  equal tag_options(disabled: true, itemscope: false, multiple: true, readonly: true),  ' disabled="disabled" multiple="multiple" readonly="readonly"'
  equal tag_options(data: {remote: true}, role: "ajax"),  ' data-remote="true" role="ajax"'
  equal tag_options(data: {inner: {section: true}}),  ' data-inner="{&quot;section&quot;:true}"'
  equal tag_options(data: {inner: {section: true}}, false),  ' data-inner="{"section":true}"'
  equal tag_options(included: ''), ' included=""'

test "tag", ->
  equal tag('br'), '<br />'
  equal tag('br', null, true), '<br>'
  equal tag('input', type: 'text', disabled: true), '<input disabled="disabled" type="text" />'
  equal tag('img', src: 'open & shut.png'), '<img src="open &amp; shut.png" />'
  equal tag("img", {src: "open &amp; shut.png"}, false, false), '<img src="open &amp; shut.png" />'
  equal tag("div", data: {name: 'Stephen', city_state: ['Chicago', 'IL']}), '<div data-city-state="[&quot;Chicago&quot;,&quot;IL&quot;]" data-name="Stephen" />'

test "content_tag", ->
  equal content_tag('div', '', class: ['some', 'class']), '<div class="some class"></div>'
  equal content_tag('div', '<Inner content>', class: 'some class'), '<div class="some class">&lt;Inner content&gt;</div>'
  equal content_tag('div', '<Inner content>', class: 'some class', false), '<div class="some class"><Inner content></div>'
  equal content_tag('div', class: 'some class', -> '<Inner content>'), '<div class="some class">&lt;Inner content&gt;</div>'
  equal content_tag('div', class: 'some class', false, -> '<Inner content>'), '<div class="some class">&lt;Inner content&gt;</div>'

test "cdata_section", ->
  equal cdata_section("<hello world>"), "<![CDATA[<hello world>]]>"
  equal cdata_section("hello]]>world"), "<![CDATA[hello]]]]><![CDATA[>world]]>"
  equal cdata_section("hello]]>world]]>again"), "<![CDATA[hello]]]]><![CDATA[>world]]]]><![CDATA[>again]]>"
