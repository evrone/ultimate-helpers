#= require ./base
#= require ./tag

@Ultimate.Helpers.FormOptions =

  options_for_select: (container, selected = null) ->
    return container  if _.isString(container)
    [selected, disabled] = _.map @_extract_selected_and_disabled(selected), (r) ->
      _.map _.outcasts.arrayWrap(r), (item) -> item.toString()
    container = _.pairs(container)  if $.isPlainObject(container)
    _.map(container, (element) ->
      html_attributes = @_option_html_attributes(element)
      [text, value] = _.map @_option_text_and_value(element), (item) -> if item? then item.toString() else ''
      html_attributes['value'] = value
      html_attributes['selected'] = 'selected'  if @_option_value_selected(value, selected)
      html_attributes['disabled'] = 'disabled'  if disabled and @_option_value_selected(value, disabled)
      Ultimate.Helpers.Tag.content_tag_string 'option', text, html_attributes
    ).join("\n")



  _option_html_attributes: (element) ->
    result = {}
    if _.isArray(element)
      _.extend(result, e)  for e in element  when $.isPlainObject(e)
    result

  _option_text_and_value: (option) ->
    # Options are [text, value] pairs or strings used for both.
    if _.isArray(option)
      option = _.reject(option, (e) -> $.isPlainObject(e))
      [_.first(option), _.last(option)]
    else
      [option, option]

  _option_value_selected: (value, selected) ->
    value in selected

  _extract_selected_and_disabled: (selected) ->
    if _.isFunction(selected)
      [selected, null]
    else
      selected = _.outcasts.arrayWrap(selected)
      options = if $.isPlainObject(_.last(selected)) then selected.pop() else {}
      selected_items = options['selected'] ? selected
      [selected_items, options['disabled']]
