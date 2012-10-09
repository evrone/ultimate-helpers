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



class Post
  title           : null
  author_name     : null
  body            : null
  secret          : null
  written_on      : null
  category        : null
  origin          : null
  allow_comments  : null

  constructor: ->
    keys = ['title', 'author_name', 'body', 'secret', 'written_on', 'category', 'origin', 'allow_comments']
    for a, i in arguments
      @[keys[i]] = a

dummy_posts =
  [ new Post("<Abe> went home", "<Abe>", "To a little house", "shh!"),
    new Post("Babe went home", "Babe", "To a little house", "shh!"),
    new Post("Cabe went home", "Cabe", "To a little house", "shh!") ]

test "options_from_collection_for_select", ->
  equal options_from_collection_for_select(dummy_posts, "author_name", "title"),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option value=\"Babe\">Babe went home</option>\n<option value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", "title", "Babe"),
  "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option selected=\"selected\" value=\"Babe\">Babe went home</option>\n<option value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", "title", [ "Babe", "Cabe" ]),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option selected=\"selected\" value=\"Babe\">Babe went home</option>\n<option selected=\"selected\" value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", "title", (p) -> p.author_name is 'Babe'),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option selected=\"selected\" value=\"Babe\">Babe went home</option>\n<option value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", "title", disabled: "Babe"),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option disabled=\"disabled\" value=\"Babe\">Babe went home</option>\n<option value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", "title", disabled: [ "Babe", "Cabe" ]),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option disabled=\"disabled\" value=\"Babe\">Babe went home</option>\n<option disabled=\"disabled\" value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", "title", selected: "Cabe", disabled: "Babe"),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option disabled=\"disabled\" value=\"Babe\">Babe went home</option>\n<option selected=\"selected\" value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", "title", disabled: (p) -> p.author_name in ['Babe', 'Cabe']),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option disabled=\"disabled\" value=\"Babe\">Babe went home</option>\n<option disabled=\"disabled\" value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, ((p) -> p.author_name), "title"),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option value=\"Babe\">Babe went home</option>\n<option value=\"Cabe\">Cabe went home</option>"
  equal options_from_collection_for_select(dummy_posts, "author_name", (p) -> p.title),
        "<option value=\"&lt;Abe&gt;\">&lt;Abe&gt; went home</option>\n<option value=\"Babe\">Babe went home</option>\n<option value=\"Cabe\">Cabe went home</option>"
