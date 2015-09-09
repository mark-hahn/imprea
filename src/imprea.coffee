
###
  imprea.coffee
  Imperative reactive framework (DSL) for node and the browser.
###

_ = require 'lodash'

globalObservers        = {}
globalObservableValues = {}

nameList = (args...) ->
  func = null
  names = []
  for arg in args
    switch
      when _.isFunction arg then func = arg
      when _.isArray    arg then names = names.concat nameList(arg).names
      when _.isObject   arg then names = names.concat _.keys arg
      else                       names.push arg.toString()
  for name in names
    if name in [ 'outputs', 'description', 'react' 
                 'prototype', '__proto__', 'constructor', 'toString']
      throw new Error 
        message: "Imprea Error in #{@nameSpace}: \"#{name}\" is reserved " +
                 'and may not be used as the name of an output observable.'
  {func, names}    

module.exports = 
class Imperea
  constructor (@nameSpace) ->
    
  outputs: (args...) ->
    nl = nameList args
    for name in nl.names
      @[name] = (value) =>
        if not _.isEqual globalObservableValues[name], value
          globalObservableValues[name] = value
          for observer in globalObservers[name] ? []
            observer.imprea[name] = value
            observer.func.call observer.imprea, name, value

  description: (@description) ->
  
  react: (args...) ->
    if args[0] is '*'
      args = _.keys globalObservableValues
    nl = nameList args
    if not (func = nl.func)
      throw new Error 
        message: "Imprea Error in #{@nameSpace}: " +
                 'a react argument list must contain a function.'
    for name in nl.names
      @[name] ?= null
      globalObservers[name] ?= []
      globalObservers[name].push {imprea: @, func}
    
    