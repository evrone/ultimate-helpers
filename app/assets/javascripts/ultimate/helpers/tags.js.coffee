@concat_class = =>
  @warning 'concat_class()', 'refactoring with underscore'
  @uniq(@compact(arguments).join(' ').split(/\s+/)).join ' '

@html_options_to_s = (html_options) =>
  if $.isPlainObject html_options
    buffer = []
    buffer.push " #{key}=\"#{html_options[key]}\""  for key of html_options
    buffer.join ''
  else
    ''

@tag = (tag_name, html_options = {}) =>
  "<#{tag_name}#{@html_options_to_s html_options} />"

@content_tag = (tag_name, content, html_options) =>
  "<#{tag_name}#{@html_options_to_s html_options}>#{content}</#{tag_name}>"


@link_to = (body, url, html_options = {}) =>
  html_options['href'] = url
  @content_tag 'a', body, html_options

# careful! g_options() remove options['decor'] from source
@g_options = (options) =>
  decorOptions = options['decor']
  delete options['decor']
  if decorOptions isnt false
    decorOptions ||= {}
    g_class = (decorOptions['class'] or '').split ' '
    g_class.push 'disabled'  if options['disabled']
    g_class.push 'readonly'  if options['readonly']
    g_class.push 'checked'   if options['checked']
    decorOptions['class'] = _.uniq(g_class).join(' ') or null  if g_class.length
  decorOptions

@g_decor_body = (tag, inner) =>
  @content_tag(tag, '',    class: 'left') +
  @content_tag(tag, '',    class: 'right') +
  @content_tag(tag, inner, class: 'fill')

@g_star_decor_body = (tag, inner) =>
  @content_tag(tag, inner, class: 'wrapper') +
  @content_tag(tag, '',    class: 'corner left top') +
  @content_tag(tag, '',    class: 'corner right top') +
  @content_tag(tag, '',    class: 'corner left bottom') +
  @content_tag(tag, '',    class: 'corner right bottom')

@g_wrapper_decor_body = (tag, inner) =>
  @content_tag tag, inner, class: 'wrapper'

@g_button__html_options = (html_options) =>
  _class = ['g-button']
  if html_options['icon']
    _class.push 'with-icon', html_options['icon']
    delete html_options['icon']
  _class.push html_options['role']  if html_options['role']
  _class.push html_options['class'] if html_options['class']
  html_options['class'] = _class.join ' '
  html_options

@g_button = (inner, html_options = {}) =>
  inner = @content_tag('div', '', class: 'icon') + inner  if html_options['icon']
  @content_tag 'div', @g_decor_body('div', inner), @g_button__html_options(html_options)

@g_button_link_to = (body, url, html_options = {}) =>
  body = @content_tag('span', '', class: 'icon') + body  if html_options['icon']
  @link_to @g_decor_body('span', body), url, @g_button__html_options(html_options)

# TODO decoration selecting
@g_text_decoration = @g_star_decor_body

@g_text = (g_class, inner, html_options = {}) =>
  html_options['class'] = @concat_class g_class, html_options['class']
  @content_tag 'div', @g_text_decoration('div', inner), html_options

@g_text_field = (inner, html_options = {}) =>
  @g_text 'g-text-field', inner, html_options

@g_text_area = (inner, html_options = {}) =>
  @g_text 'g-text-area', inner, html_options

@text_field_tag = (text, html_options = {}) =>
  html_options['type'] = 'text'  unless html_options['type']
  html_options['value'] = text
  @tag 'input', html_options

@f_text_field = (method, text, html_options = {}) =>
  html_options['name'] = method  if method
  decor_options = @g_options(html_options)
  @g_text_field @text_field_tag(text, html_options), decor_options

#function options_for_select(container) {
#  switch ( typeof container ) {
#    case 'string': return container;
#    case 'object':
#      if ( ! isset(container.length) ) container = [[]]; // TODO convertation
#      var buffer = [];
#      for ( var i = 0, l = container.length, element; i < l; i++ ) {
#        element = container[i];
#        // selected_attribute = ' selected='selected'' if option_value_selected?(value, selected)
#        // disabled_attribute = ' disabled='disabled'' if disabled && option_value_selected?(value, disabled)
#        buffer.push('<option value='' + element[1] + ''' + html_options_to_s(element[2]) + '>' + element[0] + '</option>');
#      }
#      return buffer.join('\n');
#    default: return '';
#  }
#}

@options_for_select = (container) =>
  if _.isString container
    container
  # TODO проверить, м.б. $.isPlainObject() ?
  else if _.isObject container
    container = [[]]  unless container.length? # TODO convertation
    buffer = []
    for element in container
      # selected_attribute = ' selected='selected'' if option_value_selected?(value, selected)
      # disabled_attribute = ' disabled='disabled'' if disabled && option_value_selected?(value, disabled)
      buffer.push "<option value=\"#{element[1]}\"#{@html_options_to_s element[2]}>#{element[0]}</option>"
    buffer.join '\n'
  else
    ''



