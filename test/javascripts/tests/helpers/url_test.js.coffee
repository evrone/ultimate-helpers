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
  strictEqual link_to('caption', null, class: 'link'), '<a class="link" href="javascript:;">caption</a>'
  strictEqual link_to("Hello", "http://www.example.com", class: "red", data: {confirm: 'You cant possibly be sure,\n can you?'}),
  '<a class="red" data-confirm="You cant possibly be sure,\n can you?" href="http://www.example.com">Hello</a>'
  strictEqual link_to(null, -> 'caption'), '<a href="javascript:;">caption</a>'
  strictEqual link_to(-> 'caption'), '<a href="javascript:;">caption</a>'

test "link_to_js", ->
  strictEqual link_to_js('caption'), '<a href="javascript:;">caption</a>'
  strictEqual link_to_js('caption', class: 'link'), '<a class="link" href="javascript:;">caption</a>'
  strictEqual link_to_js("Hello", class: "red", data: {confirm: 'You cant possibly be sure,\n can you?'}),
  '<a class="red" data-confirm="You cant possibly be sure,\n can you?" href="javascript:;">Hello</a>'
  strictEqual link_to_js(null, -> 'caption'), '<a href="javascript:;">caption</a>'
  strictEqual link_to_js(class: 'link', -> 'caption'), '<a class="link" href="javascript:;">caption</a>'
  strictEqual link_to_js(-> 'caption'), '<a href="javascript:;">caption</a>'

test "mail_to", ->
  equal mail_to("david@loudthinking.com"),
        '<a href="mailto:david@loudthinking.com">david@loudthinking.com</a>'
  equal mail_to("david@loudthinking.com", "David Heinemeier Hansson"),
        '<a href="mailto:david@loudthinking.com">David Heinemeier Hansson</a>'
  equal mail_to("david@loudthinking.com", "David Heinemeier Hansson", class: "admin"),
        '<a class="admin" href="mailto:david@loudthinking.com">David Heinemeier Hansson</a>'
  equal mail_to("me@domain.com", "My email", encode: "javascript"),
        "<script>eval(decodeURIComponent('%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%27%3c%61%20%68%72%65%66%3d%5c%22%6d%61%69%6c%74%6f%3a%6d%65%40%64%6f%6d%61%69%6e%2e%63%6f%6d%5c%22%3e%4d%79%20%65%6d%61%69%6c%3c%5c%2f%61%3e%27%29%3b'))</script>"
#  equal mail_to("unicode@example.com", "únicode", encode: "javascript"),
#        "<script>eval(decodeURIComponent('%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%27%3c%61%20%68%72%65%66%3d%5c%22%6d%61%69%6c%74%6f%3a%75%6e%69%63%6f%64%65%40%65%78%61%6d%70%6c%65%2e%63%6f%6d%5c%22%3e%c3%ba%6e%69%63%6f%64%65%3c%5c%2f%61%3e%27%29%3b'))</script>"
  equal mail_to("me@example.com", "My email", cc: "ccaddress@example.com", bcc: "bccaddress@example.com", subject: "This is an example email", body: "This is the body of the message."),
        '<a href="mailto:me@example.com?cc=ccaddress%40example.com&amp;bcc=bccaddress%40example.com&amp;body=This%20is%20the%20body%20of%20the%20message.&amp;subject=This%20is%20an%20example%20email">My email</a>'
  equal mail_to('feedback@example.com', '<img src="/feedback.png" />'),
        '<a href="mailto:feedback@example.com"><img src="/feedback.png" /></a>'
  equal mail_to("me@domain.com", "My email", encode: "hex"),
        '<a href="&#109;&#97;&#105;&#108;&#116;&#111;&#58;%6d%65@%64%6f%6d%61%69%6e.%63%6f%6d">My email</a>'
  equal mail_to("me@domain.com", null, encode: "hex"),
        '<a href="&#109;&#97;&#105;&#108;&#116;&#111;&#58;%6d%65@%64%6f%6d%61%69%6e.%63%6f%6d">&#109;&#101;&#64;&#100;&#111;&#109;&#97;&#105;&#110;&#46;&#99;&#111;&#109;</a>'
  equal mail_to("wolfgang@stufenlos.net", null, replace_at: "(at)", replace_dot: "(dot)"),
        '<a href="mailto:wolfgang@stufenlos.net">wolfgang(at)stufenlos(dot)net</a>'
  equal mail_to("me@domain.com", null, encode: "hex", replace_at: "(at)"),
        '<a href="&#109;&#97;&#105;&#108;&#116;&#111;&#58;%6d%65@%64%6f%6d%61%69%6e.%63%6f%6d">&#109;&#101;&#40;&#97;&#116;&#41;&#100;&#111;&#109;&#97;&#105;&#110;&#46;&#99;&#111;&#109;</a>'
  equal mail_to("me@domain.com", "My email", encode: "hex", replace_at: "(at)"),
        '<a href="&#109;&#97;&#105;&#108;&#116;&#111;&#58;%6d%65@%64%6f%6d%61%69%6e.%63%6f%6d">My email</a>'
  equal mail_to("me@domain.com", null, encode: "hex", replace_at: "(at)", replace_dot: "(dot)"),
        '<a href="&#109;&#97;&#105;&#108;&#116;&#111;&#58;%6d%65@%64%6f%6d%61%69%6e.%63%6f%6d">&#109;&#101;&#40;&#97;&#116;&#41;&#100;&#111;&#109;&#97;&#105;&#110;&#40;&#100;&#111;&#116;&#41;&#99;&#111;&#109;</a>'
  equal mail_to("me@domain.com", "My email", encode: "javascript", replace_at: "(at)", replace_dot: "(dot)"),
        "<script>eval(decodeURIComponent('%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%27%3c%61%20%68%72%65%66%3d%5c%22%6d%61%69%6c%74%6f%3a%6d%65%40%64%6f%6d%61%69%6e%2e%63%6f%6d%5c%22%3e%4d%79%20%65%6d%61%69%6c%3c%5c%2f%61%3e%27%29%3b'))</script>"
  equal mail_to("me@domain.com", null, encode: "javascript", replace_at: "(at)", replace_dot: "(dot)"),
        "<script>eval(decodeURIComponent('%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%27%3c%61%20%68%72%65%66%3d%5c%22%6d%61%69%6c%74%6f%3a%6d%65%40%64%6f%6d%61%69%6e%2e%63%6f%6d%5c%22%3e%6d%65%28%61%74%29%64%6f%6d%61%69%6e%28%64%6f%74%29%63%6f%6d%3c%5c%2f%61%3e%27%29%3b'))</script>"
