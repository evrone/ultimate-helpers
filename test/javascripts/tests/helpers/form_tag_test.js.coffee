#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/underscore/underscore.outcasts
#= require ultimate/helpers/form_tag

module "Ultimate.Helpers.FormTag"

_.extend @, Ultimate.Helpers.FormTag

hidden_fields = (options = {}) ->
  method = options['method']
  txt =  '<div style="margin:0;padding:0;display:inline">'
  txt += '<input name="utf8" type="hidden" value="&#x2713;" />'
  if method and not (method in ['get', 'post'])
    txt += '<input name="_method" type="hidden" value="' + method + '" />'
  txt + '</div>'

form_text = (action = 'http://www.example.com', options = {}) ->
  [remote, enctype, html_class, id, method] = _.map(_.string.words('remote enctype html_class id method'), (key) -> options[key])
  method = 'post'  if method isnt 'get'
  txt =  "<form accept-charset=\"UTF-8\" action=\"#{action}\""
  txt += " enctype=\"multipart/form-data\""  if enctype
  txt += " data-remote=\"true\""  if remote
  txt += " class=\"#{html_class}\""  if html_class
  txt += " id=\"#{id}\""  if id
  txt += " method=\"#{method}\">"
  txt

whole_form = (action = 'javascript:;', options = {}) ->
  out = form_text(action, options) + hidden_fields(options)
  if block = _.outcasts.blockGiven(arguments)
    out += block() + "</form>"
  out

test "form_tag", ->
  equal form_tag(),                     whole_form()
  equal form_tag({}, multipart: true),  whole_form(null, enctype: true)
  equal form_tag({}, method: 'patch'),  whole_form(null, method: 'patch')
  equal form_tag({}, method: 'put'),    whole_form(null, method: 'put')
  equal form_tag({}, method: 'delete'), whole_form(null, method: 'delete')
  equal form_tag({}, remote: true),     whole_form(null, remote: true)
  equal form_tag(-> 'Hello world!'),    whole_form(null, -> 'Hello world!')
  equal form_tag(null, method: 'put', -> 'Hello world!'), whole_form(null, method: 'put', -> 'Hello world!')

test "select_tag", ->
  equal select_tag("people", "<option>david</option>"), 
        '<select id="people" name="people"><option>david</option></select>'
  equal select_tag("colors", "<option>Red</option><option>Blue</option><option>Green</option>", multiple: true),
        '<select id="colors" multiple="multiple" name="colors[]"><option>Red</option><option>Blue</option><option>Green</option></select>'
  equal select_tag("places", "<option>Home</option><option>Work</option><option>Pub</option>", disabled: true),
        '<select disabled="disabled" id="places" name="places"><option>Home</option><option>Work</option><option>Pub</option></select>'
  equal select_tag("places", "<option>Home</option><option>Work</option><option>Pub</option>", include_blank: true),
        '<select id="places" name="places"><option value=""></option><option>Home</option><option>Work</option><option>Pub</option></select>'
  equal select_tag("places", "<option>Home</option><option>Work</option><option>Pub</option>", prompt: "string"),
        '<select id="places" name="places"><option value="">string</option><option>Home</option><option>Work</option><option>Pub</option></select>'
  equal select_tag("places", "<option>Home</option><option>Work</option><option>Pub</option>", prompt: "<script>alert(1337)</script>"),
        '<select id="places" name="places"><option value="">&lt;script&gt;alert(1337)&lt;/script&gt;</option><option>Home</option><option>Work</option><option>Pub</option></select>'
  equal select_tag("places", "<option>Home</option><option>Work</option><option>Pub</option>", prompt: "string", include_blank: true),
        '<select id="places" name="places"><option value="">string</option><option value=""></option><option>Home</option><option>Work</option><option>Pub</option></select>'
  equal select_tag("places", null, include_blank: true),
        '<select id="places" name="places"><option value=""></option></select>'
  equal select_tag("places", null, prompt: "string"),
        '<select id="places" name="places"><option value="">string</option></select>'
  
test "text_field_tag", ->
  equal text_field_tag("title"),
        '<input id="title" name="title" type="text" />'
  equal text_field_tag("title", "Hello!", class: "admin"),
        '<input class="admin" id="title" name="title" type="text" value="Hello!" />'
  equal text_field_tag("title", "Hello!", size: 75),
        '<input id="title" name="title" size="75" type="text" value="Hello!" />'
  equal text_field_tag("title", "Hello!", disabled: true),
        '<input disabled="disabled" id="title" name="title" type="text" value="Hello!" />'
  equal text_field_tag("title", "Hello!", size: 70, maxlength: 80),
        '<input id="title" maxlength="80" name="title" size="70" type="text" value="Hello!" />'

