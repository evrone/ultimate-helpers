#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/underscore/underscore.outcasts
#= require ultimate/helpers/form_options

module "Ultimate.Helpers.FormOptions"

_.extend @, Ultimate.Helpers.FormOptions

test "options_for_select", ->
  options = '<option value="Denmark">Denmark</option><option value="USA">USA</option><option value="Sweden">Sweden</option>'
  equal options_for_select(options), options
  equal options_for_select([ "<Denmark>", "USA", "Sweden" ]),
        "<option value=\"&lt;Denmark&gt;\">&lt;Denmark&gt;</option>\n<option value=\"USA\">USA</option>\n<option value=\"Sweden\">Sweden</option>"
  equal options_for_select([ "Denmark", "<USA>", "Sweden" ], "<USA>"),
        "<option value=\"Denmark\">Denmark</option>\n<option selected=\"selected\" value=\"&lt;USA&gt;\">&lt;USA&gt;</option>\n<option value=\"Sweden\">Sweden</option>"
  equal options_for_select([ "Denmark", "<USA>", "Sweden" ], [ "<USA>", "Sweden" ]),
        "<option value=\"Denmark\">Denmark</option>\n<option selected=\"selected\" value=\"&lt;USA&gt;\">&lt;USA&gt;</option>\n<option selected=\"selected\" value=\"Sweden\">Sweden</option>"
  equal options_for_select([ "Denmark", "<USA>", "Sweden" ], disabled: "<USA>"),
        "<option value=\"Denmark\">Denmark</option>\n<option disabled=\"disabled\" value=\"&lt;USA&gt;\">&lt;USA&gt;</option>\n<option value=\"Sweden\">Sweden</option>"
  equal options_for_select([ "Denmark", "<USA>", "Sweden" ], disabled: ["<USA>", "Sweden"]),
        "<option value=\"Denmark\">Denmark</option>\n<option disabled=\"disabled\" value=\"&lt;USA&gt;\">&lt;USA&gt;</option>\n<option disabled=\"disabled\" value=\"Sweden\">Sweden</option>"
  equal options_for_select([ "Denmark", "<USA>", "Sweden" ], selected: "Denmark", disabled: "<USA>"),
        "<option selected=\"selected\" value=\"Denmark\">Denmark</option>\n<option disabled=\"disabled\" value=\"&lt;USA&gt;\">&lt;USA&gt;</option>\n<option value=\"Sweden\">Sweden</option>"
  equal options_for_select([ true, false ], selected: false, disabled: null),
        "<option value=\"true\">true</option>\n<option selected=\"selected\" value=\"false\">false</option>"
  equal options_for_select([1..3]),
        "<option value=\"1\">1</option>\n<option value=\"2\">2</option>\n<option value=\"3\">3</option>"
  equal options_for_select([ "ruby", "rubyonrails" ], "rubyonrails"),
        "<option value=\"ruby\">ruby</option>\n<option selected=\"selected\" value=\"rubyonrails\">rubyonrails</option>"
  equal options_for_select([ "ruby", "rubyonrails" ], "ruby"),
        "<option selected=\"selected\" value=\"ruby\">ruby</option>\n<option value=\"rubyonrails\">rubyonrails</option>"
  equal options_for_select([ "ruby", "rubyonrails", null ], "ruby"),
        "<option selected=\"selected\" value=\"ruby\">ruby</option>\n<option value=\"rubyonrails\">rubyonrails</option>\n<option value=\"\"></option>"
  equal options_for_select("$": "Dollar", "<DKR>": "<Kroner>"),
        "<option value=\"Dollar\">$</option>\n<option value=\"&lt;Kroner&gt;\">&lt;DKR&gt;</option>"
  equal options_for_select({ "$": "Dollar", "<DKR>": "<Kroner>" }, "Dollar"),
        "<option selected=\"selected\" value=\"Dollar\">$</option>\n<option value=\"&lt;Kroner&gt;\">&lt;DKR&gt;</option>"
  equal options_for_select({ "$": "Dollar", "<DKR>": "<Kroner>" }, [ "Dollar", "<Kroner>" ]),
        "<option selected=\"selected\" value=\"Dollar\">$</option>\n<option selected=\"selected\" value=\"&lt;Kroner&gt;\">&lt;DKR&gt;</option>"
  equal options_for_select([ [ "<Denmark>", { class: 'bold' } ], [ "USA", { onclick: "alert('Hello World');" } ], [ "Sweden" ], "Germany" ]),
        "<option class=\"bold\" value=\"&lt;Denmark&gt;\">&lt;Denmark&gt;</option>\n<option onclick=\"alert(&apos;Hello World&apos;);\" value=\"USA\">USA</option>\n<option value=\"Sweden\">Sweden</option>\n<option value=\"Germany\">Germany</option>"
  equal options_for_select([ [ "<Denmark>", { data: { test: 'bold' } } ] ]),
        "<option data-test=\"bold\" value=\"&lt;Denmark&gt;\">&lt;Denmark&gt;</option>"
  equal options_for_select([ [ "<Denmark>", { data: { test: '<bold>' } } ] ]),
        "<option data-test=\"&lt;bold&gt;\" value=\"&lt;Denmark&gt;\">&lt;Denmark&gt;</option>"
  equal options_for_select([ "<Denmark>", [ "USA", { class: 'bold' } ], "Sweden" ], "USA"),
        "<option value=\"&lt;Denmark&gt;\">&lt;Denmark&gt;</option>\n<option class=\"bold\" selected=\"selected\" value=\"USA\">USA</option>\n<option value=\"Sweden\">Sweden</option>"
  equal options_for_select([ "<Denmark>", [ "USA", { class: 'bold' } ], "Sweden" ], [ "USA", "Sweden" ]),
        "<option value=\"&lt;Denmark&gt;\">&lt;Denmark&gt;</option>\n<option class=\"bold\" selected=\"selected\" value=\"USA\">USA</option>\n<option selected=\"selected\" value=\"Sweden\">Sweden</option>"
  equal options_for_select([ [ "<Denmark>", { onclick: 'alert("<code>")' } ] ]),
        "<option onclick=\"alert(&quot;&lt;code&gt;&quot;)\" value=\"&lt;Denmark&gt;\">&lt;Denmark&gt;</option>"
