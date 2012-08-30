#= require ultimate/underscore/underscore
#= require ultimate/underscore/underscore.string
#= require ultimate/improves/i18n-lite
#= require ultimate/helpers/number

module "Ultimate.Helpers.Number"

_.extend @, Ultimate.Helpers.Number

kilobytes = (number) -> number * 1024
megabytes = (number) -> kilobytes(number) * 1024
gigabytes = (number) -> megabytes(number) * 1024
terabytes = (number) -> gigabytes(number) * 1024

test "number_to_phone", ->
  equal number_to_phone(5551234), "555-1234"
  equal number_to_phone(8005551212), "800-555-1212"
  equal number_to_phone(8005551212, area_code: true), "(800) 555-1212"
  strictEqual number_to_phone("", area_code: true), ""
  equal number_to_phone(8005551212, delimiter: " "), "800 555 1212"
  equal number_to_phone(8005551212, area_code: true, extension: 123), "(800) 555-1212 x 123"
  equal number_to_phone(8005551212, extension: "  "), "800-555-1212"
  strictEqual number_to_phone(5551212, delimiter: '.'), "555.1212"
  equal number_to_phone("8005551212"), "800-555-1212"
  equal number_to_phone(8005551212, country_code: 1), "+1-800-555-1212"
  strictEqual number_to_phone(8005551212, country_code: 1, delimiter: ''), "+18005551212"
  equal number_to_phone(225551212), "22-555-1212"
  equal number_to_phone(225551212, country_code: 45), "+45-22-555-1212"
  equal number_to_phone(911), "911"
  equal number_to_phone(0), "0"
  equal number_to_phone(-1), "1"

test "number_to_currency", ->
  equal number_to_currency(1234567890.50), "$1,234,567,890.50"
  equal number_to_currency(1234567890.506), "$1,234,567,890.51"
  equal number_to_currency(-1234567890.50), "-$1,234,567,890.50"
  equal number_to_currency(-1234567890.50, format: "%u %n"), "-$ 1,234,567,890.50"
  equal number_to_currency(-1234567890.50, negative_format: "(%u%n)"), "($1,234,567,890.50)"
  equal number_to_currency(1234567891.50, precision: 0), "$1,234,567,892"
  equal number_to_currency(1234567890.50, precision: 1), "$1,234,567,890.5"
  equal number_to_currency(1234567890.50, unit: "&pound;", separator: ",", delimiter: ""), "&pound;1234567890,50"
  equal number_to_currency("1234567890.50"), "$1,234,567,890.50"
  equal number_to_currency("1234567890.50", unit: "K&#269;", format: "%n %u"), "1,234,567,890.50 K&#269;"
  equal number_to_currency("-1234567890.50", unit: "K&#269;", format: "%n %u", negative_format: "%n - %u"), "1,234,567,890.50 - K&#269;"
  strictEqual number_to_currency(0.0, unit: "", negative_format: "(%n)"), "0.00"

test "number_to_percentage", ->
  equal number_to_percentage(100), "100.000%"
  equal number_to_percentage(100, precision: 0), "100%"
  equal number_to_percentage(302.0574, precision: 2), "302.06%"
  equal number_to_percentage("100"), "100.000%"
  equal number_to_percentage("1000"), "1000.000%"
  equal number_to_percentage(123.400, precision: 3, strip_insignificant_zeros: true), "123.4%"
  equal number_to_percentage(1000, delimiter: '.', separator: ','), "1.000,000%"
  equal number_to_percentage(1000, format: "%n  %"), "1000.000  %"
  equal number_to_percentage(0), "0.000%"
  equal number_to_percentage(-1), "-1.000%"

test "number_to_delimited", ->
  strictEqual number_to_delimited(12345678), "12,345,678"
  strictEqual number_to_delimited(0), "0"
  strictEqual number_to_delimited(123), "123"
  strictEqual number_to_delimited(123456), "123,456"
  strictEqual number_to_delimited(123456.78), "123,456.78"
  strictEqual number_to_delimited(123456.789), "123,456.789"
  strictEqual number_to_delimited(123456.78901), "123,456.78901"
  strictEqual number_to_delimited(123456789.78901), "123,456,789.78901"
  strictEqual number_to_delimited(0.78901), "0.78901"
  strictEqual number_to_delimited("123456.78"), "123,456.78"
  strictEqual number_to_delimited(12345678, delimiter: ' '), "12 345 678"
  strictEqual number_to_delimited(12345678.05, separator: '-'), "12,345,678-05"
  strictEqual number_to_delimited(12345678.05, separator: ',', delimiter: '.'), "12.345.678,05"
  strictEqual number_to_delimited(12345678.05, delimiter: '.', separator: ','), "12.345.678,05"