test "label_tag", ->
  equal label_tag("title"), '<label for="title">Title</label>'
  equal label_tag("title", "My Title"), '<label for="title">My Title</label>'
  equal label_tag("title", "My Title", class: "small-label"), '<label class="small-label" for="title">My Title</label>'
  equal label_tag( -> "Blocked" ), '<label>Blocked</label>'
  equal label_tag( -> content_tag('span', "Blocked SPAN", class: 'inner') ), '<label><span class="inner">Blocked SPAN</span></label>'
  equal label_tag("clock", -> "Grandfather"), '<label for="clock">Grandfather</label>'
  equal label_tag("clock", id: "label_clock", -> "Grandfather"), '<label for="clock" id="label_clock">Grandfather</label>'

test "hidden_field_tag", ->
  equal hidden_field_tag('id', 3), '<input id="id" name="id" type="hidden" value="3" />'

test "file_field_tag", ->
  equal file_field_tag('picsplz'), '<input id="picsplz" name="picsplz" type="file" />'
  equal file_field_tag('picsplz', class: 'pix'), '<input class="pix" id="picsplz" name="picsplz" type="file" />'

test "password_field_tag", ->
  equal password_field_tag(), '<input id="password" name="password" type="password" />'

test "text_area_tag", ->
  equal text_area_tag("body", "hello world", size: "20x40"),
        '<textarea cols="20" id="body" name="body" rows="40">\nhello world</textarea>'
  equal text_area_tag("body", "hello world", size: 20),
        '<textarea id="body" name="body">\nhello world</textarea>'
  equal text_area_tag("body", "<b>hello world</b>", size: "20x40"),
        '<textarea cols="20" id="body" name="body" rows="40">\n&lt;b&gt;hello world&lt;/b&gt;</textarea>'
  equal text_area_tag("body", "<b>hello world</b>", size: "20x40", escape: false),
        '<textarea cols="20" id="body" name="body" rows="40">\n<b>hello world</b></textarea>'
  equal text_area_tag("body", null, escape: false),
        '<textarea id="body" name="body">\n</textarea>'

test "check_box_tag", ->
  equal check_box_tag('admin'), '<input id="admin" name="admin" type="checkbox" value="1" />'

test "radio_button_tag", ->
  equal radio_button_tag("people", "david"), 
        '<input id="people_david" name="people" type="radio" value="david" />'
  equal radio_button_tag("num_people", 5), 
        '<input id="num_people_5" name="num_people" type="radio" value="5" />'
  equal radio_button_tag("gender", "m") + radio_button_tag("gender", "f"), 
        '<input id="gender_m" name="gender" type="radio" value="m" /><input id="gender_f" name="gender" type="radio" value="f" />'
  equal radio_button_tag("opinion", "-1") + radio_button_tag("opinion", "1"), 
        '<input id="opinion_-1" name="opinion" type="radio" value="-1" /><input id="opinion_1" name="opinion" type="radio" value="1" />'
  equal radio_button_tag("person[gender]", "m"),
        '<input id="person_gender_m" name="person[gender]" type="radio" value="m" />'
  equal radio_button_tag('ctrlname', 'apache2.2'),
        '<input id="ctrlname_apache2.2" name="ctrlname" type="radio" value="apache2.2" />'

test "submit_tag", ->
  equal submit_tag("Save", onclick: "alert('hello!')", data: { disable_with: "Saving..." }),
        '<input data-disable-with="Saving..." name="commit" onclick="alert(&#39;hello!&#39;)" type="submit" value="Save" />'
  equal submit_tag("Save", data: { disable_with: "Saving..." }),
        '<input data-disable-with="Saving..." name="commit" type="submit" value="Save" />'
  equal submit_tag("Save", data: { confirm: "Are you sure?" }),
        '<input data-confirm="Are you sure?" name="commit" type="submit" value="Save" />'

