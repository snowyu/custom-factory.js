### CustomFactory [![Build Status](https://img.shields.io/travis/snowyu/custom-factory.js/master.svg)](http://travis-ci.org/snowyu/custom-factory.js) [![npm](https://img.shields.io/npm/v/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![downloads](https://img.shields.io/npm/dm/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![license](https://img.shields.io/npm/l/custom-factory.svg)](https://npmjs.org/package/custom-factory)


easily add the factory ability to your class which can singleton, name, register/unregister and aliases your object items.

The factory could be hierarchical or flat. defaults to hierarchical.
The flat factory means register only on the Root Factory.

* CustomFactory(these class/static methods will be added to your factory class)
  * `register(aClass[, aParentClass=factory[, aOptions]])`:  *(class method)* register the aClass to your Factory Class.
    * aOptions *(object|string)*: It will use the aOptions as default options to create instance.
      * it is the registered name if aOptions is string.
      * name: use the name instead of class name to register if any.
        or it will use the class name(remove the last factory name if exists) to register.
      * createOnDemand *(boolean)*: create the factory item instance on demand 
        or create it immediately. defaults to true.
      * baseNameOnly *(number)*: extract basename from class name to register it.
        defaults to 1. the baseNameOnly number can be used on hierarchical factory.
        0 means use the whole class name to register it, no extract.
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

These instance methods added if it is not flatOnly factory:

* `register(aClass[, aOptions])`: register a class to itself.
* `unregister(aName|aClass)`: same as the unregister class method.
* `registered(aName)`: get a singleton instance which is registered to itself.
* `registeredClass[aName]`: get the registered class.
* `path(aRootName = Factory.name)`: get the path string of this factory item
* `pathArray(aRootName = Factory.name)`: get the path array of this factory item

**Note**: the name is **case sensitive**.


# Changes

## v1.4.0

These attributes could be visited via instance:

+ baseNameOnly option to extract basename from class name when register it.
* `Factory._objects`: mark deprecated. use the `Factory::_objects` instead
* `Factory._aliases`: mark deprecated. use the `Factory::_aliases` instead


# Usage


### developer:

```coffee

factory = require 'custom-factory'

class Codec
  factory Codec

  constructor: (aName, aOptions)->return super
  initialize: (aOptions)->
    @bufferSize = aOptions.bufSize if aOptions
  encode:->

register = Codec.register
aliases  = Codec.aliases

class TextCodec
  register TextCodec
  aliases TextCodec, 'utf8', 'utf-8'
  constructor: Codec
  encode:->

class JsonCodec
  register JsonCodec, TextCodec
  constructor: -> return super
  encode:->

# register with specifed name:
class TestCodec
  register TestCodec, 'MyTest'
  # or like this:
  #register TestCodec, name: 'MyTest'


```

Enable a flat factory:

```coffee

class Codec
  factory Codec, flatOnly: true

```

### user

```coffee
# get the JsonCodec Class
# note: name is case-sensitive!
TextCodec = Codec['Text']
JsonCodec = Codec['Json']
# or
JsonCodec = TextCodec['Json']

# get the global JsonCodec instance from the Codec
json = Codec('Json', bufSize: 12)
# or:
json = JsonCodec()
text = Codec('Text') # or Codec('utf8')

JsonCodec().should.be.equal Codec('Json')

# create a new JsonCodec instance.
json2 = new JsonCodec(bufSize: 123)

json2.should.not.be.equal json


```
