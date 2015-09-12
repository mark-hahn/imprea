
###
  imprea.coffee
  Imperative reactive framework (DSL) for node and the browser.
###

_ = require 'lodash'

globalObservers        = {}
globalObservableValues = {}

class Imprea
  constructor: (@nameSpace) ->
  
  imprea_nameList: (args...) ->
    func = null
    names = []
    for arg, i in args
      switch
        when _.isFunction arg then func = arg
        when _.isArray    arg 
          nl = @imprea_nameList arg...
          names = names.concat nl.names
          func ?= nl.func
        when _.isObject   arg then names = names.concat _.keys arg
        else                       names.push arg.toString()
    for name in names
      if name in [ 'output', 'description', 'react', 'imprea_nameList',
                   'prototype', '__proto__', 'constructor', 'toString']
        throw new Error "Imprea Error in \"#{@nameSpace}\": \"#{name}\" is reserved " +
                        'and may not be used as the name of an output observable.'
    {func, names}    

  output: (args...) ->
    nl = @imprea_nameList args
    for name in nl.names then do (name) =>
      globalObservableValues[name] ?= null
      @[name] = (value) =>
        if not _.isEqual globalObservableValues[name], value
          globalObservableValues[name] = value
          for observer in globalObservers[name] ? []
            observer.imprea[name] = value
            observer.func.call observer.reactCallSelf, name, value

  description: (@description) ->
  
  react: (args...) ->
    reactCallSelf = @
    if args[0] is '*'
      allNames = _.keys globalObservableValues
      args = allNames.concat args[1]
      reactCallSelf = globalObservableValues
    nl = @imprea_nameList args
    if not (func = nl.func)
      throw new Error "Imprea Error in \"#{@nameSpace}\": " +
                      'a react argument list must contain a function.'
    for name in nl.names
      @[name] ?= null
      globalObservers[name] ?= []
      globalObservers[name].push {imprea: @, reactCallSelf, func}
    
module.exports = (namespace) ->
  new Imprea namespace
  