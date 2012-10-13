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

  concat_class: ->
    flatten_classes = _.filter( _.flatten(arguments), (e) -> _.isString(e) ).join(' ')
    _.uniq( _.string.words(flatten_classes) ).join(' ')



  selfClosedTags: _.string.words('area base br col command embed hr img input keygen link meta param source track wbr')

  # Generate html from zen-selector. Ninja tool.
  # TODO more zen features: +, *x, {content}
  # TODO cache
  selectorToHtml: (selector) ->
    if matches = selector.match(/^[\s>]*([\w\.#]+)(.*)$/)
      selector = matches[1]
      continuation = matches[2]   # in v1 {(if continuation then ">" + content else " />")}
      tag_name = selector.match(/^\w+/)?[0] or 'div'
      id = selector.match(/#(\w+)/)?[1]
      classes = _.map( selector.match(/\.\w+/g), (c) -> _.string.ltrim(c, '.') )
      html_options = {}
      html_options['id'] = id  if id
      html_options['class'] = classes.join(' ')  if classes.length
      if _.contains(@selfClosedTags, tag_name)
        @tag(tag_name, html_options)
      else
        continuation = @selectorToHtml(continuation)  if continuation
        @content_tag(tag_name, continuation, html_options)
#    else if matches = selector.match(/^\s*\+\s*(.*)$/)       # /^\s*\+\s*([\w\.#]+)(.*)$/)
#      continuation = matches[1]
#      if continuation then @selectorToHtml(continuation) else continuation
    else
      ''
