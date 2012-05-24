// pluralize(12, 'коров', 'корова', 'коровы')
function pluralize(num, zero, one, two) {
  num = Math.abs(num);
  if ( (num >= 5) && (num <= 20) ) return zero;
  num = num % 10;
  if ( num == 1 ) return one;
  if ( (num >= 2) && (num <= 4) ) return two;
  return zero;
}

function limitField(field_selector, limit, info_selector) {
  var jInfo = $(info_selector);
  var jField = $(field_selector);
  var text_buffer = jField.val();
  jField.bind('keyup change', function () {
    var text = jField.val();
    var text_length = text.length;
    if (text_length > limit) {
      jInfo.html('<span style="color: red;">Не может быть длиннее ' + limit + ' символов!</span>');
      jField.val(text_buffer);
      return false;
    } else {
      text_buffer = text;
      var rest = limit - text_length;
      jInfo.html('Остал' + pluralize(rest, 'ось', 'ся', 'ось') + ' ' + rest + ' символ' + pluralize(rest, 'ов', '', 'а') + '.');
      return true;
    }
  } ).change();
}
