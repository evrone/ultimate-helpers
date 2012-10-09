#= require ./base
#= require ./tag

JS_ESCAPE_MAP =
  '\\'    : '\\\\'
  '</'    : '<\\/'
  "\r\n"  : '\\n'
  "\n"    : '\\n'
  "\r"    : '\\n'
  '"'     : '\\"'
  "'"     : "\\'"

@Ultimate.Helpers.Javascript =

  escape_javascript: (javascript) ->
    return ''  unless _.isString(javascript)
    javascript.replace( /(\\|<\/|\r\n|[\n\r"'])/g, (match) -> JS_ESCAPE_MAP[match] )

  j: -> @escape_javascript arguments...

  javascript_tag: (content_or_options_with_block = null, html_options = {}, block = null) ->
    content =
      if block = _.outcasts.blockGiven(arguments)
        html_options = content_or_options_with_block if  $.isPlainObject(content_or_options_with_block)
        block()
      else
        content_or_options_with_block
    Ultimate.Helpers.Tag.content_tag 'script', @javascript_cdata_section(content), html_options, false

  javascript_cdata_section: (content) ->
    "\n//#{Ultimate.Helpers.Tag.cdata_section("\n#{content}\n//")}\n"
