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
  factory Codec

  constructor: -> return super
  initialize: (aOptions)->
    if 'number' is typeof aOptions
      @bufferSize = aOptions
    else if aOptions
      @bufferSize = aOptions.bufSize
    else
      @bufferSize = 1111


testCodecInstance = (obj, expectedClass, bufSize)->
  should.exist obj, "testCodecInstance:" + expectedClass.name
  obj.should.be.instanceOf expectedClass
  obj.should.be.instanceOf Codec
  if bufSize > 0
    obj.should.have.property 'bufferSize', bufSize
getClass = (aName, expectedClass, bufSize)->
  My = Codec[aName]
  should.exist My, "My"
  My.should.be.equal expectedClass
  opt = bufSize:bufSize if bufSize?
  my = My opt
  testCodecInstance my, expectedClass, bufSize
  my.should.be.equal Codec(aName)
  My
describe "CustomFactory", ->
    #before (done)->
    #after (done)->
    register  = Codec.register
    aliases   = Codec.aliases
    unregister= Codec.unregister

    class MyNewCodec
      register(MyNewCodec).should.be.ok
      constructor: Codec
    class MyBufferCodec
      register(MyBufferCodec).should.be.ok
      constructor: Codec
    class MyNewSubCodec
      register(MyNewSubCodec, MyNewCodec).should.be.ok
      constructor: -> return super
    class MyNewSub1Codec
      register(MyNewSub1Codec, MyNewSubCodec).should.be.ok
      constructor: Codec
    it "should have register instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.have.property 'register'
    it "should have unregister instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.have.property 'unregister'
    it "should have registered instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.have.property 'registered'
    it "should have registeredClass instance method", ->
      myCodec = Codec('MyNew')
      testCodecInstance myCodec, MyNewCodec
      myCodec.should.have.property 'registeredClass'
    describe "Class(Static) Methods", ->
      describe ".register", ->
        it "should register a new Codec Class with default.", ->
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
        it "should register a new Codec Class with parent Codec Class.", ->
          myCodec = Codec('MyNewSub')
          should.exist myCodec, "MyNewSub instance"
          myCodec.should.be.instanceOf MyNewSubCodec
          myCodec.should.be.instanceOf MyNewCodec
          myCodec.should.be.instanceOf Codec
          MyCodec = getClass 'MyNew', MyNewCodec
          MyCodec.should.have.property 'MyNewSub', MyNewSubCodec
        it "should get an instance via the child Codec class directly.", ->
          myCodec = Codec('MyNewSub1')
          should.exist myCodec, "MyNewSub1Codec instance"
          myCodec.should.be.instanceOf MyNewSub1Codec
          myCodec.should.be.instanceOf MyNewSubCodec
          myCodec.should.be.instanceOf MyNewCodec
          myCodec.should.be.instanceOf Codec
          my = MyNewSub1Codec bufSize:123456
          testCodecInstance my, MyNewSub1Codec, 123456
          my.should.be.equal myCodec
        it "should register a new Codec Class with parent Codec Class and specified buffSize.", ->
          class MyBufferSubCodec
            register(MyBufferSubCodec, MyBufferCodec, bufSize:32).should.be.ok

            constructor: -> return super

          myCodec = Codec('MyBufferSub')
          testCodecInstance myCodec, MyBufferSubCodec, 32
          myCodec.should.be.instanceOf MyBufferCodec
        it "should register a new Codec Class with specified name", ->
          class MyBufferSub1Codec
            register(MyBufferSub1Codec, name:"bufit", bufSize:133).should.be.ok

            constructor: -> return super

          MyBufferSub1Codec.should.have.ownProperty 'register'
          myCodec = Codec('bufit')
          testCodecInstance myCodec, MyBufferSub1Codec, 133
        it "should register a new Codec Class with specified name and parent.", ->
          class MyBufferSub2Codec
            register(MyBufferSub2Codec, MyBufferCodec, name:"bufit2", bufSize:132).should.be.ok

            constructor: -> return super

          myCodec = Codec('bufit2')
          testCodecInstance myCodec, MyBufferSub2Codec, 132
          myCodec.should.be.instanceOf MyBufferCodec
      describe ".unregister", ->
        it "should unregister a Codec Class via name.", ->
          class MoCodec
            register(MoCodec).should.be.ok
            constructor: Codec
          MoCodec.should.have.ownProperty 'unregister'
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
        it "should unregister a Codec Class with parent.", ->
          class MoCodec
            register(MoCodec, MyBufferCodec).should.be.ok
            constructor: Codec
          myCodec = Codec('Mo')
          testCodecInstance myCodec, MoCodec
          myCodec.should.be.instanceOf MyBufferCodec
          MyBufferCodec.should.have.property 'Mo', MoCodec
          unregister('Mo').should.be.equal true
          myCodec = Codec('Mo')
          should.not.exist myCodec
          MyBufferCodec.should.not.have.property 'Mo'
          should.not.exist MyBufferCodec['Mo']
      describe ".constructor", ->
        it "should get a global codec object instance", ->
          MyCodec = getClass('MyNew', MyNewCodec)
        it "should get a global codec object instance with specified bufferSize", ->
          myCodec = Codec('MyNew', 123)
          testCodecInstance(myCodec, MyNewCodec, 123)
          myCodec.should.be.equal MyNewCodec()
        it "should get a global codec object instance and no initialize options", ->
          myCodec = Codec('MyNew', 122)
          myCodec = Codec('MyNew')
          testCodecInstance(myCodec, MyNewCodec, 122)
          myCodec.should.be.equal MyNewCodec()
        it "should get a global codec object instance with specified bufferSize options", ->
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
        it "should create a new codec object instance with specified bufferSize via child", ->
          MyCodec = getClass('MyNewSub1', MyNewSub1Codec, 12)
          myCodec = new MyCodec(bufSize:13)
          testCodecInstance myCodec, MyNewSub1Codec, 13
          myCodec.should.be.not.equal Codec("MyNewSub1")
        it "should bypass the codec object instance", ->
          myCodec = Codec('MyBuffer', bufSize:33)
          my = Codec(myCodec)
          my.should.be.equal myCodec
        it "should bypass the codec object instance and expand the bufferSize", ->
          myCodec = Codec('MyBuffer', bufSize:33)
          my = Codec(myCodec, bufSize:900)
          my.should.be.equal myCodec
          my.bufferSize.should.at.least 900
        it "should bypass the codec object instance and no initialize", ->
          myCodec = Codec('MyBuffer', bufSize:33)
          testCodecInstance myCodec, MyBufferCodec, 33
          my = Codec(myCodec)
          my.should.be.equal myCodec
          my.bufferSize.should.be.equal 33
        it "should return undefined for unkown codec name", ->
          myCodec = Codec('Notfound')
          should.not.exist myCodec
        it "should return undefined for illegal codec name argument", ->
          myCodec = Codec()
          should.not.exist myCodec


      describe ".aliases", ->
        class MyAliasCodec
          register MyAliasCodec, Codec
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
      describe ".register()", ->
        it "should register a class to itself", ->
          class MyXCodec
            aliases 'MyX', 'x', 'x1'
            constructor: -> return super
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
          myCodec.register MyXCodec
          myCodec = Codec("MyX")
          testCodecInstance myCodec, MyXCodec
          myCodec = Codec("x")
          testCodecInstance myCodec, MyXCodec
          myCodec = Codec("x1")
          testCodecInstance myCodec, MyXCodec
        it "should register a class to itself with options", ->
          MyYCodec = createCtor "MyYCodec"
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
          myCodec.register MyYCodec, bufSize: 1301
          myCodec = Codec("MyY")
          testCodecInstance myCodec, MyYCodec, 1301
      describe ".registered()", ->
        it "should get registered instance from itself", ->
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
          myCodec = myCodec.registered 'MyY'
          testCodecInstance myCodec, Codec['MyY']
          myCodec.should.be.equal Codec('MyY')
      describe ".registeredClass()", ->
        it "should get registered class from itself", ->
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
          MyY = myCodec.registeredClass 'MyY'
          should.exist MyY, "MyY"
          getClass "MyY", MyY
      describe ".unregister()", ->
        it "should unregister a class from itself", ->
          myCodec = Codec('MyY')
          testCodecInstance myCodec, Codec['MyY']
          myCodec.unregister("MyY").should.be.equal true
          myCodec = Codec('MyY')
          should.not.exist myCodec, "MyY"
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
        myCodec = Codec("MyN", 3512)
        testCodecInstance myCodec, MyNCodec, 3512
      it "should pass non-object aOptions via self", ->
        v = Math.random()
        myCodec = MyNCodec(v)
        testCodecInstance myCodec, MyNCodec, v

