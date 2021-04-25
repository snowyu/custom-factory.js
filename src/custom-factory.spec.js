import 'jest-extended'
// const getPrototypeOf = require('inherits-ex/lib/getPrototypeOf')
const createCtor = require('inherits-ex/lib/createCtor')

import { CustomFactory } from './custom-factory'
import { getParentClass } from './base-factory'

class Codec extends CustomFactory {
  static _aliases = {}
  // static Factory = Codec
  // static ROOT_NAME = 'Codec'

  initialize(aOptions) {
    if ('number' === typeof aOptions) this.bufferSize = aOptions
    else if (aOptions) this.bufferSize = aOptions.bufSize
    else this.bufferSize = 1111
  }
}

describe('CustomFactory', () => {
  const register = Codec.register.bind(Codec)
  const aliases = Codec.setAliases.bind(Codec)
  const unregister = Codec.unregister.bind(Codec)

  class MyNewCodec {
    constructor() {
      const Parent = getParentClass(this.Class)
      return Reflect.construct(Parent, arguments, this.Class)
    }
  }
  expect(register(MyNewCodec)).toBeTruthy()
  aliases(MyNewCodec, 'new', 'new2')

  class MyBufferCodec {
    constructor() {
      const Parent = getParentClass(this.Class)
      return Reflect.construct(Parent, arguments, this.Class)
    }
  }
  expect(register(MyBufferCodec, { displayName: 'my buffer' })).toBeTruthy()

  class SubMyNewCodec {}
  expect(register(SubMyNewCodec, MyNewCodec)).toBeTruthy()
  aliases(SubMyNewCodec, 'newSub', 'sub')
  class A1SubMyNewCodec {}
  expect(register(A1SubMyNewCodec, SubMyNewCodec)).toBeTruthy()

  describe('static members', () => {
    describe('helper functions', () => {
      it('should getNameFrom with name string', () => {
        expect(Codec.getNameFrom('hello')).toStrictEqual('hello')
      })
      it('should get path array for path string', () => {
        class A {}
        A.prototype.name = '/Hello/hi/Good/'
        expect(Codec.pathArray(A)).toEqual(['Hello', 'hi', 'Good'])
        expect(Codec.pathArray(SubMyNewCodec, 'Root')).toEqual([
          'Root',
          'MyNew',
          'SubMyNew',
        ])
        A.formatName = (name) => name.toLowerCase()
        expect(Codec.pathArray.call(A)).toEqual(['hello', 'hi', 'good'])
        expect(register(A)).toBeTruthy()
        try {
          expect(A.pathArray()).toEqual(['codec', 'a'])
          expect(A.pathArray()).toEqual(['codec', 'a'])
          expect(A.pathArray('Root')).toEqual(['root', 'a'])
        } finally {
          expect(unregister(A)).toBeTruthy()
        }
      })
      it('should formatNameFromClass with name string', () => {
        class X1SubMyNewCodec {}
        expect(register(X1SubMyNewCodec, SubMyNewCodec)).toBeTruthy()
        try {
          expect(
            Codec.formatNameFromClass(X1SubMyNewCodec, SubMyNewCodec, 0)
          ).toStrictEqual('X1SubMyNewCodec')
          expect(
            Codec.formatNameFromClass(X1SubMyNewCodec, SubMyNewCodec)
          ).toStrictEqual('X1SubMyNew')
          expect(
            Codec.formatNameFromClass(X1SubMyNewCodec, SubMyNewCodec, 1)
          ).toStrictEqual('X1SubMyNew')
          expect(
            Codec.formatNameFromClass(X1SubMyNewCodec, SubMyNewCodec, 2)
          ).toStrictEqual('X1Sub')
        } finally {
          expect(unregister(X1SubMyNewCodec)).toBeTruthy()
        }
      })

      it('should getClassList', () => {
        expect(Codec.getClassList(SubMyNewCodec)).toEqual([
          SubMyNewCodec,
          MyNewCodec,
        ])
      })
    })

    describe('.forEach registered classes', () => {
      const MyNewBufferCodec = createCtor('MyNewBuffer')
      beforeAll(() => {
        MyNewCodec.register(MyNewBufferCodec)
      })
      afterAll(() => {
        MyNewCodec.unregister(MyNewBufferCodec)
      })
      test('should get all registered items', () => {
        let myCodec = Codec.get('MyNew')
        expect(myCodec).toStrictEqual(MyNewCodec)
        myCodec = Codec.get('MyBuffer')
        expect(myCodec).toStrictEqual(MyBufferCodec)
        // Codec.forEach()
      })

      test('should get all registered items via forEach', () => {
        let result = []
        Codec.forEach((v, k) => result.push({ name: k, path: v.path() }))
        expect(result).toEqual([
          { name: 'MyNew', path: '/Codec/MyNew' },
          { name: 'MyBuffer', path: '/Codec/MyBuffer' },
          { name: 'SubMyNew', path: '/Codec/MyNew/SubMyNew' },
          { name: 'A1SubMyNew', path: '/Codec/MyNew/SubMyNew/A1SubMyNew' },
          { name: 'MyNewBuffer', path: '/Codec/MyNew/MyNewBuffer' },
        ])
      })

      test('should break forEach loop', () => {
        let result = {}
        Codec.forEach((item, name) => {
          result[name] = item
          if (name === 'SubMyNew') return 'brk' // break
        })
        expect(result).toEqual({
          MyNew: MyNewCodec,
          MyBuffer: MyBufferCodec,
          SubMyNew: SubMyNewCodec,
        })
      })
    })
  })

  describe('.get', () => {
    test('should get registered item', () => {
      expect(Codec.get('MyBuffer')).toStrictEqual(MyBufferCodec)
      expect(MyNewCodec.get('MyBuffer')).toBeUndefined()
      expect(MyNewCodec.get('SubMyNew')).toStrictEqual(SubMyNewCodec)
    })

    test('should get registered item via alias', () => {
      expect(Codec.get('new')).toStrictEqual(MyNewCodec)
      expect(Codec.get('new2')).toStrictEqual(MyNewCodec)
      let aliases = Codec.getAliases()
      expect(aliases).toEqual(['new', 'new2', 'newSub', 'sub'])
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

  describe('.alias', () => {
    test('should throw error if the alias already exists', () => {
      expect(MyBufferCodec.setAliases.bind(MyBufferCodec, null, 'new')).toThrow(
        'already exists'
      )
      expect(MyBufferCodec.setAlias.bind(MyBufferCodec, null, 'new')).toThrow(
        'already exists'
      )
    })

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
    })
  })

  describe('.register', () => {
    test('should register a new Codec Class with specified name via options object', () => {
      class MyCodec {}
      expect(register(MyCodec, { name: 'my1' })).toBeTruthy()
      try {
        expect(Codec.get('my1')).toStrictEqual(MyCodec)
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

    test('should register a new Codec Class with specified display name', () => {
      const vDisplayName = 'this is a display name'
      class MyCodec {}
      expect(
        register(MyCodec, { name: 'my1', displayName: vDisplayName })
      ).toBeTruthy()
      try {
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

    test('should throw error if parent Class is not factory', () => {
      class MyCodec {}
      class MyIllegalParentCodec {}
      expect(
        register.bind(Codec, MyCodec, MyIllegalParentCodec, { name: 'my1' })
      ).toThrow('he parent class is illegal')
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
      expect(Codec.aliases).toEqual([
        'new',
        'new2',
        'newSub',
        'sub',
        'un',
        'un2',
      ])
      expect(unregister(MyUnCodec)).toBeTrue()
      expect(Codec.registeredClass('MyUn')).toBeFalsy()
      expect(Codec.aliases).toEqual(['new', 'new2', 'newSub', 'sub'])

      expect(register(MyUnCodec)).toBeTruthy()
      expect(MyUnCodec.unregister()).toBeTrue()
      expect(Codec.registeredClass('MyUn')).toBeFalsy()
    })

    test('should unregister via name from factory', () => {
      class MyUnCodec {}
      expect(register(MyUnCodec)).toBeTruthy()

      expect(unregister('MyUn')).toBeTrue()
      expect(Codec.registeredClass('MyUn')).toBeFalsy()
    })

    test('should unregister via alias from factory', () => {
      class MyUnCodec {}
      expect(register(MyUnCodec)).toBeTruthy()
      MyUnCodec.aliases = ['un', 'un2']

      expect(unregister('un2')).toBeTrue()
      expect(Codec.registeredClass('MyUn')).toBeFalsy()
    })
  })
  describe('.createObject', () => {
    test('should create object via name', () => {
      let result = Codec.createObject('new', 32)
      expect(result).toBeInstanceOf(MyNewCodec)
      expect(result).toHaveProperty('bufferSize', 32)
      expect(result.toString()).toStrictEqual('MyNew')
    })
  })
})
