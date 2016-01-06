
_ = require 'lodash'

globalObservers        = {}
globalObservableValues = {}

if typeof Object.assign isnt "function"
  Object.assign = (target, args...) ->
    output = Object target
    for source in args when source?
      for own nextKey of source
        output[nextKey] = source[nextKey]  
    output

class Imprea
  constructor: ->
  
  output: (names...) ->
    for name in names then do (name) =>
      globalObservableValues[name] ?= null
      @[name] = (value) =>
        if not _.isEqual globalObservableValues[name], value
          globalObservableValues[name] = 
            (if typeof value is 'object' then Object.assign({}, value) else value)
          for observer in globalObservers[name] ? []
            observer.imprea[name] = value
            observer.func.call observer.reactCallSelf, name, value
  
  react: (names..., func) ->
    reactCallSelf = @
    if names[0] is '*'
      names = _.keys globalObservableValues
      reactCallSelf = globalObservableValues
    for name in names when typeof @[name] isnt 'function'
      @[name] ?= null
      globalObservers[name] ?= []
      globalObservers[name].push {imprea: @, reactCallSelf, func}

module.exports = -> new Imprea
  