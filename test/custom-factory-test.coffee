inherits        = require 'inherits-ex/lib/inherits'
chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
chai.use(sinonChai)

factory         = require '../src/custom-factory'
setImmediate    = setImmediate || process.nextTick


class Codec
  factory Codec

  constructor: -> return super
  initialize: (aOptions)->
    @bufferSize = aOptions.bufSize if aOptions



testCodecInstance = (obj, expectedClass, bufSize)->
  should.exist obj, "testCodecInstance:" + expectedClass.name
  obj.should.be.instanceOf expectedClass
  obj.should.be.instanceOf Codec
  if bufSize > 0
    obj.bufferSize.should.be.equal bufSize
getClass = (aName, expectedClass, bufSize)->
  My = Codec[aName]
  should.exist My
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
    describe "Class(Static) Methods", ->
      describe ".register", ->
        it "should register a new Codec Class with default.", ->
          myCodec = Codec('MyNew')
          should.exist myCodec
          myCodec.should.be.instanceOf MyNewCodec
          myCodec.should.be.instanceOf Codec
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
        it "should unregister a Codec Class with default.", ->
          class MoCodec
            register(MoCodec).should.be.ok
            constructor: Codec
          myCodec = Codec('Mo')
          testCodecInstance myCodec, MoCodec
          unregister('Mo').should.be.equal true
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


