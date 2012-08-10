# The DOM class convention is to use the singular form of an object or class. Examples:
#
#   dom_class(post)   # => "post"
#   dom_class(Person) # => "person"
#
# If you need to address multiple instances of the same class in the same view, you can prefix the dom_class:
#
#   dom_class(post, :edit)   # => "edit_post"
#   dom_class(Person, :edit) # => "edit_person"
@dom_class = (record_or_class, prefix = "") ->
  singular = _.singular(record_or_class)
  if prefix then "#{prefix}_#{singular}" else singular

# The DOM id convention is to use the singular form of an object or class with the id following an underscore.
# If no id is found, prefix with "new_" instead. Examples:
#
#   dom_id(Post.find(45))       # => "post_45"
#   dom_id(Post.new)            # => "new_post"
#
# If you need to address multiple instances of the same class in the same view, you can prefix the dom_id:
#
#   dom_id(Post.find(45), :edit) # => "edit_post_45"
# TODO sync with rorId and ror_id
@dom_id = (record, prefix = "") =>
  if record_id = @record_key_for_dom_id(record)
    "#{@dom_class(record, prefix)}_#{record_id}"
  else
    @dom_class(record, prefix or "new")

@record_key_for_dom_id = (record) ->
  record = record.to_model()  if _.isFunction(record.to_model)
  key = record.to_key()
  if key then key.join("_") else key
    
# TODO more zen features: +, *x, {content}
# TODO cache
@selectorToHtml = (selector) =>
  if matches = selector.match(/^[\s>]*([\w\.]+)(.*)$/)
    selector = matches[1]
    continuation = matches[2]
    classes = selector.split(".")
    tag_name = classes.shift() or "div"
    html_options = {}
    html_options["class"] = classes.join(" ")  if classes.length
    if continuation
      @content_tag(tag_name, @selectorToHtml(continuation), html_options)
    else
      @tag(tag_name, html_options)
  else
    ""

@concat_class = =>
  @warning "concat_class()", "refactoring with underscore"
  @uniq(@compact(arguments).join(" ").split(/\s+/)).join(" ")

@html_options_to_s = (html_options, prefix = "") =>
  if $.isPlainObject(html_options)
    prefix = "#{prefix}-"  if prefix
    (for key, value of html_options when typeof value isnt "undefined"
      if $.isPlainObject(value) then @html_options_to_s(value, "#{prefix}#{key}") else " #{prefix}#{key}=\"#{value}\""
    ).join("")
  else
    ""

@tag = (tag_name, html_options = {}) =>
  "<#{tag_name}#{@html_options_to_s html_options} />"

@content_tag = (tag_name, content, html_options) =>
  "<#{tag_name}#{@html_options_to_s html_options}>#{content}</#{tag_name}>"

@link_to = (body, url, html_options = {}) =>
  html_options["href"] = url
  @content_tag("a", body, html_options)
