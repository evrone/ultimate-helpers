#
# Magic Radios
# TODO refactoring
# TODO checkboxes
#
#  @example
#    = f.radio_button :main_addr_same_as_jur, true, data: {disable: ".main-addr"}
#    = f.radio_button :main_addr_same_as_jur, false, data: {enable: ".main-addr"}
#    = f.text_field :main_addr, :disabled => @profile.main_addr_same_as_jur, :class => "main-addr"
#    javascript:
#      $('.some form').magicRadios();

( ( $ ) ->

  $.fn.magicRadios = (suspend = true, closestDock = 'fieldset, form, body', eventName = 'change.magic-radios') ->
    if @length
      jDocks = if @is 'input:radio' then @closest closestDock else @
      jDocks.off eventName
      if suspend
        jDocks.on eventName, 'input:radio', (event) ->
          jDock = $ event.delegateTarget
          rules = [
            ['enable',   'disabled', false, true]
            ['check',    'checked',  true]
            ['uncheck',  'checked',  false]
            ['disable',  'disabled', true]
            ['writable', 'readonly', false, true]
            ['readonly', 'readonly', true]
          ]
          for rule in rules
            [dataParam, propName, propValue, focusFirst] = rule
            linkedFields = $(@).data dataParam
            if linkedFields
              jFounded = jDock.find linkedFields
              jFields = jFounded.filter ':input'
              jFields = jFounded.find ':input'  unless jFields.length
              if jFields.length
                jFields.prop propName, propValue
                jFields.first().focus()  if focusFirst
          true
    @

)( jQuery )
