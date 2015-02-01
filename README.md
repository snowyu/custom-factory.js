### CustomFactory [![Build Status](https://img.shields.io/travis/snowyu/custom-factory.js/master.svg)](http://travis-ci.org/snowyu/custom-factory.js) [![npm](https://img.shields.io/npm/v/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![downloads](https://img.shields.io/npm/dm/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![license](https://img.shields.io/npm/l/custom-factory.svg)](https://npmjs.org/package/custom-factory) 


easily add the factory ability to your class which can singleton, name, register/unregister and aliases your object items.

* CustomFactory
  * `register(aClass[, aParentClass=factory[, aOptions]])`:  *(class method)* register the aClass to your Factory Class.
    * aOptions: It will use the aOptions as default options to create instance.
      * name: use the name instead of class name to register if any.
        or it will use the class name(remove the last factory name if exists) to register.
  * `unregister(aName)`: *(class method)* unregister the aName from the CustomFactory
  * `alias/aliases(aClass, aliases...)`: *(class method)* create aliases to the aClass.
  * `constructor(aName)`: get a singleton instance from your Factory class.
  * `Factory[aName]`: get the registered class from your Factory class.

**Note**: the name is **case sensitive**.

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

