class FuzzyJsonGenerator

  @idCounter: 0

  constructor: ->
    # nop

  nextId: ->
    @constructor.idCounter++

  # overload this method
  generateOne: ->
    id: @nextId()

  generateMany: (count, base = 0) ->
    count = @getRandom(count, base)  if base > 0
    @generateOne()  for i in [0..count]

  getRandom: (arrayOrCount, base = 0) ->
    rand = Math.random()
    if _.isArray arrayOrCount
      arrayOrCount[Math.floor rand * arrayOrCount.length]
    else if _.isNumber arrayOrCount
      base + Math.floor rand * arrayOrCount
    else
      rand



@Generators ||= {}

class Generators.Offers extends FuzzyJsonGenerator

  citiesFrom: ['Москва', 'Воронеж', 'Санкт-Петербург']
  citiesTo: ['Хошимин', 'Брюссель', 'Лондон', 'Нью-Йорк', 'Париж', 'Мадрид', 'Берлин']

  generateOne: ->
    fromDate = new Date
    fromDate.setTime(fromDate.getTime() + 1000 * 60 * 60 * 24 * @getRandom(30))
    toDate = new Date
    toDate.setTime(fromDate.getTime() + 1000 * 60 * 60 * 24 * @getRandom(30))
    id: @nextId()
    city_from : @getRandom(@citiesFrom)
    city_to   : @getRandom(@citiesTo)
    date_from : Globalize.format(fromDate, "yyyy-MM-dd")
    date_to   : Globalize.format(toDate, "yyyy-MM-dd")
    price     : @getRandom(20000, 5000)
    hot       : @getRandom(2) is 1
