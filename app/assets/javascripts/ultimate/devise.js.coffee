$ ->

  jBody = $ 'body'

  # fixes on sessions/new form, because devise don't return errors on fields
  jBody.on 'ajax:error', 'form.sessions-new', ->
    $(@).find(':input:visible').filter(-> not @value).closestEdge().setErrors()
    false

  # if devise form success, then open root path
  jBody.on 'ajax:success', 'form.user[data-remote="true"]', (event, data, textStatus, jqXHR) ->
    jForm = $ @
    if jForm.hasClass('users-new')
      getWidget('AccountPanel').showConfirmationInfo(jForm, data)
    else if jForm.hasClass('password-recovery')
      getWidget('AccountPanel').showConfirmationInfo(jForm, data)
    else unless jForm.hasClass('status')
      window.location = jqXHR.getResponseHeader('Location') or '/'
