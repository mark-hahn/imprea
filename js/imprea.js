// Generated by CoffeeScript 1.10.0
(function() {
  var Imprea, _, globalObservableValues, globalObservers,
    slice = [].slice;

  _ = require('lodash');

  globalObservers = {};

  globalObservableValues = {};

  Imprea = (function() {
    function Imprea() {}

    Imprea.prototype.output = function() {
      var i, len, name, names, results;
      names = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      results = [];
      for (i = 0, len = names.length; i < len; i++) {
        name = names[i];
        results.push((function(_this) {
          return function(name) {
            if (globalObservableValues[name] == null) {
              globalObservableValues[name] = null;
            }
            return _this[name] = function(value) {
              var j, len1, observer, ref, ref1, results1;
              if (!_.eq(globalObservableValues[name], value)) {
                globalObservableValues[name] = (typeof value === 'object' ? _.cloneDeep(value) : value);
                ref1 = (ref = globalObservers[name]) != null ? ref : [];
                results1 = [];
                for (j = 0, len1 = ref1.length; j < len1; j++) {
                  observer = ref1[j];
                  observer.imprea[name] = value;
                  results1.push(observer.func.call(observer.reactCallSelf, name, value));
                }
                return results1;
              }
            };
          };
        })(this)(name));
      }
      return results;
    };

    Imprea.prototype.react = function() {
      var func, i, j, len, name, names, reactCallSelf, results;
      names = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), func = arguments[i++];
      reactCallSelf = this;
      if (names[0] === '*') {
        names = _.keys(globalObservableValues);
        reactCallSelf = globalObservableValues;
      }
      results = [];
      for (j = 0, len = names.length; j < len; j++) {
        name = names[j];
        if (!(typeof this[name] !== 'function')) {
          continue;
        }
        if (this[name] == null) {
          this[name] = null;
        }
        if (globalObservers[name] == null) {
          globalObservers[name] = [];
        }
        results.push(globalObservers[name].push({
          imprea: this,
          reactCallSelf: reactCallSelf,
          func: func
        }));
      }
      return results;
    };

    return Imprea;

  })();

  module.exports = function() {
    return new Imprea;
  };

}).call(this);