test "round_with_precision", ->
  strictEqual round_with_precision(10/3), 3.33
  strictEqual round_with_precision(10/3, 0), 3
  strictEqual round_with_precision(100/3, 5), 33.33333
  strictEqual round_with_precision(100/3, -1), 30
  strictEqual round_with_precision("19.3", -1), 20
#  strictEqual round_with_precision(9.995, 2), 10
  strictEqual round_with_precision(null), 0

test "number_to_rounded", ->
  strictEqual number_to_rounded(-111.2346), "-111.235"
  strictEqual number_to_rounded(111.2346), "111.235"
  strictEqual number_to_rounded(31.825, precision: 2), "31.83"
  strictEqual number_to_rounded(111.2346, precision: 2), "111.23"
  strictEqual number_to_rounded(111, precision: 2), "111.00"
  strictEqual number_to_rounded("111.2346"), "111.235"
  strictEqual number_to_rounded("31.825", precision: 2), "31.83"
  strictEqual number_to_rounded((32.6751 * 100.00), precision: 0), "3268"
  strictEqual number_to_rounded(111.50, precision: 0), "112"
  strictEqual number_to_rounded(1234567891.50, precision: 0), "1234567892"
  strictEqual number_to_rounded(0, precision: 0), "0"
  strictEqual number_to_rounded(0.001, precision: 5), "0.00100"
  strictEqual number_to_rounded(0.00111, precision: 3), "0.001"
#  strictEqual number_to_rounded(9.995, precision: 2), "10.00"
  strictEqual number_to_rounded(10.995, precision: 2), "11.00"
  strictEqual number_to_rounded(-0.001, precision: 2), "0.00"
  strictEqual number_to_rounded(31.825, precision: 2, separator: ','), "31,83"
  strictEqual number_to_rounded(1231.825, precision: 2, separator: ',', delimiter: '.'), "1.231,83"
  strictEqual number_to_rounded(123987, precision: 3, significant: true), "124000"
  strictEqual number_to_rounded(123987876, precision: 2, significant: true ), "120000000"
  strictEqual number_to_rounded("43523", precision: 1, significant: true ), "40000"
  strictEqual number_to_rounded(9775, precision: 4, significant: true ), "9775"
  strictEqual number_to_rounded(5.3923, precision: 2, significant: true ), "5.4"
  strictEqual number_to_rounded(5.3923, precision: 1, significant: true ), "5"
  strictEqual number_to_rounded(1.232, precision: 1, significant: true ), "1"
  strictEqual number_to_rounded(7, precision: 1, significant: true ), "7"
  strictEqual number_to_rounded(1, precision: 1, significant: true ), "1"
  strictEqual number_to_rounded(52.7923, precision: 2, significant: true ), "53"
  strictEqual number_to_rounded(9775, precision: 6, significant: true ), "9775.00"
  strictEqual number_to_rounded(5.3929, precision: 7, significant: true ), "5.392900"
  strictEqual number_to_rounded(0, precision: 2, significant: true ), "0.0"
  strictEqual number_to_rounded(0, precision: 1, significant: true ), "0"
  strictEqual number_to_rounded(0.0001, precision: 1, significant: true ), "0.0001"
  strictEqual number_to_rounded(0.0001, precision: 3, significant: true ), "0.000100"
  strictEqual number_to_rounded(0.0001111, precision: 1, significant: true ), "0.0001"