#function html_options_to_s(html_options) {
#  if ( isset(html_options) ) {
#    var buffer = [];
#    for ( var key in html_options )
#      buffer.push(' ' + key + '='' + html_options[key] + ''');
#    return buffer.join('');
#  } else return '';
#}
#
#function content_tag(tag_name, content, html_options) {
#  return '<' + tag_name + html_options_to_s(html_options) + '>' + content + '</' + tag_name + '>';
#}
#
#function tag(tag_name, html_options) {
#  return '<' + tag_name + html_options_to_s(html_options) + ' />';
#}
#
#function link_to(body, url, html_options) {
#  if ( ! isset(html_options) ) html_options = {};
#  html_options['href'] = url;
#  return content_tag('a', body, html_options);
#}
#
#function concat_class() {
#  return uniq(compact(arguments).join(' ').split(/\s+/)).join(' ');
#}
#
#function g_options(options) {
#  var decorOptions = options['decor'];
#  delete options['decor'];
#  if ( decorOptions !== false ) {
#    if ( ! decorOptions ) decorOptions = {};
#    var g_class = (decorOptions['class'] || '').split(' ');
#    if ( options['disabled'] ) g_class.push('disabled');
#    if ( options['readonly'] ) g_class.push('readonly');
#    if ( options['checked'] ) g_class.push('checked');
#    if ( g_class.length ) decorOptions['class'] = uniq(g_class).join(' ') || null;
#  }
#  return decorOptions;
#}

#function g_decor_body(tag, inner) {
#  return content_tag(tag, '', {'class': 'left'})
#    + content_tag(tag, '', {'class': 'right'})
#    + content_tag(tag, inner, {'class': 'fill'});
#}
#
#function g_star_decor_body(tag, inner) {
#  return content_tag(tag, inner, {'class': 'wrapper'})
#    + content_tag(tag, '', {'class': 'corner left top'})
#    + content_tag(tag, '', {'class': 'corner right top'})
#    + content_tag(tag, '', {'class': 'corner left bottom'})
#    + content_tag(tag, '', {'class': 'corner right bottom'});
#}
#
#function g_wrapper_decor_body(tag, inner) {
#  return content_tag(tag, inner, {'class': 'wrapper'});
#}
#
#function g_button__html_options(html_options) {
#  var _class = ['g-button'];
#  if ( isset(html_options['icon']) ) { _class.push('with-icon', html_options['icon']); delete html_options['icon']; }
#  if ( isset(html_options['role']) ) _class.push(html_options['role']);
#  if ( isset(html_options['class']) ) _class.push(html_options['class']);
#  html_options['class'] = _class.join(' ');
#  return html_options;
#}
#
#function g_button(inner, html_options) {
#  if ( ! isset(html_options) ) html_options = {};
#  if ( isset(html_options['icon']) ) inner = content_tag('div', '', {'class': 'icon'}) + inner;
#  return content_tag('div', g_decor_body('div', inner), g_button__html_options(html_options));
#}
#
#function g_button_link_to(body, url, html_options) {
#  if ( isset(html_options['icon']) ) body = content_tag('span', '', {'class': 'icon'}) + body;
#  return link_to(g_decor_body('span', body), url, g_button__html_options(html_options));
#}
#
#var g_text_decoration = g_star_decor_body;
#
#function g_text(g_class, inner, html_options) {
#  if ( ! isset(html_options) ) html_options = {};
#  html_options['class'] = concat_class(g_class, html_options['class']);
#  return content_tag('div', g_text_decoration('div', inner), html_options);
#}
#
#function g_text_field(inner, html_options) {
#  return g_text('g-text-field', inner, html_options);
#}
#
#function g_text_area(inner, html_options) {
#  return g_text('g-text-area', inner, html_options);
#}
#
#
#
#function text_field_tag(text, html_options) {
#  if ( ! html_options ) html_options = {};
#  if ( ! html_options['type'] ) html_options['type'] = 'text';
#  html_options['value'] = text;
#  return tag('input', html_options);
#}
#
#
#
#function f_text_field(method, text, html_options) {
#  if ( ! html_options ) html_options = {};
#  if ( method ) html_options['name'] = method;
#  var decor_options = g_options(html_options);
#  return g_text_field(text_field_tag(text, html_options), decor_options);
#}
#
#
#
#function options_for_select(container) {
#  switch ( typeof container ) {
#    case 'string': return container;
#    case 'object':
#      if ( ! isset(container.length) ) container = [[]]; // TODO convertation
#      var buffer = [];
#      for ( var i = 0, l = container.length, element; i < l; i++ ) {
#        element = container[i];
#        // selected_attribute = ' selected='selected'' if option_value_selected?(value, selected)
#        // disabled_attribute = ' disabled='disabled'' if disabled && option_value_selected?(value, disabled)
#        buffer.push('<option value='' + element[1] + ''' + html_options_to_s(element[2]) + '>' + element[0] + '</option>');
#      }
#      return buffer.join('\n');
#    default: return '';
#  }
#}
