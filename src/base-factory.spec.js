import 'jest-extended'
import { BaseFactory, isPureObject } from './base-factory'
import { isInheritedFrom } from 'inherits-ex';

class Codec extends BaseFactory {
  // static _aliases = {}
  // static Factory = Codec

  initialize(aOptions) {
    if (typeof aOptions === 'number') {
      this.bufferSize = aOptions
    } else if (aOptions && aOptions.bufferSize) {
      this.bufferSize = aOptions.bufferSize
    }
  }
}

describe('util functions', () => {
  it('should isPureObject', () => {
    expect(isPureObject()).toBeFalsy()
    expect(isPureObject(12)).toBeFalsy()
    expect(isPureObject("")).toBeFalsy()
    expect(isPureObject(class A{})).toBeFalsy()
    expect(isPureObject({})).toBe(true)
  });
});

describe('BaseFactory', () => {
  const register = Codec.register.bind(Codec)
  const aliases = Codec.setAliases.bind(Codec)
  const unregister = Codec.unregister.bind(Codec)

  class MyNewCodec {}
  expect(register(MyNewCodec)).toBeTruthy()
  aliases(MyNewCodec, 'new', 'new2')

  class MyBufferCodec {
    initialize(aOptions) {
      if (typeof aOptions === 'number') {
        this.myBufferSize = aOptions
      } else if (aOptions && aOptions.bufferSize) {
        this.myBufferSize = aOptions.bufferSize
      }
      super.initialize(aOptions)
    }
  }
  expect(register(MyBufferCodec)).toBeTruthy()

  describe('static members', () => {
    describe('helper functions', () => {
      it('should getNameFrom with name string', () => {
        expect(Codec.getNameFrom('hello')).toStrictEqual('hello')
      })

      it('should formatNameFromClass with name string', () => {
        class MyNameCodec {}
        class MyNameCodec1 {}
        expect(register(MyNameCodec)).toBeTruthy()
        try {
          expect(Codec.formatNameFromClass(MyNameCodec, 0)).toStrictEqual(
            'MyNameCodec'
          )
          expect(Codec.formatNameFromClass(MyNameCodec)).toStrictEqual('MyName')
          expect(Codec.formatNameFromClass(MyNameCodec1)).toStrictEqual(
            'MyNameCodec1'
          )
        } finally {
          expect(unregister(MyNameCodec)).toBeTruthy()
        }
      })
    })

    describe('.forEach registered classes', () => {
      test('should get all registered items', () => {
        let myCodec = Codec._children['MyNew']
        expect(myCodec).toStrictEqual(MyNewCodec)
        myCodec = Codec.get('MyBuffer')
        expect(myCodec).toStrictEqual(MyBufferCodec)
        // Codec.forEach()
      })

      test('should get all registered items via forEach', () => {
        let result = {}
        expect(
          Codec.forEach((item, name) => (result[name] = item))
        ).toStrictEqual(Codec)
        expect(Object.keys(result)).toHaveLength(2)
        expect(result.MyNew).toStrictEqual(MyNewCodec)
        expect(result.MyBuffer).toStrictEqual(MyBufferCodec)
        expect(Codec.forEach()).toStrictEqual(Codec)
      })

      test('should get registered items before break via forEach', () => {
        let result = {}
        expect(
          Codec.forEach((item, name) => {result[name] = item;return 'brk'})
        ).toStrictEqual(Codec)
        expect(Object.keys(result)).toHaveLength(1)
        expect(result.MyNew).toStrictEqual(MyNewCodec)
      })
    })

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
      })

      test('should return undefined for unknown codec name', () => {
        expect(Codec.get('unknown')).not.toBeDefined()
        expect(Codec.get()).not.toBeDefined()
      })
    })

    describe('.displayName', () => {
      test('should getDisplayName', () => {
        class MyDisplayCodec {}

        expect(Codec.getDisplayName('MyNew')).toStrictEqual('new')
        expect(Codec.getDisplayName('MyBuffer')).toStrictEqual('MyBuffer')

        expect(
          register(MyDisplayCodec, { displayName: 'my display' })
        ).toBeTruthy()
        try {
          expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('my display')
          expect(Codec.getDisplayName(MyDisplayCodec)).toStrictEqual(
            'my display'
          )
          expect(MyDisplayCodec.getDisplayName()).toStrictEqual('my display')
        } finally {
          expect(MyDisplayCodec.unregister()).toBe(true)
        }
      })
      test('should setDisplayName', () => {
        class MyDisplayCodec {}
        expect(
          register(MyDisplayCodec, { displayName: 'my display' })
        ).toBeTruthy()
        Codec.setDisplayName('MyDisplay', 'ChangeIt')
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('ChangeIt')
        expect(MyDisplayCodec.getDisplayName()).toStrictEqual('ChangeIt')
        MyDisplayCodec.setDisplayName('ChangeIt2')
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('ChangeIt2')
        expect(MyDisplayCodec.getDisplayName()).toStrictEqual('ChangeIt2')
        Codec.setDisplayName(MyDisplayCodec, 'ChangeIt3')
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('ChangeIt3')
        // set displayName only for string
        Codec.setDisplayName(MyDisplayCodec, 123)
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('ChangeIt3')
        Codec.setDisplayName(MyDisplayCodec, { displayName: 'ChangeIt5' })
        expect(Codec.getDisplayName('MyDisplay')).toStrictEqual('ChangeIt5')

        expect(MyDisplayCodec.unregister()).toBe(true)
      })
    })

    describe('.alias', () => {
      test('should throw error if the alias already exists', () => {
        expect(
          MyBufferCodec.setAliases.bind(MyBufferCodec, null, 'new')
        ).toThrow('already exists')
        expect(MyBufferCodec.setAlias.bind(MyBufferCodec, null, 'new')).toThrow(
          'already exists'
        )
      })
      test('should get/set alias via Codec', () => {
        class MyAliasCodec {}
        expect(register(MyAliasCodec)).toBeTruthy()
        try {
          Codec.setAliases(MyAliasCodec, 'a', 'a1')
          Codec.setAliases(MyAliasCodec)
          expect(Codec.getAliases('MyAlias')).toEqual(['a', 'a1'])
          Codec.setAlias('MyAlias', 'a2')
          expect(Codec.getAliases(MyAliasCodec)).toEqual(['a', 'a1', 'a2'])
        } finally {
          expect(MyAliasCodec.unregister()).toBe(true)
        }
      })

      test('should get/set alias via itself', () => {
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
        expect(MyAliasCodec.unregister()).toBe(true)
        expect(Codec.registeredClass('new6')).toBeFalsy()
        expect(Codec.registeredClass()).toBe(true)
      })

      test('should removeAlias', () => {
        class MyAliasCodec {}
        expect(register(MyAliasCodec)).toBeTruthy()
        MyAliasCodec.setAliases(null, 'a', 'a1', 'a2', 'a3')
        expect(MyAliasCodec.aliases).toEqual(['a', 'a1', 'a2', 'a3'])
        MyAliasCodec.removeAlias('a1', 'a3')
        expect(MyAliasCodec.aliases).toEqual(['a', 'a2'])
        expect(MyAliasCodec.unregister()).toBe(true)
      })
    })

    describe('.register', () => {
      test('should register a new Codec Class with specified name via options object', () => {
        class MyCodec {}
        expect(
          register(MyCodec, { name: 'my1', aliases: ['my1_2', 'My1'] })
        ).toBeTruthy()
        try {
          expect(Codec.get('my1')).toStrictEqual(MyCodec)
          expect(Codec.get('my1_2')).toStrictEqual(MyCodec)
          expect(Codec.get('My1')).toStrictEqual(MyCodec)
        } finally {
          expect(unregister(MyCodec)).toBeTruthy()
        }
      })

      test('should register a new Codec Class with specified name', () => {
        class MyCodec {}
        expect(register(MyCodec, 'my1')).toBeTruthy()
        try {
          expect(Codec.get('my1')).toStrictEqual(MyCodec)
        } finally {
          expect(unregister(MyCodec)).toBeTruthy()
        }
      })

      test('should register a new Codec Class with specified baseNameOnly', () => {
        class MyCodec {}
        expect(
          register(MyCodec, { baseNameOnly: 0, alias: 'My1' })
        ).toBeTruthy()
        try {
          expect(Codec.get('MyCodec')).toStrictEqual(MyCodec)
          expect(Codec.get('My1')).toStrictEqual(MyCodec)
        } finally {
          expect(unregister(MyCodec)).toBeTruthy()
        }
      })

      test('should register a new Codec Class with specified display name', () => {
        const vDisplayName = 'this is a display name'
        class MyCodec {}
        try {
          expect(
            register(MyCodec, { name: 'my1', displayName: vDisplayName })
          ).toBeTruthy()
          expect(Codec.get('my1')).toStrictEqual(MyCodec)
          expect(Codec.get('my1').prototype._displayName).toStrictEqual(
            vDisplayName
          )
        } finally {
          expect(unregister(MyCodec)).toBeTruthy()
        }
      })

      test('should throw error if register Class duplicity', () => {
        class MyCodec {}
        expect(register(MyCodec, { name: 'my1' })).toBeTruthy()
        try {
          expect(register.bind(Codec, MyCodec, { name: 'my1' })).toThrow(
            'has already been registered'
          )
        } finally {
          expect(unregister(MyCodec)).toBeTruthy()
        }
      })

      test('should register a new Codec Class already extends Codec', () => {
        class MyCodec extends Codec {}
        expect(register(MyCodec, { name: 'my1' })).toBeTruthy()
        try {
          expect(Codec.get('my1')).toStrictEqual(MyCodec)
        } finally {
          expect(unregister(MyCodec)).toBeTruthy()
          expect(Codec.get('my1')).toBeUndefined()
        }
      })
      test('should register a new product item Class', () => {
        class MyPCodec {}
        expect(
          register(MyPCodec, { isFactory: false })
        ).toBeTruthy()
        try {
          expect(Codec.get('MyP')).toStrictEqual(MyPCodec)
          expect(isInheritedFrom(MyPCodec, Codec)).toBe(false)
        } finally {
          expect(unregister(MyPCodec)).toBeTruthy()
        }
      })
      test('should not register a new factory item Class if no autoInherits', () => {
        class MyPCodec {}
        expect( () =>
          register(MyPCodec, { autoInherits: false })
        ).toThrow(`the factory item "MyP" is not inherited from "Codec"`)
      })
      test('should register a new another factory item Class with autoInherits', () => {
        class MyPCodec {}
        class CcCodec {}
        expect(
          register(MyPCodec, { isFactory: CcCodec })
        ).toBeTruthy()
        try {
          expect(Codec.get('MyP')).toStrictEqual(MyPCodec)
          expect(isInheritedFrom(MyPCodec, Codec)).toBe(false)
          expect(isInheritedFrom(MyPCodec, CcCodec)).toBeTruthy()
        } finally {
          expect(unregister(MyPCodec)).toBeTruthy()
        }
      })

    })

    describe('.unregister', () => {
      test('should unregister via class from factory', () => {
        class MyUnCodec {}
        expect(register(MyUnCodec)).toBeTruthy()
        expect(Codec.registeredClass('MyUn')).toStrictEqual(MyUnCodec)
        expect(MyUnCodec.registeredClass()).toStrictEqual(MyUnCodec)
        expect(Codec.get('MyUn')).toStrictEqual(MyUnCodec)
        MyUnCodec.aliases = ['un', 'un2']
        expect(MyUnCodec.aliases).toEqual(['un', 'un2'])
        expect(Codec.aliases).toEqual(['new', 'new2', 'un', 'un2'])
        expect(unregister(MyUnCodec)).toBe(true)
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
        expect(Codec.aliases).toEqual(['new', 'new2'])

        expect(register(MyUnCodec)).toBeTruthy()
        expect(MyUnCodec.unregister()).toBe(true)
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
        expect(unregister('unknown')).toBeFalsy()
      })

      test('should unregister via name from factory', () => {
        class MyUnCodec {}
        expect(register(MyUnCodec)).toBeTruthy()

        expect(unregister('MyUn')).toBe(true)
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
      })

      test('should unregister via alias from factory', () => {
        class MyUnCodec {}
        expect(register(MyUnCodec)).toBeTruthy()
        MyUnCodec.aliases = ['un', 'un2']

        expect(unregister('un2')).toBe(true)
        expect(Codec.registeredClass('MyUn')).toBeFalsy()
      })
    })
    describe('.createObject', () => {
      test('should create MyBufferCodec object via name', () => {
        let result = Codec.createObject('MyBuffer', 32)
        expect(result).toBeInstanceOf(MyBufferCodec)
        expect(result).toBeInstanceOf(Codec)
        expect(result).toHaveProperty('myBufferSize', 32)
        // expect(result.toString()).toStrictEqual('MyNew')
        result = Codec.createObject('unknown', 32)
        expect(result).toBeUndefined()
      })

      test('should create object via name', () => {
        let result = Codec.createObject('new', 32)
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(result).toBeInstanceOf(Codec)
        expect(result).toHaveProperty('bufferSize', 32)
        // expect(result.toString()).toStrictEqual('MyNew')
        result = Codec.createObject('unknown', 32)
        expect(result).toBeUndefined()
      })

      test('should create object', () => {
        let result = MyNewCodec.createObject({ bufferSize: 32 })
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(result).toHaveProperty('bufferSize', 32)
        result = MyNewCodec.createObject(33)
        expect(result).toHaveProperty('bufferSize', 33)
        result = MyNewCodec.createObject()
        expect(result).not.toHaveProperty('bufferSize')
      })

      test('should re-init object', () => {
        let result = Codec.createObject('new', 32)
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(result).toHaveProperty('bufferSize', 32)
        let result2 = Codec.createObject(result, 132)
        expect(result2).toStrictEqual(result)
        expect(result).toHaveProperty('bufferSize', 132)
        result2 = Codec.createObject(result)
        expect(result2).toStrictEqual(result)
      })
    })
  })
})
