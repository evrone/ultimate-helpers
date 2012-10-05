#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/underscore/underscore.inflection
#= require ultimate/helpers/record_tag

module "Ultimate.Helpers.RecordTag"

_.extend @, Ultimate.Helpers.RecordTag

class RecordTagPost
  body: "What a wonderful world!"
  constructor: (options = {}) ->
    _.extend @, options

record = new RecordTagPost()
singular = 'record_tag_post'

test "dom_class", ->
  equal dom_class(record), singular
  equal dom_class(record.constructor.name), singular
  equal dom_class(record, "custom_prefix"), "custom_prefix_#{singular}"

test "dom_id", ->
  record.id = null
  equal dom_id(record), "new_#{singular}"
  equal dom_id(record, "custom_prefix"), "custom_prefix_#{singular}"
  record.id = 1
  equal dom_id(record), "#{singular}_1"
  equal dom_id(record, "edit"), "edit_#{singular}_1"

test "content_tag_for", ->
  record.id = 45
  equal content_tag_for('li', record),
        "<li class=\"#{singular}\" id=\"#{singular}_45\"></li>"
  equal content_tag_for('ul', record, 'archived'),
        "<ul class=\"archived_#{singular}\" id=\"archived_#{singular}_45\"></ul>"
  equal content_tag_for('tr', record, class: "special", style: "background-color: #f0f0f0"),
        "<tr class=\"#{singular} special\" id=\"#{singular}_45\" style=\"background-color: #f0f0f0\"></tr>"
  equal content_tag_for('tr', record, 'archived', class: "special", style: "background-color: #f0f0f0"),
        "<tr class=\"archived_#{singular} special\" id=\"archived_#{singular}_45\" style=\"background-color: #f0f0f0\"></tr>"
  equal content_tag_for('tr', record, -> "<b>#{record.body}</b>"),
        "<tr class=\"#{singular}\" id=\"#{singular}_45\"><b>What a wonderful world!</b></tr>"
  post_1 = new RecordTagPost(id: 101, body: "Hello!")
  post_2 = new RecordTagPost(id: 102, body: "World!")
  equal content_tag_for('li', [post_1, post_2], (post) -> post.body),
        "<li class=\"#{singular}\" id=\"#{singular}_101\">Hello!</li>\n<li class=\"#{singular}\" id=\"#{singular}_102\">World!</li>"
  options = class: 'important'
  content_tag_for('li', record, options)
  deepEqual options, class: 'important'

test "div_for", ->
  record.id = 36
  equal div_for(record, class: 'special', -> record.body),
        "<div class=\"#{singular} special\" id=\"#{singular}_36\">What a wonderful world!</div>"
  post_1 = new RecordTagPost(id: 101, body: "Hello!")
  post_2 = new RecordTagPost(id: 102, body: "World!")
  equal div_for([post_1, post_2], (post) -> post.body),
        "<div class=\"#{singular}\" id=\"#{singular}_101\">Hello!</div>\n<div class=\"#{singular}\" id=\"#{singular}_102\">World!</div>"
