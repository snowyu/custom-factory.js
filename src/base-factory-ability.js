import {cloneCtor, clonePrototype, defineProperty} from 'inherits-ex'
import {createAbilityInjector} from 'custom-ability'

import {BaseFactory} from './base-factory.js'


export const coreMethods = ['@register', '@_register', '@Factory', '@formatName', '@formatNameFromClass']

function getFactoryClass(targetClass, options) {
  class Factory {
    /* istanbul ignore next */
    constructor() {
      this.initialize.apply(this, arguments)
    }
  }

  cloneCtor(Factory, BaseFactory)

  delete Factory['_findRootFactory']
  delete Factory['findRootFactory']

  defineProperty(Factory, '_Factory', targetClass)
  return Factory
}



export const addBaseFactoryAbility = createAbilityInjector(getFactoryClass, coreMethods, true)

export default addBaseFactoryAbility