test "button_tag", ->
  equal button_tag(),
        '<button name="button" type="submit">Button</button>'
  equal button_tag("Save", type: "submit"),
        '<button name="button" type="submit">Save</button>'
  equal button_tag("Button", type: "button"),
        '<button name="button" type="button">Button</button>'
  equal button_tag("Reset", type: "reset"),
        '<button name="button" type="reset">Reset</button>'
  equal button_tag("Reset", type: "reset", disabled: true),
        '<button disabled="disabled" name="button" type="reset">Reset</button>'
  equal button_tag("<b>Reset</b>", type: "reset", disabled: true),
        '<button disabled="disabled" name="button" type="reset">&lt;b&gt;Reset&lt;/b&gt;</button>'
  equal button_tag( -> 'Content' ),
        '<button name="button" type="submit">Content</button>'
  equal button_tag(name: 'temptation', type: 'button', -> content_tag('strong', 'Do not press me')),
        '<button name="temptation" type="button"><strong>Do not press me</strong></button>'
  equal button_tag("Save", type: "submit", data: { confirm: "Are you sure?" }),
        '<button data-confirm="Are you sure?" name="button" type="submit">Save</button>'

test "image_submit_tag", ->
  equal image_submit_tag("save.gif", data: { confirm: "Are you sure?" }),
        '<input data-confirm="Are you sure?" src="/images/save.gif" type="image" />'

test "field_set_tag", ->
  equal field_set_tag('Your details', -> 'Hello world!'),
        '<fieldset><legend>Your details</legend>Hello world!</fieldset>'
  equal field_set_tag(-> 'Hello world!'),
        '<fieldset>Hello world!</fieldset>'
  equal field_set_tag('', -> 'Hello world!'),
        '<fieldset>Hello world!</fieldset>'
  equal field_set_tag('', class: 'format', -> 'Hello world!'),
        '<fieldset class="format">Hello world!</fieldset>'
  equal field_set_tag(),
        '<fieldset></fieldset>'
  equal field_set_tag('You legend!'),
        '<fieldset><legend>You legend!</legend></fieldset>'

test "different fields tags helpers", ->
  equal color_field_tag("car"),
        '<input id="car" name="car" type="color" />'
  equal search_field_tag("query"),
        '<input id="query" name="query" type="search" />'
  equal telephone_field_tag("cell"),
        '<input id="cell" name="cell" type="tel" />'
  equal telephone_field_tag("cell"),
        phone_field_tag("cell")
  equal date_field_tag("cell"),
        '<input id="cell" name="cell" type="date" />'
  equal time_field_tag("cell"),
        '<input id="cell" name="cell" type="time" />'
  equal datetime_field_tag("appointment"),
        '<input id="appointment" name="appointment" type="datetime" />'
  equal datetime_local_field_tag("appointment"),
        '<input id="appointment" name="appointment" type="datetime-local" />'
  equal month_field_tag("birthday"),
        '<input id="birthday" name="birthday" type="month" />'
  equal week_field_tag("birthday"),
        '<input id="birthday" name="birthday" type="week" />'
  equal url_field_tag("homepage"),
        '<input id="homepage" name="homepage" type="url" />'
  equal email_field_tag("address"),
        '<input id="address" name="address" type="email" />'
  equal number_field_tag("quantity", null, in: {min: "1", max: "9"}),
        '<input id="quantity" max="9" min="1" name="quantity" type="number" />'
  equal range_field_tag("volume", null, in: {min: 0, max: 11}, step: 0.1),
        '<input id="volume" max="11" min="0" name="volume" step="0.1" type="range" />'

test "boolean options", ->
  equal check_box_tag("admin", 1, true, disabled: true, readonly: "yes"),
        '<input checked="checked" disabled="disabled" id="admin" name="admin" readonly="readonly" type="checkbox" value="1" />'
  equal check_box_tag("admin", 1, true, disabled: false, readonly: null),
        '<input checked="checked" id="admin" name="admin" type="checkbox" value="1" />'
  equal tag('input', type: "checkbox", checked: false),
        '<input type="checkbox" />'
  equal select_tag("people", "<option>david</option>", multiple: true),
        '<select id="people" multiple="multiple" name="people[]"><option>david</option></select>'
  equal select_tag("people[]", "<option>david</option>", multiple: true),
        '<select id="people_" multiple="multiple" name="people[]"><option>david</option></select>'
  equal select_tag("people", "<option>david</option>", multiple: null),
        '<select id="people" name="people"><option>david</option></select>'

test "options side effects", ->
  options = { option: "random_option" }
  text_area_tag "body", "hello world", options
  deepEqual options, { option: "random_option" }
  submit_tag "submit value", options
  deepEqual options, { option: "random_option" }
  button_tag "button value", options
  deepEqual options, { option: "random_option" }
  image_submit_tag "submit source", options
  deepEqual options, { option: "random_option" }
  label_tag "submit source", "title", options
  deepEqual options, { option: "random_option" }
