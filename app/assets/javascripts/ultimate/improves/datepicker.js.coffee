
@unlazy_datepickers = (jRoot) ->
  jRoot.find('input.datepicker.lazy').removeClass('lazy').length

@bind_datepickers = (jRoot) ->
  jRoot.find('input.datepicker:not(.lazy, .hasDatepicker)').each( ->
    jThis = $ @
    opts =
      'showAnim'       : ''
      'showOn'         : 'both'
      'buttonImage'    : '/images/forms/datepicker__icon.png'  # TODO forwarding assets path
      'buttonImageOnly': true
      'changeMonth'    : true
      'changeYear'     : true
      'onClose'        : (dateText, inst) -> $(inst.input).change().focusout()
    opts[_.camelize(k)] = d  for k, d of jThis.data()
    jThis.datepicker opts
  ).length

$.fn.orig_datepicker = $.fn.datepicker

$.fn.datepicker = ->
  return @  unless @length
  @data('changed', true)  if arguments.length and arguments[0] is 'setDate'
  $.fn.orig_datepicker.apply @, arguments



$ ->

  $('body').on 'keyup keydown', 'input.datepicker.hasDatepicker', ->
    $(@).datepicker 'hide'

  bind_datepickers $('body')
