#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/underscore/underscore.outcasts
#= require ultimate/helpers/javascript

module "Ultimate.Helpers.Javascript"

_.extend @, Ultimate.Helpers.Javascript

test "escape_javascript", ->
  strictEqual escape_javascript(null), ''
  equal escape_javascript('This "thing" is really\n netos\''), 'This \\"thing\\" is really\\n netos\\\''
  equal escape_javascript('backslash\\test'), 'backslash\\\\test'
  equal escape_javascript('dont </close> tags'), 'dont <\\/close> tags'
#  equal escape_javascript('unicode \\342\\200\\250 newline'), 'unicode &#x2028; newline'
#  equal escape_javascript('unicode \\342\\200\\251 newline'), 'unicode &#x2029; newline'
  equal j('dont </close> tags'), 'dont <\\/close> tags'
  equal escape_javascript('\'quoted\' "double-quoted" new-line:\n </closed>'), '\\\'quoted\\\' \\"double-quoted\\" new-line:\\n <\\/closed>'

test "javascript_tag", ->
  equal javascript_tag("alert('hello')"), "<script>\n//<![CDATA[\nalert('hello')\n//]]>\n</script>"
  equal javascript_tag("alert('hello')", id: "the_js_tag"), "<script id=\"the_js_tag\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>"

test "javascript_cdata_section", ->
  equal javascript_cdata_section("alert('hello')"), "\n//<![CDATA[\nalert('hello')\n//]]>\n"
