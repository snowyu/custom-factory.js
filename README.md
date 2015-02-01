### CustomFactory [![Build Status](https://img.shields.io/travis/snowyu/custom-factory.js/master.svg)](http://travis-ci.org/snowyu/custom-factory.js) [![npm](https://img.shields.io/npm/v/custom-factory.js.svg)](https://npmjs.org/package/custom-factory.js) [![downloads](https://img.shields.io/npm/dm/custom-factory.js.svg)](https://npmjs.org/package/custom-factory.js) [![license](https://img.shields.io/npm/l/custom-factory.js.svg)](https://npmjs.org/package/custom-factory.js) 

the abstract factory class to register/unregister and alias your objects on CustomFactory.

* CustomFactory
  * register(aClass):  *(class method)* register the aClass to the CustomFactory
  * unregister(): *(class method)* unregister the aClass from the CustomFactory
  * alias/aliases(aClass, aliases...): *(class method)* create aliases to the aClass.
  * constructor(aName): get a singleton instance from the CustomFactory
  * CustomFactory[aName]: get the registered class from the CustomFactory.


# Usage


### developer:

```coffee

factory = require 'custom-factory'

class Codec
  factory Codec

  constructor: -> return super
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
# lowercase name only here:
JsonCodec = Codec.classes['json']
# or
JsonCodec = TextCodec['json']

# get the global JsonCodec instance from the Codec
json = Codec('json')
# or:
json = JsonCodec()

JsonCodec().should.be.equal Codec('json')

# create a new JsonCodec instance.
json2 = new JsonCodec()

json2.should.not.be.equal json


```


