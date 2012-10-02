#= require ./base
#= require ./tag

@Ultimate.Helpers.Url =

  url_for: (options = null) ->
    if _.isString(options)
      if options is "back"
        'javascript:history.back();'
      else
        options
    else unless _.isEmpty(options)
      url = _.result(options, 'url') ? ''
      if _.isObject(options)
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
    html_options["href"] ||= url
    if block
      Ultimate.Helpers.Tag.content_tag("a", html_options, null, false, block)
    else
      Ultimate.Helpers.Tag.content_tag("a", name or url, html_options, false)



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
    if _.isString(method) and method.toLowerCase() isnt "get" and not /nofollow/.test(html_options["rel"])
      html_options["rel"] = _.string.lstrip("#{html_options["rel"]} nofollow")
    html_options["data-method"] = method
