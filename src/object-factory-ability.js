import {createAbilityInjector} from 'custom-ability'

const getOwnPropertyNames = Object.getOwnPropertyNames

function isEmptyObject(obj) {
  return getOwnPropertyNames(obj).length === 0
}

class ObjectFactory {
  static registeredObjects = undefined

  static _getInstance(aName) {
    if (!this.registeredObjects) {return}
    let result = this.registeredObjects[aName]
    return result
  }

  /**
   * Get a singleton object instance or a new one depends on the aOptions.
   *
   * @param {string} aName
   * @param {boolean|any} [aOptions] return the singleton object instance if the aOptions is false or empty options, otherwise create a new object instance
   * @returns {*|undefined}
   */
  static getInstance(aName, aOptions) {
    aName = this.getRealName(aName)
    if (!aName) {return}

    let result
    if (!aOptions || (typeof aOptions === 'object' && isEmptyObject(aOptions))) {
      result = this._getInstance(aName)
      if (result === undefined) {
        result = this.createObject(aName)
        /* istanbul ignore else */
        if (result) {
          if (!this.registeredObjects) {this.registeredObjects = {}}
          this.registeredObjects[aName] = result
        }
      }
    } else {
      // always create a new object when having aOptions object
      result = this.createObject(aName, aOptions)
    }
    return result
  }
}

export const coreMethods = ['@getInstance', '@_getInstance', '@registeredObjects']

/**
 * Helper ability for factory, You must add a factory ability first.
 */
export const addObjectInstanceForFactoryAbility = createAbilityInjector(ObjectFactory, coreMethods)

export default addObjectInstanceForFactoryAbility
