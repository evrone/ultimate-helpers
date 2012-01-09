#// Cacheble bulletproof labels
#// May be use .data('closest_*

#$('form label').live('click', function () {
#  var jLabel = $(this),
#      jElement = jLabel.data('element');
#  if ( !isset(jElement) ) {
#    var jEdge = jLabel.closestEdge();
#    if ( jEdge.length ) {
#      jElement = jEdge.find('#' + jLabel.attr('for'));
#      if ( !jElement.length && (jEdge.is('tr') || jEdge.hasClass('input-line')) ) jElement = jEdge.find(':input');
#      jLabel.data('element', jElement.length ? jElement : false);
#    }
#  }
#  if ( (jElement !== false) && jElement.length ) {
#    if ( jElement.is('input:checkbox') || jElement.is('input:radio') ) {
#      jElement.click();
#    } else {
#      if ( jElement.is('select') )
#        jElement.closest('.g-select').click();
#        else jElement.focus();
#    }
#    return false;
#  }
#
#} );

$ ->
  $('form label').live 'click', ->
    jLabel = $ @
    jElement = jLabel.data 'element'
    _fieldEdgeSelector = 'tr, input-line' # TODO
    unless jElement
      jEdge = jLabel.closestEdge()
      if jEdge.length
        jElement = jEdge.find '#' + jLabel.attr 'for'
        jElement = jEdge.find ':input'  if not jElement.length and jEdge.is _fieldEdgeSelector
      jLabel.data 'element', if jElement.length then jElement else false
    if (jElement isnt false) and jElement.length
      if jElement.is 'input:checkbox, input:radio'
        jElement.click()
      else
        if jElement.is 'select'
          # TODO try: jElement.click()
          jElement.closest('.g-select').click()
        else
          jElement.focus()
      false
