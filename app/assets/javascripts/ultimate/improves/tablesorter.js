/**
 * Декорирование таблиц с данными + добавление сортировки + доп. обработка таблиц с checkable строками
 *
 * @param {jQuery} jRoot корневые jQuery объекты, в которых будет осуществляться поиск table.tablesorter:not(.decorated)
 * @returns {Number} count >= 0 количество продекорированных таблиц
 */
function decor_tables(jRoot) {
  var jTables = jRoot.find('table.tablesorter:not(.decorated)'),
      jTablesHeaders = jTables.find('thead th:not([colspan])'),
      ts_initData = {};
  if ( arguments.length > 1 ) ts_initData.sortList = arguments[1];
  jTablesHeaders.prepend('<div class="bullet-wrapper"><div class="bullet"></div></div>');
  jTables.find('thead')
  .find('tr:first th:first').addClass('first-child')
  .prepend('<div class="corner-wrapper"><div class="corner left"></div></div>')
  .end().find('tr th:last-child').addClass('last-child').first()
  .prepend('<div class="corner-wrapper"><div class="corner right"></div></div>');
  jTables.find('td:last-child').addClass('last-child');
  jTables.each( function () {
    var jTable = $(this),
        jTFoot = jTable.children('tfoot');
    if ( !jTFoot.length ) jTFoot = $('<tfoot></tfoot>').appendTo(jTable);
    var jRow = $('<tr></tr>').appendTo(jTFoot);
    $('<td colspan="' + jTable.find('thead th').length + '" class="border-bottom"></td>').appendTo(jRow)
    .append('<div class="corner-wrapper"><div class="corner left"></div><div class="corner right"></div></div>');
  } )
  .addClass('decorated')
  .tablesorter(ts_initData);
  jTables.filter('.checkable').tablesorter({headers: { 0: { sorter: false}}})
  .find('thead th.first-child').removeClass('header')
  .find('.bullet-wrapper').remove();
  return jTables.length;
}

$('table.checkable thead th:first input:checkbox').live('change', function () {
  var jThis = $(this),
      jTable = jThis.closest('table.checkable'),
      jCheckboxes = jTable.find('tbody input:checkbox');
  jCheckboxes.prop('checked', jThis.prop('checked'));
  refresh_states(jTable);
} );

$('table.checkable tbody td:first-child input:checkbox').live('change', function () {
  var jTable = $(this).closest('table.checkable');
  jTable.find('input:checkbox#select_all').prop('checked', jTable.find('tbody input:checkbox:not(:checked)').length === 0);
  refresh_states(jTable);
} );



$( function () {

  if ( $.tablesorter ) {
    $.tablesorter.defaults.widgets = ['zebra'];
  }

  //decor_tables($('body'));

} );
