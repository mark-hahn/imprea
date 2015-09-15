
_ = require 'lodash'

globalObservers        = {}
globalObservableValues = {}

class Imprea
  constructor: ->
  
  output: (names...) ->
    for name in names then do (name) =>
      globalObservableValues[name] ?= null
      @[name] = (value) =>
        if not _.isEqual globalObservableValues[name], value
          globalObservableValues[name] = value
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
  