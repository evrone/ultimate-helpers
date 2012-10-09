#= require ./base

@Ultimate.Helpers.Tag =

  BOOLEAN_ATTRIBUTES: "disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seemless muted required
                       autofocus novalidate formnovalidate open pubdate itemscope".split(/\s+/)

  PRE_CONTENT_STRINGS:
    textarea: "\n"

  tag: (tag_name, options = {}, open = false, escape = true) ->
    "<#{tag_name}#{@tag_options(options, escape)}#{if open then '>' else ' />'}"

  content_tag: (name, content_or_options_with_block = null, options = null, escape = true, block = null) ->
    if block = _.outcasts.blockGiven(arguments)
      options = content_or_options_with_block
      @content_tag_string(name, block(), options, escape)
    else
      @content_tag_string(name, content_or_options_with_block, options, escape)

  cdata_section: (content) ->
    splitted = content.replace(/\]\]>/g, ']]]]><![CDATA[>')
    "<![CDATA[#{splitted}]]>"

  content_tag_string: (name, content = '', options = {}, escape = true) ->
    content = _.string.escapeHTML(content)  if escape
    "<#{name}#{@tag_options(options, escape)}>#{@PRE_CONTENT_STRINGS[name] ? ''}#{content}</#{name}>"

  html_options_to_s: (html_options, escape = false, prefix = "") ->
    deprecate 'html_options_to_s()', "tag_options()"
    @tag_options arguments...

  tag_options: (options, escape = true) ->
    return ""  if _.isEmpty(options)
    attrs = []
    for key, value of options
      if key is "data" and _.isObject(value)
        for k, v of value
          attrs.push @data_tag_option(k, v, escape)
      else if _.include(@BOOLEAN_ATTRIBUTES, key)
        attrs.push @boolean_tag_option(key)  if value
      else if value?
        attrs.push @tag_option(key, value, escape)
    if _.isEmpty(attrs) then "" else " #{attrs.sort().join(' ')}"

  data_tag_option: (key, value, escape) ->
    key = "data-#{_.string.dasherize(key)}"
    value = JSON.stringify(value)  if JSON? and _.isObject(value)
    @tag_option(key, value, escape)

  boolean_tag_option: (key) ->
    "#{key}=\"#{key}\""

  tag_option: (key, value, escape) ->
    value = value.join(" ")  if _.isArray(value)
    value = _.string.escapeHTML(value)  if escape
    "#{key}=\"#{value}\""



#  # TODO more zen features: +, *x, {content}
#  # TODO cache
#  selectorToHtml: (selector) ->
#    if matches = selector.match(/^[\s>]*([\w\.]+)(.*)$/)
#      selector = matches[1]
#      continuation = matches[2]#{(if open then ">" else " />")}
#      classes = selector.split(".")
#      tag_name = classes.shift() or "div"
#      html_options = {}
#      html_options["class"] = classes.join(" ")  if classes.length
#      if continuation
#        @content_tag(tag_name, @selectorToHtml(continuation), html_options)
#      else
#        @tag(tag_name, html_options)
#    else
#      ""
#
  concat_class: ->
    _.uniq(_.compact(arguments).join(' ').split(/\s+/)).join(' ')
