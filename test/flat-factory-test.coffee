inherits        = require 'inherits-ex/lib/inherits'
chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
chai.use(sinonChai)

createCtor      = require 'inherits-ex/lib/createCtor'
factory         = require '../src/custom-factory'
setImmediate    = setImmediate || process.nextTick


class Codec
  factory Codec, flatOnly: true

  constructor: -> return super
  initialize: (aOptions)->
    if 'number' is typeof aOptions
      @bufferSize = aOptions
    else if aOptions
      @bufferSize = aOptions.bufSize



testCodecInstance = (obj, expectedClass, bufSize)->
  should.exist obj, "testCodecInstance:" + expectedClass.name
  obj.should.be.instanceOf expectedClass
  obj.should.be.instanceOf Codec
  if bufSize > 0
    obj.bufferSize.should.be.equal bufSize
getClass = (aName, expectedClass, bufSize)->
  My = Codec[aName]
  should.exist My, "My"
  My.should.be.equal expectedClass
  opt = bufSize:bufSize if bufSize?
  my = My opt
  testCodecInstance my, expectedClass, bufSize
  my.should.be.equal Codec(aName)
  My
describe "FlatFactory", ->
    #before (done)->
    #after (done)->
    register  = Codec.register
    aliases   = Codec.aliases
    unregister= Codec.unregister

    class MyNewCodec
      register(MyNewCodec).should.be.ok
      aliases MyNewCodec, 'new'
      constructor: Codec
    class MyBufferCodec
      register(MyBufferCodec).should.be.ok
      constructor: Codec
    it "should not have register instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.not.have.property 'register'
    it "should not have unregister instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.not.have.property 'unregister'
    it "should not have registered instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.not.have.property 'registered'
    it "should not have registeredClass instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.not.have.property 'registeredClass'
    describe "Class(Static) Methods", ->
      describe ".register", ->
        it "should register a new Codec Class with default.", ->
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
        it "should register a new Codec Class with specified name", ->
          class MyBufferSub1Codec
            register(MyBufferSub1Codec, name:"bufit", bufSize:133).should.be.ok

            constructor: -> return super

          MyBufferSub1Codec.should.not.have.ownProperty 'register'
          myCodec = Codec('bufit')
          testCodecInstance myCodec, MyBufferSub1Codec, 133
      describe ".registeredClass", ->
        it "should get registered Codec Class.", ->
          My = Codec.registeredClass 'MyNew'
          should.exist My
          MyCodec = getClass 'MyNew', MyNewCodec
          My.should.be.equal MyCodec
        it "should get registered Codec Class via alias.", ->
          My = Codec.registeredClass 'new'
          should.exist My
          My.should.be.equal MyNewCodec
      describe ".create", ->
        it "should create a new Codec object instance.", ->
          myCodec = Codec.create('MyNew', 457)
          testCodecInstance(myCodec, MyNewCodec, 457)
          myCodec.should.not.be.equal MyNewCodec()
      describe ".unregister", ->
        it "should unregister a Codec Class via name.", ->
          class MoCodec
            register(MoCodec).should.be.ok
            constructor: Codec
          MoCodec.should.not.have.ownProperty 'unregister'
          myCodec = Codec('Mo')
          testCodecInstance myCodec, MoCodec
          unregister('Mo').should.be.equal true
          myCodec = Codec('Mo')
          should.not.exist myCodec
        it "should unregister a Codec Class via class.", ->
          class MoCodec
            register(MoCodec).should.be.ok
            constructor: Codec
          myCodec = Codec('Mo')
          testCodecInstance myCodec, MoCodec
          unregister(MoCodec).should.be.equal true
          myCodec = Codec('Mo')
          should.not.exist myCodec
      describe ".constructor", ->
        it "should get a global codec object instance", ->
          MyCodec = getClass('MyNew', MyNewCodec)
        it "should get a global codec object instance with specified bufferSize", ->
          myCodec = Codec('MyNew', bufSize:123)
          testCodecInstance(myCodec, MyNewCodec, 123)
          myCodec.should.be.equal MyNewCodec()
        it "should get a global codec object instance with specified bufferSize", ->
          myCodec = Codec('MyBuffer', bufSize:33)
          testCodecInstance(myCodec, MyBufferCodec, 33)
          myCodec.should.be.equal MyBufferCodec()
        it "should get a global codec object instance with specified bufferSize From the CodecClass", ->
          MyCodec = getClass('MyBuffer', MyBufferCodec, 16)
        it "should create a new codec object instance", ->
          MyCodec = getClass('MyNew', MyNewCodec)
          should.exist MyCodec
          myCodec = new MyCodec()
          testCodecInstance myCodec, MyNewCodec
          myCodec.should.be.not.equal Codec("myNew")
        it "should create a new codec object instance with specified bufferSize", ->
          MyCodec = getClass('MyBuffer', MyBufferCodec, 12)
          myCodec = new MyCodec(bufSize:13)
          testCodecInstance myCodec, MyBufferCodec, 13
          myCodec.should.be.not.equal Codec("MyBuffer")
        it "should bypass the codec object instance", ->
          myCodec = Codec('MyBuffer', bufSize:33)
          my = Codec(myCodec)
          my.should.be.equal myCodec
        it "should bypass the codec object instance and expand the bufferSize", ->
          myCodec = Codec('MyBuffer', bufSize:33)
          my = Codec(myCodec, bufSize:900)
          my.should.be.equal myCodec
          my.bufferSize.should.at.least 900
        it "should return undefined for unkown codec name", ->
          myCodec = Codec('Notfound')
          should.not.exist myCodec
        it "should return undefined for illegal codec name argument", ->
          myCodec = Codec()
          should.not.exist myCodec


      describe ".aliases", ->
        class MyAliasCodec
          register MyAliasCodec
          aliases  MyAliasCodec, 'alia1', 'other'

          constructor: -> return super

        it "should get a global codec object instance via alias", ->
          myCodec = Codec('alia1')
          testCodecInstance myCodec, MyAliasCodec
          other = Codec('other')
          testCodecInstance myCodec, MyAliasCodec
          other.should.equal myCodec
        it "should remove aliases after unregister too", ->
          unregister MyAliasCodec
          myCodec = Codec('alia1')
          should.not.exist myCodec, "alia1"
          other = Codec('other')
          should.not.exist myCodec, "other"

    describe "Instance Methods", ->
      describe ".toString()", ->
        it "should get name toString", ->
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
          myCodec.toString().should.be.equal "MyNew"
    describe "the aOptions could be non-object", ->
      MyNCodec = createCtor "MyNCodec"
      initSize = Math.random()
      register MyNCodec, initSize
      it "should pass non-object aOptions via register", ->
        myCodec = Codec('MyNew')
        testCodecInstance myCodec, MyNewCodec
        myCodec = Codec("MyN")
        testCodecInstance myCodec, MyNCodec, initSize
      it "should pass non-object aOptions via Codec", ->
        v = Math.random()
        myCodec = Codec("MyN", v)
        testCodecInstance myCodec, MyNCodec, v
      it "should pass non-object aOptions via self", ->
        v = Math.random()
        myCodec = MyNCodec(v)
        testCodecInstance myCodec, MyNCodec, v

