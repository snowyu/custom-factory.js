### CustomFactory [![Build Status](https://img.shields.io/travis/snowyu/custom-factory.js/master.svg)](http://travis-ci.org/snowyu/custom-factory.js) [![npm](https://img.shields.io/npm/v/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![downloads](https://img.shields.io/npm/dm/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![license](https://img.shields.io/npm/l/custom-factory.svg)](https://npmjs.org/package/custom-factory)


easily add the factory ability to your class which can singleton, name, register/unregister and aliases your object items.

The factory could be hierarchical or flat. defaults to hierarchical.
The flat factory means register only on the Root Factory.

# Usage


### factory developer:


for coffee-script:

```coffee

factory = require 'custom-factory'

class Codec
  # make the Codec factory-able:
  factory Codec
  # if you wanna a flat factory:
  #factory Codec, flatOnly: true

  constructor: (aName, aOptions)->return super
  # the constructor's aOptions will be passed through
  initialize: (aOptions)->
    @bufferSize = aOptions.bufSize if aOptions
  # your factory methods:
  encode: (aValue)->

register = Codec.register
aliases  = Codec.aliases

class TextCodec
  register TextCodec
  aliases TextCodec, 'utf8', 'utf-8'
  constructor: Codec
  encode: (aValue)->

class JsonCodec
  register JsonCodec, TextCodec
  constructor: -> return super
  encode: (aValue)->

class TestCodec
  # register with a specified name:
  register TestCodec, 'MyTest'
  # or like this:
  # register TestCodec, name: 'MyTest'


```

for javascript:

```js
var factory = require('custom-factory')

// Class Codec
function Codec(){
  return Codec.__super__.constructor.apply(this, arguments);
}

// make the Codec factory-able:
factory(Codec)
// if you wanna a flat factory:
// factory(Codec, {flatOnly: true})

// the constructor's aOptions will be passed through
Codec.prototype.initialize = function(aOptions){
  if (aOptions)
    this.bufferSize = aOptions.bufSize
}

// your factory methods:
Codec.prototype.encode = function(aValue){}

var register = Codec.register
var aliases  = Codec.aliases

// Class TextCodec
function TextCodec() {
  Codec.apply(this, arguments)
}
register(TextCodec)
aliases(TextCodec, 'utf8', 'utf-8')
TextCodec.prototype.encode = function(aValue){}

// class JsonCodec
function JsonCodec() {
  TextCodec.apply(this, arguments)
}
register(JsonCodec)
JsonCodec.prototype.encode = function(aValue){}

// class TestCodec
function TestCodec() {
  Codec.apply(this, arguments)
}
// register with a specified name:
register(TestCodec, 'MyTest')
// or like this:
// register(TestCodec, {name: 'MyTest'})
```

### user


```js
var TextCodec = Codec['Text']     // # get the JsonCodec Class
var JsonCodec = Codec['Json']     // # note: name is case-sensitive!
var JsonCodec = TextCodec['Json'] // # or like this

var json = Codec('Json', bufSize: 12) // # get the singleton instance from the Codec
var json = JsonCodec()                // # or like this
var text = Codec('Text')              // # or Codec('utf8')

JsonCodec().should.be.equal(Codec('Json'))

var json2 = new JsonCodec(bufSize: 123) // # create a new JsonCodec instance, do not use singleton.
var json2.should.not.be.equal(json)

```

# API

* CustomFactory(these class/static methods will be added to your factory class)
  * `register(aClass[, aParentClass=factory[, aOptions]])`:  *(class method)* register the aClass to your Factory Class.
    * aOptions *(object|string)*: It will use the aOptions as default options to create instance.
      * it is the registered name if aOptions is string.
      * name: use the name instead of class name to register if any.
        or it will use the class name(remove the last factory name if exists) to register.
      * createOnDemand *(boolean)*: create the factory item instance on demand
        or create it immediately. defaults to true.
      * baseNameOnly *(number)*: extract basename from class name to register it if no specified name.
        defaults to 1. the baseNameOnly number can be used on hierarchical factory, means max level to extract basename.
        0 means use the whole class name to register it, no extract.
        * eg, the `Codec` is a Root Factory, we add the `TextCodec` to "Codec", add the `JsonTextCodec` to "TextCodec"
          * baseNameOnly = 1: `TextCodec` name is 'Text', `JsonTextCodec` name is 'JsonText'
          * baseNameOnly = 2: `TextCodec` name is 'Text', `JsonTextCodec` name is 'Json'
      * displayName *(String)*: the display name.
    * aParentClass: it is not allowed if it's a flatOnly factory.
  * `unregister(aName|aClass)`: *(class method)* unregister the class or name from the Factory
  * `alias/aliases(aClass, aliases...)`: *(class method)* create aliases to the aClass.
  * `constructor(aName, aOptions)`: get a singleton instance or create a new instance item.
  * `constructor(aOptions)`: get a singleton instance or create a new instance item.
    * aOptions: *(object)*
      * name: the factory item name. defaults to the constructor name
      * fnGet: *(function)* replace the default '`get`' method.
  * `constructor(aInstance, aOptions)`: apply(re-initialize) the aOptions to the aInstance .
  * `create(aName, aOptions)`: create a new object instance
  * `get(aName, aOptions)`: get the singleton object instance
  * `formatName(aName)`: format the registered name and return, defaults to same as aName. you can override this method to implement case insensitive.
  * `Factory[aName]`: get the registered class from your Factory class.
  * `getClassList(aClass)`: get the hierarchical class path list array of this aClass.
  * `path(aClass, aRootName = Factory.name)`: get the path string of this aClass factory item.
  * `pathArray(aClass, aRootName = Factory.name)`: get the path array of this aClass factory item.
  * `registeredClass(aName)`: get the registered class via name.
  * `forEach(callback)`: iterate all the singleton instances to callback.
    * `callback` *function(instance, name)*

These instance methods added if it is not flatOnly factory:

* `register(aClass[, aOptions])`: register a class to itself.
* `unregister(aName|aClass)`: same as the unregister class method.
* `registered(aName)`: get a singleton instance which is registered to itself.
* `registeredClass[aName]`: get the registered class.
* `path(aRootName = Factory.name)`: get the path string of this factory item
* `pathArray(aRootName = Factory.name)`: get the path array of this factory item

**Note**: the name is **case sensitive**.


# Changes

## v.1.5

+ *broken* (1.5)rename Factory::get() instance method to Factory::getFactoryItem()

## v1.4

+ add baseNameOnly option to extract basename from class name when register it.
* *broken* `Factory._objects`: mark deprecated. use the `Factory::_objects` instead
* *broken* `Factory._aliases`: mark deprecated. use the `Factory::_aliases` instead
+ (1.4.4)It will be treated as customized path name if the registered name is beginning with path delimiter('/')
  * affects to path() and pathArray()
* (1.4.5)all added properties of the factory class are non-enumerable now.
+ (1.4.5)add forEach()/forEachClass() to iterate the registered items.
  * break if callback function return 'brk'
+ (1.4.6)add Factory::get() instance method to get registered items.
* (1.4.10) aliases() can get the aliases of a class itself.
+ (1.4.11) add the displayName() function to get or set display name.
