
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
      when typeof arg is 'string' then names.push arg
      when _.isArray arg then  names = names.concat nameList arg...
      when _.isObject arg then names = names.concat _.keys arg
      when _.isFunction arg then func = arg
  for name in names
    if name in [ 'outputs', 'description', 'react', 
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
            observer[name] = value
            observer.reactFunc.call @ 

  react: (args...) ->
    nl = nameList args
    if not (@reactFunc = nl.func)
      throw new Error 
        message: "Imprea Error in #{@nameSpace}: " +
                 'a react argument list must contain a function.'
    for name in nl.names
      @[name] = null
      globalObservers[name] ?= []
      globalObservers[name].push @
    