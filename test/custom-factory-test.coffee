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
      aliases MyNewCodec, 'new'
      constructor: Codec
    class MyBufferCodec
      register(MyBufferCodec, displayName:'my buffer').should.be.ok
      constructor: Codec
    class MyNewSubCodec
      register(MyNewSubCodec, MyNewCodec).should.be.ok
      aliases MyNewSubCodec, 'newsub', 'sub'
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
    it "should have alias static method", ->
      MyNewCodec.should.have.ownProperty 'alias'
      MyNewCodec.should.have.ownProperty 'aliases'
    it "should have register static method", ->
      MyNewCodec.should.have.ownProperty 'register'
    it "should have create static method", ->
      MyNewCodec.should.have.ownProperty 'create'
    it "should have getRealNameFromAlias static method", ->
      MyNewCodec.should.have.ownProperty 'getRealNameFromAlias'

    describe "Class(Static) Methods", ->
      describe ".displayName", ->
        it "should get/set displayName.", ->
          result = MyNewCodec.displayName()
          expect(result).to.be.equal 'new'
          result = Codec.displayName(MyNewCodec)
          expect(result).to.be.equal 'new'
          MyNewCodec.displayName('new codec')
          result = MyNewCodec.displayName()
          expect(result).to.be.equal 'new codec'
          result = Codec.displayName(MyNewCodec)
          expect(result).to.be.equal 'new codec'
          result = MyBufferCodec.displayName()
          expect(result).to.be.equal 'my buffer'
          result = MyNewSub1Codec.displayName()
          expect(result).to.be.equal 'MyNewSub1'
          MyNewCodec.displayName('')
          result = MyNewCodec.displayName()
          expect(result).to.be.equal 'new'

      describe ".forEach", ->
        MyNewBufferCodec = createCtor "MyNewBuffer"
        before ->
          MyNewCodec.register MyNewBufferCodec
        after ->
          MyNewCodec.unregister MyNewBufferCodec
        it "should get all registered items.", ->
          result = []
          Codec.forEach (v, k)->result.push name:k, path: v.path()
          result.should.be.deep.equal [
            { name: 'MyNew', path: '/Codec/MyNew' }
            { name: 'MyBuffer', path: '/Codec/MyBuffer' }
            { name: 'MyNewSub', path: '/Codec/MyNew/MyNewSub' }
            { name: 'MyNewSub1', path: '/Codec/MyNew/MyNewSub/MyNewSub1' }
            { name: 'MyNewBuffer', path: '/Codec/MyNew/MyNewBuffer' }
          ]
          result = []
          MyNewCodec.forEach (v, k)->result.push name:k, path: v.path()
          result.should.be.deep.equal [
            { name: 'MyNewSub', path: '/Codec/MyNew/MyNewSub' }
            { name: 'MyNewBuffer', path: '/Codec/MyNew/MyNewBuffer' }
          ]
        it "should break forEach if callback return 'brk'.", ->
          result = []
          Codec.forEach (v, k)->
            result.push name:k, path: v.path()
            return 'brk' if result.length is 2
          result.should.be.deep.equal [
            { name: 'MyNew', path: '/Codec/MyNew' }
            { name: 'MyBuffer', path: '/Codec/MyBuffer' }
          ]

      describe ".register", ->
        it "should not register a new Codec Class with duplicated name.", ->
          MyYCodec = createCtor "MyYCodec"
          should.throw register.bind(null, MyYCodec, name: 'MyNew'), 'has already been registered'
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
        it "should register a new Codec Class with specified name via string", ->
          class MyBufferSub3Codec
            register(MyBufferSub3Codec, "bufit3").should.be.ok

            constructor: -> return super

          MyBufferSub3Codec.should.have.ownProperty 'register'
          myCodec = Codec('bufit3')
          testCodecInstance myCodec, MyBufferSub3Codec
        it "should register a new Codec Class with specified name(via string) and parent.", ->
          class MyBufferSub4Codec
            register(MyBufferSub4Codec, MyBufferCodec, "bufit4").should.be.ok

            constructor: -> return super

          myCodec = Codec('bufit4')
          testCodecInstance myCodec, MyBufferSub4Codec
          myCodec.should.be.instanceOf MyBufferCodec
        it "should register a new Codec Class with createOnDemand is false.", ->
          class MyBufferSub5Codec
            register(MyBufferSub5Codec, MyBufferCodec, createOnDemand:false).should.be.ok

            constructor: -> return super

          result = Codec::_objects['MyBufferSub5']
          testCodecInstance result, MyBufferSub5Codec
          myCodec = Codec('MyBufferSub5')
          Codec::_objects.should.be.equal myCodec._objects
          testCodecInstance myCodec, MyBufferSub5Codec
          myCodec.should.be.instanceOf MyBufferCodec
          myCodec.should.be.equal result
        it "should register a new sub child Codec Class with proper name.", ->
          class ASubMyNewCodec
            register(ASubMyNewCodec, MyNewCodec, baseNameOnly:2).should.be.ok
            aliases ASubMyNewCodec, 'ASubMyNew', 'asub'
            constructor: -> return super
          class BSubASub
            register(BSubASub, ASubMyNewCodec, baseNameOnly:3).should.be.ok
            constructor: Codec
          class CSubBSubASub
            register(CSubBSubASub, BSubASub, baseNameOnly:4).should.be.ok
            constructor: -> return super
          class DSubCSubBSubASub
            register(DSubCSubBSubASub, CSubBSubASub, baseNameOnly:4).should.be.ok
            constructor: -> return super

          ASubMyNewCodec::name.should.be.equal 'ASub'
          BSubASub::name.should.be.equal 'BSub'
          CSubBSubASub::name.should.be.equal 'CSub'
          DSubCSubBSubASub::name.should.be.equal 'DSubCSub'

          myCodec = Codec('ASub')
          testCodecInstance myCodec, ASubMyNewCodec
          myCodec.should.be.instanceOf ASubMyNewCodec
          myCodec = Codec('BSub')
          testCodecInstance myCodec, BSubASub
          myCodec.should.be.instanceOf BSubASub
          myCodec = Codec('CSub')
          testCodecInstance myCodec, CSubBSubASub
          myCodec.should.be.instanceOf CSubBSubASub
          myCodec = Codec('DSubCSub')
          testCodecInstance myCodec, DSubCSubBSubASub
          myCodec.should.be.instanceOf DSubCSubBSubASub

          unregister(ASubMyNewCodec).should.be.ok
          unregister('BSub').should.be.ok
          unregister(CSubBSubASub).should.be.ok
          unregister('DSubCSub').should.be.ok

          myCodec = Codec('ASub')
          should.not.exist myCodec
          myCodec = Codec('BSub')
          should.not.exist myCodec
          myCodec = Codec('CSub')
          should.not.exist myCodec
          myCodec = Codec('DSubCSub')
          should.not.exist myCodec

      describe ".getClassList", ->
        it "should get the empty class list for root factory", ->
          Codec.getClassList(Codec).should.have.length 0
        it "should get the class list", ->
          result = Codec.getClassList(MyNewSub1Codec)
          result.should.have.length 3
          result.should.be.deep.equal [
            MyNewSub1Codec, MyNewSubCodec, MyNewCodec
          ]
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
        it "should get registered Codec Class on parent.", ->
          My = MyNewCodec.registeredClass 'MyNewSub'
          should.exist My
          My.should.be.equal MyNewSubCodec
          My = MyNewCodec.registeredClass 'MyBuffer'
          should.not.exist My
        it "should get registered Codec Class on parent via alias.", ->
          My = MyNewCodec.registeredClass 'newsub'
          should.exist My
          My.should.be.equal MyNewSubCodec
          My = MyNewCodec.registeredClass 'MyBuffer'
          should.not.exist My
      describe ".create", ->
        it "should create a new Codec object instance.", ->
          myCodec = Codec.create('MyNew', 457)
          testCodecInstance(myCodec, MyNewCodec, 457)
          myCodec.should.not.be.equal MyNewCodec()
        it "should create a new Codec object instance via Child MyNew.", ->
          myCodec = MyNewCodec.create('MyNewSub', 457)
          testCodecInstance(myCodec, MyNewSubCodec, 457)
          myCodec.should.not.be.equal MyNewSubCodec()
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
        it "should unregister a Codec Class via a custom name.", ->
          class MoCodec
            register(MoCodec, 'customName').should.be.ok
            constructor: Codec
          myCodec = Codec('customName')
          testCodecInstance myCodec, MoCodec
          unregister(MoCodec).should.be.equal true
          myCodec = Codec('customName')
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
        MyAliasCodec = null
        before ->
          MyAliasCodec = class MyAliasCodec
            register MyAliasCodec, Codec
            aliases  MyAliasCodec, 'alia1', 'other'

            constructor: -> return super
        after ->
          Codec.unregister MyAliasCodec

        it "should get aliases of a Codec", ->
          result = MyAliasCodec.aliases()
          expect(result).to.be.deep.equal ['alia1', 'other']
          result = aliases MyAliasCodec
          expect(result).to.be.deep.equal ['alia1', 'other']
        it "should get a global codec object instance via alias", ->
          myCodec = Codec('alia1')
          testCodecInstance myCodec, MyAliasCodec
          other = Codec('other')
          testCodecInstance myCodec, MyAliasCodec
          other.should.equal myCodec
        it "should get a codec class via alias", ->
          My = Codec.registeredClass 'alia1'
          should.exist My
          My.should.be.equal MyAliasCodec
          My = Codec.registeredClass 'other'
          should.exist My
          My.should.be.equal MyAliasCodec
          My = Codec.registeredClass 'MyAlias'
          should.exist My
          My.should.be.equal MyAliasCodec
        it "should remove aliases after unregister too", ->
          unregister MyAliasCodec
          myCodec = Codec('alia1')
          should.not.exist myCodec, "alia1"
          other = Codec('other')
          should.not.exist myCodec, "other"
      describe ".pathArray()", ->
        it "should get path name array", ->
          Codec.pathArray(MyNewSub1Codec).should.be.deep.equal ["Codec", "MyNew", "MyNewSub", "MyNewSub1"]
        it "should get path name array with custom root name", ->
          Codec.pathArray(MyNewSub1Codec, 'root').should.be.deep.equal ["root","MyNew", "MyNewSub", "MyNewSub1"]
        it "should get path name array with no root name", ->
          Codec.pathArray(MyNewSub1Codec, '').should.be.deep.equal ["MyNew", "MyNewSub", "MyNewSub1"]
          Codec.pathArray(MyNewSub1Codec, false).should.be.deep.equal ["MyNew", "MyNewSub", "MyNewSub1"]
      describe ".path()", ->
        it "should get path name ", ->
          Codec.path(MyNewSub1Codec).should.be.equal "/Codec/MyNew/MyNewSub/MyNewSub1"
        it "should get path name with custom root name", ->
          Codec.path(MyNewSub1Codec, 'root').should.be.equal "/root/MyNew/MyNewSub/MyNewSub1"
        it "should get path name with no root name", ->
          Codec.path(MyNewSub1Codec, '').should.be.deep.equal "/MyNew/MyNewSub/MyNewSub1"
          Codec.path(MyNewSub1Codec, false).should.be.deep.equal "/MyNew/MyNewSub/MyNewSub1"

    describe "change the root path name via ROOT_NAME", ->
      before ->
        Codec.ROOT_NAME = 'haha'
      after ->
        Codec.ROOT_NAME = Codec.name
      describe ".pathArray()", ->
        it "should get path name array", ->
          Codec.pathArray(MyNewSub1Codec).should.be.deep.equal ["haha", "MyNew", "MyNewSub", "MyNewSub1"]
        it "should get path name array with custom root name", ->
          Codec.pathArray(MyNewSub1Codec, 'root').should.be.deep.equal ["root","MyNew", "MyNewSub", "MyNewSub1"]
        it "should get path name array with no root name", ->
          Codec.pathArray(MyNewSub1Codec, '').should.be.deep.equal ["MyNew", "MyNewSub", "MyNewSub1"]
          Codec.pathArray(MyNewSub1Codec, false).should.be.deep.equal ["MyNew", "MyNewSub", "MyNewSub1"]
        it "should empty ROOT_NAME to disable root path name", ->
          Codec.ROOT_NAME = ''
          Codec.pathArray(MyNewSub1Codec).should.be.deep.equal ["MyNew", "MyNewSub", "MyNewSub1"]
          Codec.ROOT_NAME = 'haha'
      describe ".path()", ->
        it "should get path name ", ->
          Codec.path(MyNewSub1Codec).should.be.equal "/haha/MyNew/MyNewSub/MyNewSub1"
        it "should get path name with custom root name", ->
          Codec.path(MyNewSub1Codec, 'root').should.be.equal "/root/MyNew/MyNewSub/MyNewSub1"
        it "should get path name with no root name", ->
          Codec.path(MyNewSub1Codec, '').should.be.deep.equal "/MyNew/MyNewSub/MyNewSub1"
          Codec.path(MyNewSub1Codec, false).should.be.deep.equal "/MyNew/MyNewSub/MyNewSub1"
        it "should empty ROOT_NAME to disable root path name", ->
          Codec.ROOT_NAME = ''
          Codec.path(MyNewSub1Codec).should.be.deep.equal "/MyNew/MyNewSub/MyNewSub1"
          Codec.ROOT_NAME = 'haha'
        it "should get path name correctly", ->
          class MyPathCodec
            register MyPathCodec, Codec, name:'/test/path'

            constructor: -> return super

          expect(Codec::path()).be.equal '/haha'
          Codec.path(MyPathCodec).should.be.equal '/test/path'

    describe "Instance Methods", ->
      describe ".pathArray()", ->
        it "should get path name array", ->
          myCodec = Codec('MyNewSub1')
          testCodecInstance myCodec, MyNewSub1Codec
          myCodec.pathArray().should.be.deep.equal ["Codec", "MyNew", "MyNewSub", "MyNewSub1"]
        it "should get path name array with custom root name", ->
          myCodec = Codec('MyNewSub1')
          testCodecInstance myCodec, MyNewSub1Codec
          myCodec.pathArray('root').should.be.deep.equal ["root","MyNew", "MyNewSub", "MyNewSub1"]
        it "should get path name array with no root name", ->
          myCodec = Codec('MyNewSub1')
          testCodecInstance myCodec, MyNewSub1Codec
          myCodec.pathArray('').should.be.deep.equal ["MyNew", "MyNewSub", "MyNewSub1"]
          myCodec.pathArray(false).should.be.deep.equal ["MyNew", "MyNewSub", "MyNewSub1"]
      describe ".path()", ->
        it "should get path name ", ->
          myCodec = Codec('MyNewSub1')
          testCodecInstance myCodec, MyNewSub1Codec
          myCodec.path().should.be.equal "/Codec/MyNew/MyNewSub/MyNewSub1"
        it "should get path name with custom root name", ->
          myCodec = Codec('MyNewSub1')
          testCodecInstance myCodec, MyNewSub1Codec
          myCodec.path('root').should.be.equal "/root/MyNew/MyNewSub/MyNewSub1"
        it "should get path name with no root name", ->
          myCodec = Codec('MyNewSub1')
          testCodecInstance myCodec, MyNewSub1Codec
          myCodec.path('').should.be.deep.equal "/MyNew/MyNewSub/MyNewSub1"
          myCodec.path(false).should.be.deep.equal "/MyNew/MyNewSub/MyNewSub1"
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
        it "should get registered class via alias", ->
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
          MyX = myCodec.registeredClass 'x'
          should.exist MyX, "MyX"
          getClass "MyX", MyX
        it "should not get non-parent registered class", ->
          myCodec = Codec('MyNew')
          testCodecInstance myCodec, MyNewCodec
          MyBuffer = myCodec.registeredClass 'MyBuffer'
          should.not.exist MyBuffer, "MyBuffer"
      describe ".unregister()", ->
        it "should unregister a class from itself", ->
          myCodec = Codec('MyY')
          testCodecInstance myCodec, Codec['MyY']
          myCodec.unregister("MyY").should.be.equal true
          myCodec = Codec('MyY')
          should.not.exist myCodec, "MyY"
      describe ".getFactoryItem()", ->
        it "should get the codec via instance method", ->
          myCodec = Codec('MyNew')
          result = myCodec.getFactoryItem('MyNewSub')
          testCodecInstance result, MyNewSubCodec
      describe ".aliases()", ->
        MyAliasCodec = null
        before ->
          MyAliasCodec = class MyAliasCodec
            register MyAliasCodec, Codec
            aliases  MyAliasCodec, 'alia1', 'other'
            constructor: -> return super
        after ->
          Codec.unregister MyAliasCodec

        it "should get aliases of a Codec", ->
          myCodec = Codec('alia1')
          testCodecInstance myCodec, MyAliasCodec
          result = myCodec.aliases()
          expect(result).to.be.deep.equal ['alia1', 'other']
      describe ".displayName()", ->
        it "should get/set displayName.", ->
          myCodec = Codec('new')
          testCodecInstance myCodec, MyNewCodec
          result = myCodec.displayName()
          expect(result).to.be.equal 'new'
          myCodec.displayName('new codec')
          result = myCodec.displayName()
          expect(result).to.be.equal 'new codec'
          myCodec = Codec('MyBuffer')
          result = myCodec.displayName()
          expect(result).to.be.equal 'my buffer'
          myCodec = Codec('MyNewSub1')
          result = myCodec.displayName()
          expect(result).to.be.equal 'MyNewSub1'
          myCodec = Codec('new')
          myCodec.displayName('')
          result = myCodec.displayName()
          expect(result).to.be.equal 'new'

    describe "the aOptions could be non-object", ->
      MyNCodec = createCtor "MyNCodec"
      initSize = Math.random()
      before ->
        register MyNCodec, initSize
      after ->
        unregister MyNCodec
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
    describe "the fnGet option", ->
      it "should replace get directly", ->
        getInst = null
        class Fact
          getInst = sinon.spy (aName, aOptions)->
          factory Fact
          Fact.get = getInst
          constructor: -> return super
        MyInstCodec = createCtor "MyInstCodec"
        Fact.register MyInstCodec
        mycodec = Fact("MyInst", test:123)
        getInst.should.have.been.calledOnce
        getInst.should.have.been.calledWith("MyInst", test:123)
        Fact.get.should.be.equal getInst
      it "should replace get via fnGet option", ->
        getInst = null
        getInstThis = null
        class Fact
          getInst = sinon.spy (aName, aOptions)->
            getInstThis = this
          factory Fact, fnGet: getInst
          constructor: -> return super
        MyInstCodec = createCtor "MyInstCodec"
        Fact.register MyInstCodec
        mycodec = Fact("MyInst", test:123)
        getInst.should.have.been.calledOnce
        getInst.should.have.been.calledWith("MyInst", test:123)
        getInstThis.should.have.ownProperty 'super'
        getInstThis.super.should.not.be.equal Fact.get
        getInstThis.super.should.be.equal Fact._get

