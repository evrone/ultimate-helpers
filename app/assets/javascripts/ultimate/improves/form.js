( function( $ ) {

  // [edgeSelectors: Array = ['.input-line', 'tr', 'fieldset', '.g-box', 'form']]
  $.fn.closestEdge = function() {
    var edgeSelectors = arguments.length && $.isArray(arguments[0])
                          ? arguments[0]
                          : ['.input-line', 'tr', 'fieldset', '.g-box', 'form'],
        l = edgeSelectors.length,
        jEdges = $('');
    this.each( function () {
      var jEdge, i = 0;
      do jEdge = $(this).closest(edgeSelectors[i]); while ( (i++ < l) && !jEdge.length );
      if ( jEdge.length ) jEdges = jEdges.add(jEdge);
    } );
    return jEdges;
  };

  //  @param strongById: Boolean = false
  $.fn.closestLabel = function() {
    var strongById = arguments.length ? arguments[0] : false;
    return (this.is(':input') ? this : this.find(':input')).filter(':not(input[type="hidden"])').map( function () {
      var jInput = $(this),
          jLabel = jInput.data('closest_label');
      if ( jLabel === false ) jLabel = { length: 0 };
      if ( ! jLabel ) {
        jLabel = { length: 0 };
        var jEdge = jInput.closestEdge(),
            inputId = jInput.attr('id');
        if ( isString(inputId) ) {
          var labelSelectorByFor = 'label[for="' + inputId + '"]';
          jLabel = jEdge.find(labelSelectorByFor);
          if ( ! jLabel.length ) {
            jLabel = jInput.closest('form').find(labelSelectorByFor);
            if ( jLabel.length > 1 ) jLabel = { length: 0 };
          }
        }
        if ( ! jLabel.length ) jLabel = jEdge.find('label:first');
        if ( jLabel.length ) {
          if ( jLabel.data('closest_input') ) jLabel = { length: 0 };
          else jLabel.data('closest_input', jInput)
        }
        jInput.data('closest_label', jLabel);
      }
      if ( strongById && jLabel.length && jLabel.attr('for') !== jInput.attr('id') ) jLabel = { length: 0 };
      return jLabel.length ? jLabel.get() : null;
    } );
  };

  // [ additionAttr: String = 'data-nested_addition' ]
  $.fn.setNestedAdditions = function() {
    var additionAttr = arguments.length ? arguments[0] : 'data-nested_addition';
    this.find(':input[' + additionAttr + ']').each( function () {
      var jInput = $(this),
          inputId = jInput.attr('id');
      if ( inputId ) {
        var newId = inputId + '_' + jInput.attr(additionAttr),
            jLabel = jInput.closestLabel();
        jInput.attr('id', newId);
        if ( jLabel.length && jLabel.attr('for') === inputId )
          jLabel.attr('for', newId);
        jInput.removeAttr(additionAttr);
      }
    } );
    return this;
  };



  $.fillTabIndexesCounter = 0;

  $.fn.fillTabIndexes = function (onlyVisible) {
    if ( this.length ) {
      this.find('input:not([readonly])' + (onlyVisible ? ':visible' : '')).each( function () {
        $(this).attr('tabindex', ++$.fillTabIndexesCounter);
      } );
    }
    return this;
  };

} )( jQuery );


// # was there improves/linked-labels

$('form[data-remote="true"]').live('ajax:error', function(event, jqXHR) {
  var jForm = $(this).clearFromErrors();
  try {
    var responseJSON = $.parseJSON(jqXHR.responseText),
        errors = responseJSON['errors'] ? responseJSON['errors'] : responseJSON;
    if ( errors ) {
      var jFields = jForm.find('[name*="["]:input:visible');
      if ( jFields.length ) {
        var jField;
        for ( var fieldName in errors ) {
          jField = jFields.filter('[name$="[' + fieldName + ']"]');
          if ( jField.length ) jField.closestEdge().setErrors(errors[fieldName]);
        }
      }
    }
  } catch (e) {

  }
  return true;
});
