#= require ../base

do ($ = jQuery) ->

  # TODO arguments
  $.fn.getViews = (viewClass = null, inheritance = false, domDeep = false) ->
    if not @length
      return []
    else if @length is 1
      views = @data("views") or []
    else
      # TODO check work and perf tests
      views = _.flatten($(o).data("views") or []  for o in @, true)
      #2: @map -> $(@).data("views") or []
      #3: _.flatten ( @map -> $(@).data("views") or [] ), true
    if viewClass?
      _.filter views, if inheritance then (w) -> w instanceof viewClass else (w) -> w.costructor is viewClass
    else
      views

  $.fn.getView = (viewClass, inheritance = false) ->
    if _.isString(viewClass)
      deprecate "getView() with viewClass as string", "viewClass as Backbone.View inheritor"
#      for o in @
#        views = $(o).data("views") or []
#        for view in views
#          return view  if view.constructor.className is viewClass
    else if Ultimate.Backbone.isViewClass(viewClass)
      for o in @
        views = $(o).data("views") or []
        if inheritance
          for view in views
            return view  if view instanceof viewClass
        else
          for view in views
            return view  if view.constructor is viewClass
    false

  $.fn.hasView = (viewClass) ->
    if _.isString(viewClass)
      deprecate "hasView() with viewClass as string", "viewClass as Backbone.View inheritor"
#      for o in @
#        return true  if _.any $(o).data("views") or [], (w) -> w.constructor.className is viewClass
    else if Ultimate.Backbone.isViewClass(viewClass)
      for o in @
        return true  if _.any $(o).data("views") or [], (w) -> w.constructor is viewClass
    false

#  $.fn.bindOneView = (viewClass, options = {}) ->
#    Ultimate.gcViews()
#    bindedView = null
#    if @length
#      selector = "#{viewClass.selector}:not(.prevent-binding)"
#      jContainer = if @is(selector) then @filter(selector) else @find(selector)
#      if (l = jContainer.length)
#        if l is 1
#          bindedView = Ultimate.createView viewClass, jContainer, options
#        else
#          warning "$.fn.bindOneView() found #{l} elements by #{selector}, when need only 1"
#      else
#        warning "$.fn.bindOneView() not found elements by #{selector}"
#    else
#      warning "$.fn.bindOneView() call from empty jQuery()"
#    bindedView
#
#  $.fn.bindView = (viewClass, options = {}) ->
#    Ultimate.gcViews()
#    bindedViews = []
#    if @length
#      ( if @is(viewClass.selector) then @ else @find(viewClass.selector) ).filter(":not(.prevent-binding)").each ->
#        if viewClass.canCreateInstance()
#          jContainer = $ @
#          if view = Ultimate.createView viewClass, jContainer, options
#            bindedViews.push view
#        else
#          false
#    bindedViews
#
#  $.fn.bindViews = (viewClasses = Ultimate.LazyViews, options = {}) ->
#    cout "info", "bindViews begin"
#    bindedViews = []
#    if @length
#      bindedViews = for viewName, viewClass of viewClasses when viewClass.canCreateInstance()
#        viewClass.constructor.className ||= viewName
#        @bindView viewClass, options
#    _.flatten bindedViews, true



#  # TODO filtering by viewClass
#  # TODO enother algorithm with enother projection
#  $.fn.closestViews = (viewClass = null) ->
#    views = []
#    jTry = @
#    jTry = jTry.parent()  while jTry.length and not (views = jTry.getViews()).length
#    views
