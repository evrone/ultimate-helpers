#= require ./base
#= require ./tag
#= require ./javascript

__char_encode = (char) -> "%#{char.charCodeAt(0).toString(16)}"
__escape_path = (str) -> str.replace(/[^*\-.0-9A-Z_a-z]/g, __char_encode).replace(/\+/g, '%20')
__string_encode = (str) -> _.map(str, (char) -> "&##{char.charCodeAt(0)};" ).join('')

@Ultimate.Helpers.Url =

  url_for: (options = null) ->
    if _.isString(options)
      if options is 'back'
        'javascript:history.back();'
      else
        options
    else unless _.isEmpty(options)
      url = _.result(options, 'url') ? ''
      if $.isPlainObject(options)
        options = _.clone(options)
        delete options['url']
        anchor = _.outcasts.delete(options, 'anchor')
        url += "?#{_.map(options, (value, key) -> "#{key}=#{value}").sort().join('&')}"  unless _.isEmpty(options)
        url += "##{anchor}"  if anchor
      url
    else
      'javascript:;'

  link_to: (name = null, options = null, html_options = null, block = null) ->
    [html_options, options] = [options, name]  if block = _.outcasts.blockGiven(arguments)
    options ||= {}
    url = @url_for(options)
    html_options = @_convert_options_to_data_attributes(options, html_options)
    html_options['href'] ||= url
    if block
      Ultimate.Helpers.Tag.content_tag('a', html_options, null, false, block)
    else
      Ultimate.Helpers.Tag.content_tag('a', name ? url, html_options, false)

  link_to_js: (name = null, html_options = null, block = null) ->
    [options, name] = [name, null]  if block = _.outcasts.blockGiven(arguments)
    @link_to [name, options, html_options, block]...

  # TODO tests
  link_to_unless_current_span: (name, options = null, html_options = null, block = null) ->
    [html_options, options] = [options, name]  if block = _.outcasts.blockGiven(arguments)
    url = @url_for(options)
    if @current_page_(url)
      if block
        Ultimate.Helpers.Tag.content_tag('span', html_options, null, false, block)
      else
        Ultimate.Helpers.Tag.content_tag('span', name ? url, html_options, false)
    else
      if block
        @link_to options, html_options, block
      else
        @link_to name, options, html_options

  # TODO tests
  link_to_unless_current: (name, options = {}, html_options = {}, block = null) ->
    @link_to_unless @current_page_(options), name, options, html_options, block

  # TODO tests
  link_to_unless: (condition, name, options = {}, html_options = {}, block = null) ->
    if condition
      if block = _.outcasts.blockGiven(arguments)
        block(name, options, html_options)
      else
        name
    else
      @link_to name, options, html_options, block

  # TODO tests
  link_to_if: (condition, name, options = {}, html_options = {}, block = null) ->
    @link_to_unless not condition, name, options, html_options, block

  mail_to: (email_address, name = null, html_options = {}) ->
    email_address = _.string.escapeHTML(email_address)
    encode = _.outcasts.delete(html_options, 'encode')
    extras = _.compact _.map _.string.words('cc bcc body subject'), (item) ->
      option = _.outcasts.delete(html_options, item)
      if option?
        "#{item}=#{__escape_path(option)}"
    extras = if _.isEmpty(extras) then '' else '?' + _.string.escapeHTML(extras.join('&'))
    email_address_obfuscated = email_address
    email_address_obfuscated = email_address_obfuscated.replace('@', _.outcasts.delete(html_options, 'replace_at'))   if 'replace_at' of html_options
    email_address_obfuscated = email_address_obfuscated.replace('.', _.outcasts.delete(html_options, 'replace_dot'))  if 'replace_dot' of html_options
    switch encode
      when 'javascript'
        html   = @link_to(name or email_address_obfuscated, "mailto:#{email_address}#{extras}", html_options)
        html   = Ultimate.Helpers.Javascript.escape_javascript(html)
        string = _.map("document.write('#{html}');", __char_encode).join('')
        "<script>eval(decodeURIComponent('#{string}'))</script>"
      when 'hex'
        email_address_encoded = __string_encode(email_address_obfuscated)
        string = __string_encode('mailto:') + _.map(email_address, (char) -> if /\w/.test(char) then __char_encode(char) else char).join('')
        @link_to name or email_address_encoded, "#{string}#{extras}", html_options
      else
        @link_to name or email_address_obfuscated, "mailto:#{email_address}#{extras}", html_options

  # TODO tests
  current_page_: (options) ->
    url_string = @url_for(options)
    request_uri = location.pathname
    if /^\w+:\/\//.test(url_string)
      url_string == "#{location.protocol}#{location.host}#{request_uri}"
    else
      url_string == request_uri



  _convert_options_to_data_attributes: (options, html_options) ->
    if html_options
      html_options['data-remote'] = 'true'  if @_link_to_remote_options(options) or @_link_to_remote_options(html_options)
      method = _.outcasts.delete(html_options, 'method')
      @_add_method_to_attributes(html_options, method)  if method
      html_options
    else
      if @_link_to_remote_options(options) then {'data-remote': 'true'} else {}

  _link_to_remote_options: (options) ->
    _.isObject(options) and _.outcasts.delete(options, 'remote')

  _add_method_to_attributes: (html_options, method) ->
    if _.isString(method) and method.toLowerCase() isnt 'get' and not /nofollow/.test(html_options['rel'])
      html_options['rel'] = _.string.lstrip("#{html_options['rel']} nofollow")
    html_options['data-method'] = method

  _convert_boolean_attributes: (html_options, bool_attrs) ->
    html_options[x] = x  for x in bool_attrs  when _.outcasts.delete(html_options, x)
    html_options

  __protect_against_forgery: false
  __request_forgery_protection_token: 'form_token'
  __form_authenticity_token: 'secret'

  __init_request_forgery_protection: ->
    param = $('head meta[name="csrf-param"]').attr('content')
    token = $('head meta[name="csrf-token"]').attr('content')
    if param and token
      @__protect_against_forgery = true
      @__request_forgery_protection_token = param
      @__form_authenticity_token = token

  _token_tag: (token = @__form_authenticity_token) ->
    if token isnt false and @__protect_against_forgery
      Ultimate.Helpers.Tag.tag 'input', type: 'hidden', name: @__request_forgery_protection_token, value: token
    else
      ''

  _method_tag: (method) ->
    Ultimate.Helpers.Tag.tag 'input', type: 'hidden', name: '_method', value: method