#  strictEqual number_to_rounded(9.995, precision: 3, significant: true), "10.0"
  strictEqual number_to_rounded(9.994, precision: 3, significant: true), "9.99"
  strictEqual number_to_rounded(10.995, precision: 3, significant: true), "11.0"
  strictEqual number_to_rounded(9775.43, precision: 4, strip_insignificant_zeros: true ), "9775.43"
  strictEqual number_to_rounded(9775.2, precision: 6, significant: true, strip_insignificant_zeros: true ), "9775.2"
  strictEqual number_to_rounded(0, precision: 6, significant: true, strip_insignificant_zeros: true ), "0"
  strictEqual number_to_rounded(123.987, precision: 0, significant: true), "124"
  strictEqual number_to_rounded(12, precision: 0, significant: true ), "12"
  strictEqual number_to_rounded("12.3", precision: 0, significant: true ), "12"

test "number_to_human_size", ->
  equal number_to_human_size(0), "0 Bytes"
#  equal number_to_human_size(1), "1 Byte"
  equal number_to_human_size(3.14159265), "3 Bytes"
  equal number_to_human_size(123.0), "123 Bytes"
  equal number_to_human_size(123), "123 Bytes"
  equal number_to_human_size(1234), "1.21 KB"
  equal number_to_human_size(12345), "12.1 KB"
  equal number_to_human_size(1234567), "1.18 MB"
  equal number_to_human_size(1234567890), "1.15 GB"
  equal number_to_human_size(1234567890123), "1.12 TB"
  equal number_to_human_size(terabytes(1026)), "1030 TB"
  equal number_to_human_size(kilobytes(444)), "444 KB"
  equal number_to_human_size(megabytes(1023)), "1020 MB"
  equal number_to_human_size(terabytes(3)), "3 TB"
  equal number_to_human_size(1234567, precision: 2), "1.2 MB"
  equal number_to_human_size(3.14159265, precision: 4), "3 Bytes"
  equal number_to_human_size('123'), "123 Bytes"
  equal number_to_human_size(kilobytes(1.0123), precision: 2), "1 KB"
  equal number_to_human_size(kilobytes(1.0100), precision: 4), "1.01 KB"
  equal number_to_human_size(kilobytes(10.000), precision: 4), "10 KB"
#  equal number_to_human_size(1.1), "1 Byte"
  equal number_to_human_size(10), "10 Bytes"
  equal number_to_human_size(3.14159265, prefix: 'si'), "3 Bytes"
  equal number_to_human_size(123.0, prefix: 'si'), "123 Bytes"
  equal number_to_human_size(123, prefix: 'si'), "123 Bytes"
  equal number_to_human_size(1234, prefix: 'si'), "1.23 KB"
  equal number_to_human_size(12345, prefix: 'si'), "12.3 KB"
  equal number_to_human_size(1234567, prefix: 'si'), "1.23 MB"
  equal number_to_human_size(1234567890, prefix: 'si'), "1.23 GB"
  equal number_to_human_size(1234567890123, prefix: 'si'), "1.23 TB"
  equal number_to_human_size(1234567, precision: 2), "1.2 MB"
  equal number_to_human_size(3.14159265, precision: 4), "3 Bytes"
  equal number_to_human_size(kilobytes(1.0123), precision: 2), "1 KB"
  equal number_to_human_size(kilobytes(1.0100), precision: 4), "1.01 KB"
  equal number_to_human_size(kilobytes(10.000), precision: 4), "10 KB"
  equal number_to_human_size(1234567890123, precision: 1), "1 TB"
  equal number_to_human_size(524288000, precision: 3), "500 MB"
  equal number_to_human_size(9961472, precision: 0), "10 MB"
  equal number_to_human_size(41010, precision: 1), "40 KB"
  equal number_to_human_size(41100, precision: 2), "40 KB"
  equal number_to_human_size(kilobytes(1.0123), precision: 2, strip_insignificant_zeros: false), "1.0 KB"
  equal number_to_human_size(kilobytes(1.0123), precision: 3, significant: false), "1.012 KB"
  equal number_to_human_size(kilobytes(1.0123), precision: 0, significant: true), "1 KB" #ignores significant it precision is 0
  equal number_to_human_size(kilobytes(1.0123), precision: 3, separator: ','), "1,01 KB"
  equal number_to_human_size(kilobytes(1.0100), precision: 4, separator: ','), "1,01 KB"
  equal number_to_human_size(terabytes(1000.1), precision: 5, delimiter: '.', separator: ','), "1.000,1 TB"

