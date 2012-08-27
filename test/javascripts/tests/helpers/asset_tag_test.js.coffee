#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/helpers/asset_tag

module "Ultimate.Helpers.AssetTag"

_.extend @, Ultimate.Helpers.AssetTag

test "favicon_link_tag", ->
  equal favicon_link_tag(), '<link href="/images/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />'
  equal favicon_link_tag('favicon.ico'), '<link href="/images/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />'
  equal favicon_link_tag('favicon.ico', rel: 'foo'), '<link href="/images/favicon.ico" rel="foo" type="image/vnd.microsoft.icon" />'
  equal favicon_link_tag('favicon.ico', rel: 'foo', type: 'bar'), '<link href="/images/favicon.ico" rel="foo" type="bar" />'
  equal favicon_link_tag('mb-icon.png', rel: 'apple-touch-icon', type: 'image/png'), '<link href="/images/mb-icon.png" rel="apple-touch-icon" type="image/png" />'

test "image_path", ->
  equal image_path(""), ''
  equal image_path("xml"), '/images/xml'
  equal image_path("xml.png"), '/images/xml.png'
  equal image_path("dir/xml.png"), '/images/dir/xml.png'
  equal image_path("/dir/xml.png"), '/dir/xml.png'

test "path_to_image", ->
  equal path_to_image(""), ''
  equal path_to_image("xml"), '/images/xml'
  equal path_to_image("xml.png"), '/images/xml.png'
  equal path_to_image("dir/xml.png"), '/images/dir/xml.png'
  equal path_to_image("/dir/xml.png"), '/dir/xml.png'

test "image_alt", ->
  for prefix in ['', '/', '/foo/bar/', 'foo/bar/']
    equal image_alt("#{prefix}rails.png"), 'Rails'
    equal image_alt("#{prefix}rails-9c0a079bdd7701d7e729bd956823d153.png"), 'Rails'
    equal image_alt("#{prefix}avatar-0000.png"), 'Avatar-0000'

test "image_tag", ->
  equal image_tag("xml.png"), '<img alt="Xml" src="/images/xml.png" />'
  equal image_tag("rss.gif", alt: "rss syndication"), '<img alt="rss syndication" src="/images/rss.gif" />'
  equal image_tag("gold.png", size: "45x70"), '<img alt="Gold" height="70" src="/images/gold.png" width="45" />'
  equal image_tag("gold.png", size: "45x70"), '<img alt="Gold" height="70" src="/images/gold.png" width="45" />'
  equal image_tag("error.png", size: "45"), '<img alt="Error" src="/images/error.png" />'
  equal image_tag("error.png", size: "45 x 70"), '<img alt="Error" src="/images/error.png" />'
  equal image_tag("error.png", size: "x"), '<img alt="Error" src="/images/error.png" />'
  equal image_tag("google.com.png"), '<img alt="Google.com" src="/images/google.com.png" />'
  equal image_tag("slash..png"), '<img alt="Slash." src="/images/slash..png" />'
  equal image_tag(".pdf.png"), '<img alt=".pdf" src="/images/.pdf.png" />'
  equal image_tag("http://www.rubyonrails.com/images/rails.png"), '<img alt="Rails" src="http://www.rubyonrails.com/images/rails.png" />'
  equal image_tag("//www.rubyonrails.com/images/rails.png"), '<img alt="Rails" src="//www.rubyonrails.com/images/rails.png" />'
  equal image_tag("mouse.png", alt: null), '<img src="/images/mouse.png" />'
  equal image_tag("data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==", alt: null), '<img src="data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==" />'
  equal image_tag(""), '<img src="" />'
