inherits        = require 'inherits-ex/lib/inherits'
chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
chai.use(sinonChai)

createCtor      = require 'inherits-ex/lib/createCtor'
{FlatFactory}   = require '../src/flat-factory'
setImmediate    = setImmediate || process.nextTick


class Codec
  inherits Codec, FlatFactory
  # factory Codec

  constructor: -> return super
  initialize: (aOptions)->
    if 'number' is typeof aOptions
      @bufferSize = aOptions
    else if aOptions
      @bufferSize = aOptions.bufSize

testItemExists = (obj, expectedClass)->
  should.exist obj, "testItemExists:" + expectedClass.name
  obj.should.be.equal expectedClass

describe.only "FlatFactory", ->
    #before (done)->
    #after (done)->
    register  = Codec.register.bind(Codec)
    aliases   = Codec.aliases.bind(Codec)
    unregister= Codec.unregister.bind(Codec)

    class MyNewCodec
      register(MyNewCodec).should.be.ok
      aliases MyNewCodec, 'new'
    class MyBufferCodec
      register(MyBufferCodec).should.be.ok
    it "should get registered item", ->
      myCodec = Codec('MyNew')
      testItemExists myCodec, MyNewCodec
      myCodec = Codec('MyBuffer')
      testItemExists myCodec, MyBufferCodec
    it "should get registered item via alias", ->
      myCodec = Codec('new')
      testItemExists myCodec, MyNewCodec
    it "should enum all registered items by forEach", ->
      result = []
      Codec.forEach (value, name) -> result.push {name, value}
      result.should.have.length 2
      result.map((i)->i.name).should.be.deep.equal ['MyNew', 'MyBuffer']
    describe "Class(Static) Methods", ->
      describe ".register", ->
        it "should register a new Codec Class with specified name", ->
          class MyBufferSub1Codec
            register(MyBufferSub1Codec, name:"bufit").should.be.ok

          myCodec = Codec('bufit')
          testItemExists myCodec, MyBufferSub1Codec
      describe ".unregister", ->
        it "should unregister a Codec Class via name.", ->
          class MoCodec
            register(MoCodec).should.be.ok
          myCodec = Codec('Mo')
          testItemExists myCodec, MoCodec
          unregister('Mo').should.be.equal true
          myCodec = Codec('Mo')
          should.not.exist myCodec
        it "should unregister a Codec Class via class.", ->
          class MoCodec
            register(MoCodec).should.be.ok
            constructor: Codec
          myCodec = Codec('Mo')
          testItemExists myCodec, MoCodec
          unregister(MoCodec).should.be.equal true
          myCodec = Codec('Mo')
          should.not.exist myCodec
      describe ".constructor", ->
        it "should return undefined for unkown codec name", ->
          myCodec = Codec('Notfound')
          should.not.exist myCodec
        it "should return undefined for illegal codec name argument", ->
          myCodec = Codec()
          should.not.exist myCodec


      describe ".aliases", ->
        class MyAliasCodec
        before ->
          register MyAliasCodec
          aliases  MyAliasCodec, 'alia1', 'other'

        after ->
          unregister MyAliasCodec

        it "should get a registered via alias", ->
          myCodec = Codec('alia1')
          testItemExists myCodec, MyAliasCodec
          other = Codec('other')
          testItemExists myCodec, MyAliasCodec
          other.should.equal myCodec
        it "should remove aliases after unregister too", ->
          unregister MyAliasCodec
          myCodec = Codec('alia1')
          should.not.exist myCodec, "alia1"
          other = Codec('other')
          should.not.exist myCodec, "other"