test "number_to_human", ->
  strictEqual number_to_human(-123), "-123"
  strictEqual number_to_human(-0.5), "-0.5"
  strictEqual number_to_human(0), "0"
  strictEqual number_to_human(0.5), "0.5"
  strictEqual number_to_human(123), "123"
  equal number_to_human(1234), "1.23 Thousand"
  equal number_to_human(12345), "12.3 Thousand"
  equal number_to_human(1234567), "1.23 Million"
  equal number_to_human(1234567890), "1.23 Billion"
  equal number_to_human(1234567890123), "1.23 Trillion"
  equal number_to_human(1234567890123456), "1.23 Quadrillion"
  equal number_to_human(1234567890123456789), "1230 Quadrillion"
  equal number_to_human(489939, precision: 2), "490 Thousand"
  equal number_to_human(489939, precision: 4), "489.9 Thousand"
  equal number_to_human(489000, precision: 4), "489 Thousand"
  equal number_to_human(489000, precision: 4, strip_insignificant_zeros: false), "489.0 Thousand"
  equal number_to_human(1234567, precision: 4, significant: false), "1.2346 Million"
  equal number_to_human(1234567, precision: 1, significant: false, separator: ','), "1,2 Million"
  equal number_to_human(1234567, precision: 0, significant: true, separator: ','), "1 Million" #significant forced to false
  #Only integers
  volume = unit: "ml", thousand: "lt", million: "m3"
  equal number_to_human(123456, units: volume), "123 lt"
  equal number_to_human(12, units: volume), "12 ml"
  equal number_to_human(1234567, units: volume), "1.23 m3"
  #Including fractionals
  distance = mili: "mm", centi: "cm", deci: "dm", unit: "m", ten: "dam", hundred: "hm", thousand: "km"
  equal number_to_human(0.00123, units: distance), "1.23 mm"
  equal number_to_human(0.0123, units: distance), "1.23 cm"
  equal number_to_human(0.123, units: distance), "1.23 dm"
  equal number_to_human(1.23, units: distance), "1.23 m"
  equal number_to_human(12.3, units: distance), "1.23 dam"
  equal number_to_human(123, units: distance), "1.23 hm"
  equal number_to_human(1230, units: distance), "1.23 km"
  equal number_to_human(1230, units: distance), "1.23 km"
  equal number_to_human(1230, units: distance), "1.23 km"
  equal number_to_human(12300, units: distance), "12.3 km"
  #The quantifiers don't need to be a continuous sequence
  gangster = hundred: "hundred bucks", million: "thousand quids"
  equal number_to_human(100, units: gangster), "1 hundred bucks"
  equal number_to_human(2500, units: gangster), "25 hundred bucks"
  equal number_to_human(25000000, units: gangster), "25 thousand quids"
  equal number_to_human(12345000000, units: gangster), "12300 thousand quids"
  #Spaces are stripped from the resulting string
  strictEqual number_to_human(4, units: unit: "", ten: 'tens '), "4"
  equal number_to_human(45, units: unit: "", ten: ' tens   '), "4.5  tens"
  equal number_to_human(123456, format: "%n times %u"), "123 times Thousand"
  volume = unit: "ml", thousand: "lt", million: "m3"
  equal number_to_human(123456, units: volume, format: "%n.%u"), "123.lt"

number_to_helpers = _.string.words("phone currency percentage delimited rounded human_size human")

test "number helpers should return empty string when given null", number_to_helpers.length, =>
  for h in number_to_helpers
    strictEqual @["number_to_#{h}"](null), "", "number_to_#{h}"

test "number helpers don't mutate options hash", number_to_helpers.length, =>
  options = raise: true
  for h in number_to_helpers
    @["number_to_#{h}"](1, options)
    deepEqual options, {raise: true}, "number_to_#{h}"

test "number helpers should return non numeric param unchanged", ->
  equal number_to_phone("x", country_code: 1, extension: 123), "+1-x x 123"
  equal number_to_phone("x"), "x"
  equal number_to_currency("x."), "$x."
  equal number_to_currency("x"), "$x"
  equal number_to_percentage("x"), "x%"
  equal number_to_delimited("x"), "x"
  equal number_to_rounded("x."), "x."
  equal number_to_rounded("x"), "x"
  equal number_to_human_size('x'), "x"
  equal number_to_human('x'), "x"
