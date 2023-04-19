import 'jest-extended'

import {addBaseFactoryAbility} from './base-factory-ability.js'
import {addFactoryAbility} from './custom-factory-ability.js'
import {addObjectInstanceForFactoryAbility} from './object-factory-ability.js'

describe('ObjectInstance For Factory Ability', () => {
  describe('BaseFactoryAbility', () => {
    class Codec {
      constructor() {
        this.initialize.apply(this, arguments)
      }
      initialize(aOptions) {
        if (typeof aOptions === 'number') {
          this.bufferSize = aOptions
        } else if (aOptions && aOptions.bufferSize) {
          this.bufferSize = aOptions.bufferSize
        }
      }
    }
    addBaseFactoryAbility(Codec)
    addObjectInstanceForFactoryAbility(Codec)
    it('should addObjectInstanceForFactoryAbility', () => {
      expect(Codec).toHaveProperty('register')
      expect(Codec).toHaveProperty('setAliases')
      expect(Codec).toHaveProperty('unregister')
      expect(Codec).toHaveProperty('Factory', Codec)
      expect(Codec).toHaveProperty('_getInstance')
      expect(Codec).toHaveProperty('getInstance')
      expect(Codec).toHaveProperty('registeredObjects')
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

      it('should get singleton object instance', () => {
        let result = Codec.getInstance('new')
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(Codec.getInstance('new')).toBe(result)
        expect(Codec.getInstance('new', {})).toBe(result)
        expect(Codec.getInstance('new', false)).toBe(result)
        expect(Codec.getInstance('new', null)).toBe(result)
        let r = Codec.getInstance('MyBuffer')
        expect(r).toBeInstanceOf(MyBufferCodec)
        expect(r).not.toBe(result)
        expect(Codec.getInstance('notExists', null)).toBeUndefined()
      });
      it('should get a new object instance', () => {
        let result = Codec.getInstance('new')
        expect(result).toBeInstanceOf(MyNewCodec)
        let r = Codec.getInstance('new', true)
        expect(r).toBeInstanceOf(MyNewCodec)
        expect(r !== result).toBeTruthy()
        let r2 = Codec.getInstance('new', {a:1})
        expect(r2).toBeInstanceOf(MyNewCodec)
        expect(r2 !== result).toBeTruthy()
        expect(r2 !== r).toBeTruthy()
      });
    });
  });

  describe('CustomFactoryAbility', () => {
    class Codec {
      constructor() {
        this.initialize.apply(this, arguments)
      }
      initialize(aOptions) {
        if (typeof aOptions === 'number') {
          this.bufferSize = aOptions
        } else if (aOptions && aOptions.bufferSize) {
          this.bufferSize = aOptions.bufferSize
        }
      }
    }
    addFactoryAbility(Codec)
    addObjectInstanceForFactoryAbility(Codec)
    it('should addObjectInstanceForFactoryAbility', () => {
      expect(Codec).toHaveProperty('register')
      expect(Codec).toHaveProperty('setAliases')
      expect(Codec).toHaveProperty('unregister')
      expect(Codec).toHaveProperty('Factory', Codec)
      expect(Codec).toHaveProperty('_getInstance')
      expect(Codec).toHaveProperty('getInstance')
      expect(Codec).toHaveProperty('registeredObjects')
    });

    describe('CustomFactory', () => {
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

      it('should get singleton object instance', () => {
        let result = Codec.getInstance('new')
        expect(result).toBeInstanceOf(MyNewCodec)
        expect(Codec.getInstance('new')).toBe(result)
        expect(Codec.getInstance('new', {})).toBe(result)
        expect(Codec.getInstance('new', false)).toBe(result)
        expect(Codec.getInstance('new2', null)).toBe(result)
        let r = Codec.getInstance('MyBuffer')
        expect(r).toBeInstanceOf(MyBufferCodec)
        expect(r).not.toBe(result)
        expect(Codec.getInstance('notExists', null)).toBeUndefined()
      });
      it('should get a new object instance', () => {
        let result = Codec.getInstance('new')
        expect(result).toBeInstanceOf(MyNewCodec)
        let r = Codec.getInstance('new', true)
        expect(r).toBeInstanceOf(MyNewCodec)
        expect(r !== result).toBeTruthy()
        let r2 = Codec.getInstance('new', {a:1})
        expect(r2).toBeInstanceOf(MyNewCodec)
        expect(r2 !== result).toBeTruthy()
        expect(r2 !== r).toBeTruthy()
      });
    });
  });
});
