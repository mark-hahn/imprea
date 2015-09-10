// Generated by CoffeeScript 1.9.1

/*
  imprea.coffee
  Imperative reactive framework (DSL) for node and the browser.
 */

(function() {
  var Imprea, _, globalObservableValues, globalObservers,
    slice = [].slice;

  _ = require('lodash');

  globalObservers = {};

  globalObservableValues = {};

  Imprea = (function() {
    function Imprea(nameSpace) {
      this.nameSpace = nameSpace;
    }

    Imprea.prototype.imprea_nameList = function() {
      var arg, args, func, i, j, k, len, len1, name, names, nl;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      func = null;
      names = [];
      for (i = j = 0, len = args.length; j < len; i = ++j) {
        arg = args[i];
        switch (false) {
          case !_.isFunction(arg):
            func = arg;
            break;
          case !_.isArray(arg):
            nl = this.imprea_nameList.apply(this, arg);
            names = names.concat(nl.names);
            if (func == null) {
              func = nl.func;
            }
            break;
          case !_.isObject(arg):
            names = names.concat(_.keys(arg));
            break;
          default:
            names.push(arg.toString());
        }
      }
      for (k = 0, len1 = names.length; k < len1; k++) {
        name = names[k];
        if (name === 'output' || name === 'description' || name === 'react' || name === 'imprea_nameList' || name === 'prototype' || name === '__proto__' || name === 'constructor' || name === 'toString') {
          throw new Error(("Imprea Error in \"" + this.nameSpace + "\": \"" + name + "\" is reserved ") + 'and may not be used as the name of an output observable.');
        }
      }
      return {
        func: func,
        names: names
      };
    };

    Imprea.prototype.output = function() {
      var args, j, len, name, nl, ref, results;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      nl = this.imprea_nameList(args);
      ref = nl.names;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        name = ref[j];
        results.push((function(_this) {
          return function(name) {
            if (globalObservableValues[name] == null) {
              globalObservableValues[name] = null;
            }
            return _this[name] = function(value) {
              var k, len1, observer, ref1, ref2, results1;
              if (/^ctrl/.test(name)) {
                console.log(name, '=', value);
              }
              if (!_.isEqual(globalObservableValues[name], value)) {
                globalObservableValues[name] = value;
                ref2 = (ref1 = globalObservers[name]) != null ? ref1 : [];
                results1 = [];
                for (k = 0, len1 = ref2.length; k < len1; k++) {
                  observer = ref2[k];
                  observer.imprea[name] = value;
                  results1.push(observer.func.call(observer.imprea, name, value));
                }
                return results1;
              }
            };
          };
        })(this)(name));
      }
      return results;
    };

    Imprea.prototype.description = function(description) {
      this.description = description;
    };

    Imprea.prototype.react = function() {
      var allNames, args, func, j, len, name, nl, ref, results;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (args[0] === '*') {
        allNames = _.keys(globalObservableValues);
        args = allNames.concat(args[1]);
      }
      nl = this.imprea_nameList(args);
      if (!(func = nl.func)) {
        throw new Error(("Imprea Error in \"" + this.nameSpace + "\": ") + 'a react argument list must contain a function.');
      }
      ref = nl.names;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        name = ref[j];
        if (this[name] == null) {
          this[name] = null;
        }
        if (globalObservers[name] == null) {
          globalObservers[name] = [];
        }
        results.push(globalObservers[name].push({
          imprea: this,
          func: func
        }));
      }
      return results;
    };

    return Imprea;

  })();

  module.exports = function(namespace) {
    return new Imprea(namespace);
  };

}).call(this);
