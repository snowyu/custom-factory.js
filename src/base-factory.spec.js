import 'jest-extended'
import { BaseFactory } from './base-factory'

class Codec extends BaseFactory {
  static _aliases = {}
  // static Factory = Codec

  initialize(aOptions) {
    if (typeof aOptions === 'number'){
      this.bufferSize = aOptions
    } else if (aOptions && aOptions.bufferSize) {
      this.bufferSize = aOptions.bufferSize
    }
  }
}

function testItemExists(cls, expectedClass) {
  expect(cls).toBeDefined() // "testItemExists:" + expectedClass.name
  expect(cls).toStrictEqual(expectedClass)
  // obj.should.be.equal expectedClass
}

describe('BaseFactory', () => {
  const register  = Codec.register.bind(Codec)
  const aliases   = Codec.setAliases.bind(Codec)
  const unregister= Codec.unregister.bind(Codec)

  class MyNewCodec {}
  expect(register(MyNewCodec)).toBeTruthy()
  aliases(MyNewCodec, 'new', 'new2')

  class MyBufferCodec {}
  expect(register(MyBufferCodec)).toBeTruthy()


  describe('static members', () => {
    describe('.forEach registered classes', () => {
      test('should get all registered items', () => {
        let myCodec = Codec['MyNew']
        expect(myCodec).toStrictEqual(MyNewCodec)
        myCodec = Codec.get('MyBuffer')
        expect(myCodec).toStrictEqual(MyBufferCodec)
        // Codec.forEach()
      });

      test('should get all registered items via forEach', () => {
        let result = {}
        Codec.forEach((item, name) => result[name] = item)
        expect(Object.keys(result)).toHaveLength(2)
        expect(result.MyNew).toStrictEqual(MyNewCodec)
        expect(result.MyBuffer).toStrictEqual(MyBufferCodec)
      });
    });

    describe('.get', () => {
      test('should get registered item via alias', () => {
        expect(Codec.get('new')).toStrictEqual(MyNewCodec)
        expect(Codec.get('new2')).toStrictEqual(MyNewCodec)
        let aliases = Codec.getAliases()
        expect(aliases).toEqual(['new', 'new2'])
        aliases = MyNewCodec.getAliases()
        expect(aliases).toEqual(['new', 'new2'])
        aliases = MyBufferCodec.getAliases()
        expect(aliases).toEqual([])
      });

      test('should return undefined for unknown codec name', () => {
        expect(Codec.get('unknown')).not.toBeDefined()
        expect(Codec.get()).not.toBeDefined()
      });

    });

    describe('.displayName', () => {
      test('should getDisplayName', () => {
        class MyDisplayCodec {}
        expect(register(MyDisplayCodec, {displayName: 'my display'})).toBeTruthy()
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('my display')
        expect(MyDisplayCodec.getDisplayName()).toStrictEqual('my display')
      });
      test('should setDisplayName', () => {
        class MyDisplayCodec {}
        expect(register(MyDisplayCodec, {displayName: 'my display'})).toBeTruthy()
        Codec.setDisplayName('MyDisplay', 'ChangeIt')
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('ChangeIt')
        expect(MyDisplayCodec.getDisplayName()).toStrictEqual('ChangeIt')
        MyDisplayCodec.setDisplayName('ChangeIt2')
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('ChangeIt2')
        expect(MyDisplayCodec.getDisplayName()).toStrictEqual('ChangeIt2')
      });

    })

    describe('.alias', () => {
      test('should throw error if the alias already exists', () => {
        expect(MyBufferCodec.setAliases.bind(MyBufferCodec, null, 'new')).toThrow('already exists')
        expect(MyBufferCodec.setAlias.bind(MyBufferCodec, null, 'new')).toThrow('already exists')
      });

      test('should get/set alias via property aliases', () => {
        class MyAliasCodec {}
        expect(register(MyAliasCodec)).toBeTruthy()
        MyAliasCodec.setAliases(null, 'a')
        MyAliasCodec.setAlias(null, 'a2')
        expect(Codec.registeredClass('a')).toStrictEqual(MyAliasCodec)
        expect(Codec.registeredClass('a2')).toStrictEqual(MyAliasCodec)

        let aliases = MyAliasCodec.aliases
        expect(aliases).toEqual(['a', 'a2'])
        MyAliasCodec.aliases = 'new3'
        expect(MyAliasCodec.aliases).toEqual(['new3'])
        expect(Codec.registeredClass('a')).toBeFalsy()
        expect(Codec.registeredClass('a2')).toBeFalsy()
        aliases = MyAliasCodec.aliases
        expect(aliases).toEqual(['new3'])
        expect(Codec.registeredClass('new3')).toStrictEqual(MyAliasCodec)
        MyAliasCodec.aliases = ['new5', 'new6']
        aliases = MyAliasCodec.aliases
        expect(aliases).toEqual(['new5', 'new6'])
        expect(Codec.registeredClass('new5')).toStrictEqual(MyAliasCodec)
        expect(Codec.registeredClass('new6')).toStrictEqual(MyAliasCodec)
        expect(Codec.registeredClass('new3')).toBeFalsy()
        expect(MyAliasCodec.unregister()).toBeTrue()
        expect(Codec.registeredClass('new6')).toBeFalsy()
      });

      test('should removeAlias', () => {
        class MyAliasCodec {}
        expect(register(MyAliasCodec)).toBeTruthy()
        MyAliasCodec.setAliases(null, 'a', 'a1', 'a2', 'a3')
        expect(MyAliasCodec.aliases).toEqual(['a', 'a1', 'a2', 'a3'])
        MyAliasCodec.removeAlias('a1', 'a3')
        expect(MyAliasCodec.aliases).toEqual(['a', 'a2'])
        expect(MyAliasCodec.unregister()).toBeTrue()
      });

    });

    describe('.register', () => {
      test('should register a new Codec Class with specified name via options object', () => {
        class MyCodec {}
        expect(register(MyCodec, {name: 'my1'})).toBeTruthy()
        expect(Codec.my1).toStrictEqual(MyCodec)
      });

      test('should register a new Codec Class with specified name', () => {
        class MyCodec {}
        expect(register(MyCodec, 'my1')).toBeTruthy()
        expect(Codec.my1).toStrictEqual(MyCodec)
      });

      test('should register a new Codec Class with specified display name', () => {
        const vDisplayName = 'this is a display name'
        class MyCodec {}
        expect(register(MyCodec, {name: 'my1', displayName: vDisplayName})).toBeTruthy()
        expect(Codec.my1).toStrictEqual(MyCodec)
        expect(Codec.my1.prototype._displayName).toStrictEqual(vDisplayName)
      });

      test('should throw error if register Class duplicity', () => {
        class MyCodec {}
        expect(register(MyCodec, {name: 'my1'})).toBeTruthy()
        expect(register.bind(Codec, MyCodec, {name: 'my1'})).toThrow('has already been registered')
      });

    });

    describe('.unregister', () => {
      test('should unregister via class from factory', () => {
        class MyUnCodec {}
        expect(register(MyUnCodec)).toBeTruthy()
        expect(Codec.registeredClass('MyUn')).toStrictEqual(MyUnCodec)
        expect(MyUnCodec.registeredClass()).toStrictEqual(MyUnCodec)
        expect(Codec['MyUn']).toStrictEqual(MyUnCodec)
        MyUnCodec.aliases = ['un', 'un2']
        expect(MyUnCodec.aliases).toEqual(['un', 'un2'])
        expect(Codec.aliases).toEqual(['new', 'new2', 'un', 'un2'])
        expect(unregister(MyUnCodec)).toBeTrue()
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
        expect(Codec.aliases).toEqual(['new', 'new2'])

        expect(register(MyUnCodec)).toBeTruthy()
        expect(MyUnCodec.unregister()).toBeTrue()
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
      });

      test('should unregister via name from factory', () => {
        class MyUnCodec {}
        expect(register(MyUnCodec)).toBeTruthy()

        expect(unregister('MyUn')).toBeTrue()
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
      });


      test('should unregister via alias from factory', () => {
        class MyUnCodec {}
        expect(register(MyUnCodec)).toBeTruthy()
        MyUnCodec.aliases = ['un', 'un2']

        expect(unregister('un2')).toBeTrue()
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
      });
    });
    describe('.createObject', () => {
      test('should create object via name', () => {
        let result = Codec.createObject('new', 32)
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(result).toHaveProperty('bufferSize', 32)
        expect(result.toString()).toStrictEqual('MyNew')
      });

      test('should create object', () => {
        let result = MyNewCodec.createObject({bufferSize: 32})
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(result).toHaveProperty('bufferSize', 32)
        result = MyNewCodec.createObject(33)
        expect(result).toHaveProperty('bufferSize', 33)
      });

      test('should re-init object', () => {
        let result = Codec.createObject('new', 32)
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(result).toHaveProperty('bufferSize', 32)
        Codec.createObject(result, 132)
        expect(result).toHaveProperty('bufferSize', 132)
      });

    });
  });

});
