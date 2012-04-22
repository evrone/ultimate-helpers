###
 *  front-end js helpers
 *    0.3.3.alpha / 2010-2011
 *    Karpunin Dmitry / Evrone.com
 *    koderfunk_at_gmail_dot_com
###

@DEBUG_MODE ?= false
@TEST_MODE ?= false
@WARNINGS ?= true

@cout = =>
  args = @args arguments
  method = if args[0] in ['log', 'info', 'warn', 'error', 'assert', 'clear'] then args.shift() else 'log'
  if @DEBUG_MODE and console?
    method = console[method]
    if method.apply?
      method.apply console, args
    else
      method args
  return args[0]

@_cout = =>
  console.log arguments  if console?
  arguments[0]

@deprecate = (subject, instead = null) =>
  @cout 'warn', "\"#{subject}\" DEPRECATED!" + if instead then " Use instead: \"#{instead}\"" else ''
  return

@warning = (subject, instead = null) =>
  if @WARNINGS
    @cout 'warn', "\"#{subject}\" WARNING!" + if instead then " Use instead: \"#{instead}\"" else ''
  return

@args = (a) ->
  r = []
  Array::push.apply r, a  if a.length > 0
  r

@blockGiven = (args) =>
  l = args.length
  if l
    l = args[l - 1]
    if _.isFunction l then l else false
  else
    false

@isset = (obj) =>
  @deprecate 'isset(obj)', 'obj isnt undefined" OR "obj?'
  obj isnt undefined

@isString = (v) =>
  @deprecate 'isString(v)', '_.isString v'
  _.isString v

@isNumber = (v) =>
  @deprecate 'isNumber(v)', '_.isNumber v'
  not isNaN parseInt v

@isJQ = (obj) ->
  _.isObject(obj) and _.isString obj.jquery

@uniq = (arrOrString) ->
  @deprecate 'uniq(a)', '_.uniq a'
  isStr = _.isString arrOrString
  return arrOrString  unless isStr or _.isArray arrOrString
  r = []
  r.push e  for e in arrOrString  when not _.include r, e
  if isStr then r.join '' else r

@logicalXOR = (a, b) ->
  ( a and not b ) or ( not a and b )

@bound = (number, min, max) ->
  Math.max min, Math.min number, max

@roundWithPrecision = (number, precision = 2) ->
  precision = Math.pow 10, precision
  Math.round(number * precision) / precision

@regexpSpace = new RegExp '^\\s*$'
@regexpTrim = new RegExp '^\\s*(.*?)\\s*$'

@strTrim = (s) =>
  @deprecate "strTrim(s)", "$.trim(s)"
  s.match(@regexpTrim)[1]

# !!!!!!!!!!! tags !!!!!!!!!!!!

@number_to_currency = (number, units) ->
  precision = 2
  s = parseFloat(number).toFixed precision
  b = s.length - 1 - precision
  r = s.substring b
  while b > 0
    a = b - 3
    r = ' ' + s.substring(a, b) + r
    b = a
  "#{r.substring(1)} #{units}"



@getParams = ->
  q = location.search.substring(1).split '&'
  r = {}
  for e in q
    t = e.split '='
    r[t[0]] = t[1]
  r

@respondFormat = (url, format = null) ->
  aq = url.split '?'
  ah = aq[0].split '#'
  ad = ah[0].split '.'
  currentFormat = if ad.length > 1 and not /\//.test(ad[ad.length - 1]) then ad.pop() else ''
  return currentFormat  unless format?
  return url  if format is currentFormat
  ad.push format  if format
  ah[0] = ad.join '.'
  aq[0] = ah.join '#'
  aq.join '?'



@rails_data = {}

@rails_scope = (controller_name, action_name, scopedCloasure = null, scopedCloasureArguments...) =>
  return false if _.isString(controller_name) and controller_name isnt @rails_data['controller_name']
  return false if _.isString(action_name)     and action_name     isnt @rails_data['action_name']
  if _.isFunction scopedCloasure
    arguments[2] scopedCloasureArguments...
  true



$ =>
  @rails_data = $('body').data()
