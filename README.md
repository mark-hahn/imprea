# Imprea

Imperative reactive framework (DSL) for node and the browser.

ReactiveX is a very powerful reactive framework with a functional foundation.  Imprea is a framework that provides the capabilities of ReactiveX but using an imperative foundation.  As many features of ReactiveX as possible are provided in impera.

### Philosophy

Functional programming is a powerful well-established programming paradigm.  More and more imperative languages are adding functional features such as first-class functions.

However, many programmers, myself included, do not feel "pure" functional programming is required.  Also it can be quite hard to learn functional programming enough to be effective.  The mindset required is foreign to those who "grew up" with imperative coding.

### Features

Most advantages of the observer pattern, in particular the ReactiveX observable model, can be utilized without using the functional features.  These features can almost always be replaced with imperative ones. (Most of this is copied from the ReactiveX documentation).

- Abstracting away concerns about things like low-level threading, synchronization, thread-safety, concurrent data structures, and non-blocking I/O.

- Composing flows and sequences of asynchronous data.

- Filter, select, transform, combine, and compose Observables. 

### Implementation

Unlike ReactiveX, Imprea is only implemented for Javascript.  It works in either the server (node) or the browser.  It is provided in a module that exports the Imprea class.  Imprea modules each have instance of the Imprea class that contains the functionality of the module.

### Sample Code

The interaction with the Impera controller is through an API that is simple and DSL-like.  It looks best in coffeescript and is written in coffeescript. A small example module that watches two observer inputs and provides observers calculated from those inputs.

```coffee
  imprea = require('imprea') 'sumDiff'   # global namespace for this module
  
  imprea.outputs {obsSum$, obsDiff$}  # public observables output from this module
  imprea.description 'Produce sum and difference observables of two observed inputs'
  
  imprea.react {obsA$, obsB$}, ->     # executes on any change to inputs obsA$ and obsB$
    @obsSum$  @obsA$ + @obsB$         # pushes sum to output observable obsSum$
    @obsDiff$ @obsA$ - @obsB$         # pushes difference to output observable obsDiff$
```

The inputs, outputs, and optional description are defined at the top which means a module can be scanned quickly.  This information can be easily extracted for preparing docs and used by IDEs.

Note how concise and readable the imperative code is.  Every output observable can be changed by the function call made up of `this` and the obervable's name.  Every input is observed by simply referencing `this` with its name.

There are no equal signs but the left is always assigned values from the function argument much like a normal assignment.  Functions allow the observation without using getters/setters or object observation which is slower.

Its really that simple.

### Standard Library Of Operators

ReactiveX functional operator equivalents are provided by standard modules from a provided library. An example usage of two operators follows.

```coffee
{average$, merge$} = require 'imprea-stdlib'
  
@outputObs$ average$ merge$ inputObsA$, inputObsB$
```

The chaining above, which is as succint as the functional equivalent, is made possible by setting the default inputs to a module as the arguments to `imprea.react` and the default outputs to the observables specified in `imprea.outputs`.

Don't confuse the above code with normal functional compostion. Even though the reactive chain is set up with functions, like `merge$ inputObsA$`, this is only run once and the internal reactive observables then act on events just as ReactiveX does. So this is really a DSL.
 
### Ok, I Lied
 
As you can see from the previous example imprea can act like a functional DSL such as ReactiveX. The difference is that it is very easy to use imperative code mixed in with the functional, much like Javascript or many other languages.
 
### Status (Do Not Use)
 
As of this writing (9/5/2015) implementation is just beginning.  Imprea is being developed by replacing Reactive code in an existing application with Imprea code.  So the operators implemented will seem random at first.

### License
 
 Imprea is copyright Mark Hahn using the standard MIT license.
 