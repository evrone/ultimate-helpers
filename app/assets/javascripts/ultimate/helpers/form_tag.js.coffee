#= require ./base
#= require ./tag
#= require ./url

@Ultimate.Helpers.FormTag =

  embed_authenticity_token_in_remote_forms: false

  form_tag: (url_for_options = {}, options = {}, block = null) ->
    html_options = @_html_options_for_form(url_for_options, options)
    if block = _.outcasts.blockGiven(arguments)
      @_form_tag_in_block(html_options, block)
    else
      @_form_tag_html(html_options)

  select_tag: (name, option_tags = '', options = {}) ->
    html_name = if options.multiple is true and not _.string.endsWith(name, '[]') then "#{name}[]" else name
    if _.outcasts.delete(options, 'include_blank')
      option_tags = Ultimate.Helpers.Tag.content_tag('option', '', value: '') + option_tags
    if prompt = _.outcasts.delete(options, 'prompt')
      option_tags = Ultimate.Helpers.Tag.content_tag('option', prompt, value: '') + option_tags
    Ultimate.Helpers.Tag.content_tag 'select', option_tags, _.extend({name: html_name, id: @_sanitize_to_id(name)}, options), false

  text_field_tag: (name, value = null, options = {}) ->
    Ultimate.Helpers.Tag.tag 'input', _.extend({type: 'text', name: name, id: @_sanitize_to_id(name), value: value}, options)

  label_tag: (name = null, content_or_options = null, options = null, block = null) ->
    if (block = _.outcasts.blockGiven(arguments)) and $.isPlainObject(content_or_options)
      options = content_or_options
    else
      options ||= {}
    if _.isString(name) and not _.string.isBlank(name)
      unless _.has(options, 'for')
        options = _.clone(options)
        options['for'] = @_sanitize_to_id(name)
      content_or_options ||= _.string.humanize(name)
    content_or_options = options  if block
    Ultimate.Helpers.Tag.content_tag 'label', content_or_options, options, block

  hidden_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'hidden')

  file_field_tag: (name, options = {}) ->
    @text_field_tag name, null, _.extend(options, type: 'file')

  password_field_tag: (name = 'password', value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'password')

  text_area_tag: (name, content = null, options = {}) ->
    if size = _.outcasts.delete(options, 'size')
      [options['cols'], options['rows']] = size.split("x")  if _.isFunction(size.split)
    escape = _.outcasts.delete(options, 'escape') ? true
    Ultimate.Helpers.Tag.content_tag 'textarea', content, _.extend({name: name, id: @_sanitize_to_id(name)}, options), escape

  check_box_tag: (name, value = '1', checked = false, options = {}) ->
    html_options = _.extend({type: 'checkbox', name: name, id: @_sanitize_to_id(name), value: value}, options)
    html_options['checked'] = 'checked'  if checked
    Ultimate.Helpers.Tag.tag 'input', html_options

  radio_button_tag: (name, value, checked = false, options = {}) ->
    html_options = _.extend({type: 'radio', name: name, id: "#{@_sanitize_to_id(name)}_#{@_sanitize_to_id(value)}", value: value}, options)
    html_options['checked'] = 'checked'  if checked
    Ultimate.Helpers.Tag.tag 'input', html_options

  submit_tag: (value = 'Save changes', options = {}) ->
    Ultimate.Helpers.Tag.tag 'input', _.extend({type: 'submit', name: 'commit', value: value}, options)

  button_tag: (content_or_options = null, options = null, block = null) ->
    options = content_or_options  if (block = _.outcasts.blockGiven(arguments)) and $.isPlainObject(content_or_options)
    options ||= {}
    options = _.extend({name: 'button', type: 'submit'}, options)
    content_or_options = options  if block
    Ultimate.Helpers.Tag.content_tag 'button', content_or_options or 'Button', options, not block, block

  image_submit_tag: (source, options = {}) ->
    Ultimate.Helpers.Tag.tag 'input', _.extend({type: 'image', src: path_to_image(source)}, options)

  field_set_tag: (legend = null, options = null, block) ->
    output = Ultimate.Helpers.Tag.tag('fieldset', options, true)
    output += Ultimate.Helpers.Tag.content_tag('legend', legend)  if _.isString(legend) and not _.string.isBlank(legend)
    output += block()  if block = _.outcasts.blockGiven(arguments)
    output += '</fieldset>'
    output

  color_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'color')

  search_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'search')

  telephone_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'tel')
  
  phone_field_tag: ->
    @telephone_field_tag arguments...

  date_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'date')

  time_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'time')

  datetime_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'datetime')

  datetime_local_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'datetime-local')

  month_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'month')

  week_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'week')

  url_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'url')

  email_field_tag: (name, value = null, options = {}) ->
    @text_field_tag name, value, _.extend(options, type: 'email')

  number_field_tag: (name, value = null, options = {}) ->
    options['type'] ||= 'number'
    if range = _.outcasts.delete(options, 'in') or _.outcasts.delete(options, 'within')
      _.extend options, min: range.min, max: range.max
    @text_field_tag name, value, options

  range_field_tag: (name, value = null, options = {}) ->
    @number_field_tag name, value, _.extend(options, type: 'range')

  utf8_enforcer_tag: ->
    Ultimate.Helpers.Tag.tag 'input', type: 'hidden', name: 'utf8', value: '&#x2713;', false, false

  _html_options_for_form: (url_for_options, options) ->
    html_options = options
    html_options['enctype'] = 'multipart/form-data'  if _.outcasts.delete(html_options, 'multipart')
    # The following URL is unescaped, this is just a hash of options, and it is the
    # responsibility of the caller to escape all the values.
    html_options['action'] = Ultimate.Helpers.Url.url_for(url_for_options)
    html_options['accept-charset'] = 'UTF-8'
    html_options['data-remote'] = true  if _.outcasts.delete(html_options, 'remote')
    if html_options['data-remote'] and
        not @embed_authenticity_token_in_remote_forms and
        _.string.isBlank(html_options['authenticity_token'])
      # The authenticity token is taken from the meta tag in this case
      html_options['authenticity_token'] = false
    else if html_options['authenticity_token'] is true
      # Include the default authenticity_token, which is only generated when its set to nil,
      # but we needed the true value to override the default of no authenticity_token on data-remote.
      html_options['authenticity_token'] = null
    html_options

  _extra_tags_for_form: (html_options) ->
    authenticity_token = _.outcasts.delete(html_options, 'authenticity_token')
    method = _.outcasts.delete(html_options, 'method')
    method_tag =
      if /^get$/i.test(method) # must be case-insensitive, but can't use downcase as might be nil
        html_options['method'] = 'get'
        ''
      else if _.string.isBlank(method) or /^post$/i.test(method)
        html_options['method'] = 'post'
        Ultimate.Helpers.Url._token_tag(authenticity_token)
      else
        html_options['method'] = 'post'
        Ultimate.Helpers.Url._method_tag(method) + Ultimate.Helpers.Url._token_tag(authenticity_token)
    tags = @utf8_enforcer_tag() + method_tag
    Ultimate.Helpers.Tag.content_tag('div', tags, style: 'margin:0;padding:0;display:inline', false)

  _form_tag_html: (html_options) ->
    extra_tags = @_extra_tags_for_form(html_options)
    Ultimate.Helpers.Tag.tag('form', html_options, true) + extra_tags

  _form_tag_in_block: (html_options, block) ->
    "#{@_form_tag_html(html_options)}#{block()}</form>"

  _sanitize_to_id: (name) ->
    if name? then name.toString().replace(/\]/g, '').replace(/[^-a-zA-Z0-9:.]/g, '_') else ''
