#= require ./base
#= require ./tag

@Ultimate.Helpers.Decor =

  g_decor_body: (tag, inner) ->
    content_tag(tag, '',    class: 'left') +
    content_tag(tag, '',    class: 'right') +
    content_tag(tag, inner, class: 'fill')

  g_star_decor_body: (tag, inner) ->
    content_tag(tag, inner, class: 'wrapper') +
    content_tag(tag, '',    class: 'corner left top') +
    content_tag(tag, '',    class: 'corner right top') +
    content_tag(tag, '',    class: 'corner left bottom') +
    content_tag(tag, '',    class: 'corner right bottom')

  g_wrapper_decor_body: (tag, inner) ->
    content_tag tag, inner, class: 'wrapper'
