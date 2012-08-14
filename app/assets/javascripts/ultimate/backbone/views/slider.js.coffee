Ultimate.Backbone.Views ||= {}

class Ultimate.Backbone.Views.Slider extends Ultimate.Backbone.View
  el: ".g-slider"

  nodes: ->
    jNavs: ".nav"
    jDisplay:
      selector: ".slide-display"
      jLine:
        selector: ".slide-line"
        jItems: ".item"

  events: ->
    "click   .nav.enabled" : "navClick"

  viewOptions: ["vertical", "cycling", "interval", "durationPerPixel", "prevItems"]

  vertical: false
  cycling: false
  interval: 0
  durationPerPixel: 2

  totalItems: 0
  itemSize: 0
  displayItems: 0
  moveItems: 0
  overItems: 0
  prevItems: 0 # can as setting

  timeoutId: null # for cycling == true
  startSide: "left" # set by @vertical
  sizeAttr: "width" # set by @vertical

  initialize: (options) ->
    @startSide = if @vertical then "top" else "left"
    @sizeAttr = if @vertical then "height" else "width"
    @totalItems = @jItems.length
    if @totalItems
      @jItems.each (index) -> $(@).attr "data-slide-index", index
      jFirstItem = @jItems.first()
      @itemSize = jFirstItem[_.camelize("outer-#{@sizeAttr}")](true)
      needSize = @totalItems * @itemSize
      @jLine[@sizeAttr](needSize)  if @jLine[@sizeAttr]() < needSize
      @displayItems = Math.round(@jDisplay[@sizeAttr]() / @itemSize)
      @moveItems = Math.round(@displayItems / 2)
      @overItems = @totalItems - @displayItems
      if @overItems
        if @prevItems
          @jLine.css @startSide, (- @prevItems * @itemSize)
        else
          @prevItems = Math.round(- @jLine.position()[@startSide] / @itemSize)
        @refreshNavs()
        @setTimeout()  if @interval
      else
        @prevItems = 0
      #@bus().trigger "slider:slide", 0, @prevItems, jItems.eq(@prevItems)

  currentIndex: ->
    @jLine.find(".item:eq(#{@prevItems})").data("slideIndex")

  trySlide: (move = 1, moveItems = move * @moveItems) ->
    if @totalItems and @overItems
      newPrevItems = @prevItems + moveItems
      needFlip = false
      flipItems = 0
      animatedOverItems = 0
      if newPrevItems < 0
        if @cycling
          needFlip = true
          flipItems = newPrevItems
          animatedOverItems = Math.ceil(- @jLine.position()[@startSide] / @itemSize)
        newPrevItems = 0
      else if newPrevItems > @overItems
        if @cycling
          needFlip = true
          flipItems = newPrevItems - @overItems
          animatedOverItems = @overItems - Math.floor(- @jLine.position()[@startSide] / @itemSize)
        newPrevItems = @overItems
      if needFlip
        if flipItems and animatedOverItems < @overItems
          @prevItems -= flipItems
          if flipItems < 0
            @jLine.prepend @jLine.find(".item").slice(flipItems)
          else
            @jLine.append @jLine.find(".item").slice(0, flipItems)
          props = {}
          props[@startSide] = "+=#{flipItems * @itemSize}"
          @jLine.css props
          @slideTo newPrevItems
      else
        @slideTo newPrevItems

  trySlideToStart: ->
    if @totalItems and @overItems
      @slideTo 0

  _duration: (deltaItems) ->
    Math.sqrt(Math.abs(deltaItems) * @itemSize * 500) * @durationPerPixel

  # TODO protect bounds, mb trySlideTo() and _slideTo()
  slideTo: (newPrevItems) ->
    deltaItems = newPrevItems - @prevItems
    if deltaItems
      #@bus().trigger "slider:slide", deltaItems, newPrevItems, jLine.find(".item:eq(#{newPrevItems})")
      props = {}
      props[@startSide] = (- newPrevItems * @itemSize)
      @jLine.stop(true).animate props, @_duration(deltaItems)
      @prevItems = newPrevItems
      @refreshNavs()
      @setTimeout()  if @interval
    deltaItems

  refreshNavs: ->
    @jNavs.filter(".prev").toggleClass "enabled", @cycling or @prevItems > 0
    @jNavs.filter(".next").toggleClass "enabled", @cycling or (@overItems - @prevItems) > 0

  setTimeout: ->
    if @timeoutId?
      clearTimeout @timeoutId
      @timeoutId = null
    @timeoutId = setTimeout =>
        @trySlide()
      , @interval

  navClick: (event) ->
    @trySlide if $(event.currentTarget).hasClass("prev") then -1 else 1
    false
