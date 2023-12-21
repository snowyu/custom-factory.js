import {createAbilityInjector} from 'custom-ability'
import {cloneCtor, clonePrototype, defineProperty} from 'inherits-ex'

import {BaseFactory} from './base-factory.js'
import {CustomFactory} from './custom-factory.js'
import {BaseFactoryCoreMethods} from './base-factory-ability.js'


export const CustomFactoryCoreMethods = [...BaseFactoryCoreMethods, '@getClassNameList', '@_registerWithParent']


function getFactoryClass(targetClass, options) {
  class Factory {
    /* istanbul ignore next */
    constructor() {
      this.initialize.apply(this, arguments)
    }
  }

  cloneCtor(Factory, BaseFactory)
  cloneCtor(Factory, CustomFactory)

  delete Factory['_findRootFactory']
  delete Factory['findRootFactory']
  Factory['_children'] = undefined
  Factory['_aliases']  = undefined

  defineProperty(Factory, '_Factory', targetClass)
  return Factory
}

export const addFactoryAbility = createAbilityInjector(getFactoryClass, CustomFactoryCoreMethods, true)

export default addFactoryAbility
