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

  options_from_collection_for_select: (collection, value_method, text_method, selected = null) ->
    options = @__mapCollection collection, (element) ->
      [@_value_for_collection(element, text_method), @_value_for_collection(element, value_method)]
    [selected, disabled] = @_extract_selected_and_disabled(selected)
    select_deselect =
      selected: @_extract_values_from_collection(collection, value_method, selected)
      disabled: @_extract_values_from_collection(collection, value_method, disabled)
    @options_for_select(options, select_deselect)

  option_groups_from_collection_for_select: (collection, group_method, group_label_method, option_key_method, option_value_method, selected_key = null) ->
    @__mapCollection(collection, (group) ->
      option_tags = @options_from_collection_for_select(_.result(group, group_method), option_key_method, option_value_method, selected_key)
      Ultimate.Helpers.Tag.content_tag_string 'optgroup', option_tags, label: _.result(group, group_label_method), true, false
    ).join('')

  grouped_options_for_select: (grouped_options, selected_key = null, options = {}) ->
    prompt  = options['prompt']
    divider = options['divider']
    body = ""
    if prompt
      body += Ultimate.Helpers.Tag.content_tag_string('option', @_prompt_text(prompt), value: '')
    grouped_options = _.outcasts.sortHash(grouped_options)  if $.isPlainObject(grouped_options)
    _.each grouped_options, (container) ->
      if divider
        label = divider
      else
        [label, container] = container
      body += Ultimate.Helpers.Tag.content_tag_string('optgroup', @options_for_select(container, selected_key), label: label, true, false)
    body



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

  _extract_values_from_collection: (collection, value_method, selected) ->
    if _.isFunction(selected)
      _.compact @__mapCollection collection, (element) ->
        @__getValueFromElement(element, value_method)  if selected(element)
    else
      selected

  _value_for_collection: (item, value) ->
    if _.isFunction(value)
      value(item)
    else
      @__getValueFromElement(item, value)

  _prompt_text: (prompt) ->
    prompt = if _.isString(prompt) then prompt else I18n?.translate('helpers.select.prompt', default: 'Please select') ? 'Please select'



  __getValueFromElement: (element, property) ->
    if _.isFunction(element.get)
      element.get(property)
    else
      _.result(element, property)

  __mapCollection: (collection, iterator) ->
    if _.isFunction(collection.map)
      collection.map(iterator)
    else
      _.map(collection, iterator)
