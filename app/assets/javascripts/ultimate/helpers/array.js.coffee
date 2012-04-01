@compact = (arr) ->
  @deprecate 'compact(arr)', '_.compact arr'
  r = []
  for e in arr
    r.push e if e?
  r

@reverse = (arr) =>
  @deprecate 'reverse(arr)', 'arr.reverse()'
  _isString = _.isString arr
  return arr unless _isString or $.isArray arr
  if _isString then @warning 'reverse(someString)', 'STOP USE IT!' else arr.reverse()

###
 Split array into slices of <number> elements.
 Map result by iterator if last given.

   >>> eachSlice [1..10], 3, (a) -> cout a
   [1, 2, 3]
   [4, 5, 6]
   [7, 8, 9]
   [10]
###
@eachSlice = (array, number, iterator = null) =>
  size = array.length
  index = 0
  slices = []
  while index < size
    nextIndex = index + number
    slices.push array.slice(index, nextIndex)
    index = nextIndex
  if _.isFunction iterator then _.map slices, iterator else slices

###
 Splits or iterates over the array in groups of size +number+,
 padding any remaining slots with +fill_with+ unless it is +false+.

   >>> inGroupsOf [1..7], 3, (group) -> cout group
   [1, 2, 3]
   [4, 5, 6]
   [7, null, null]

   >>> inGroupsOf [1..3], 2, '&nbsp;', (group) -> cout group
   [1, 2]
   [3, "&nbsp;"]

   >>> inGroupsOf [1..3], 2, false, (group) -> cout group
   [1, 2]
   [3]
###
@inGroupsOf = (array, number, fillWith = null) =>
  return array  if number < 1
  iterator = @blockGiven arguments
  unless fillWith is false
    # size % number gives how many extra we have;
    # subtracting from number gives how many to add;
    # modulo number ensures we don't add group of just fill.
    padding = (number - array.length % number) % number
    if padding
      fillWith = null  if _.isFunction fillWith
      array = array.slice()
      array.push fillWith  while padding-- > 0
  @eachSlice array, number, iterator
