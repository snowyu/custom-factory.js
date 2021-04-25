/**
 * @typedef {Object} ICustomFactoryOptions
 * @extends require('./base-factory').IBaseFactoryOptions
 * @property {number=} baseNameOnly
 * @property {typeof CustomFactory} parent
 */

const getPrototypeOf = require('inherits-ex/lib/getPrototypeOf');
const isInheritedFrom = require('inherits-ex/lib/isInheritedFrom')

const { BaseFactory, isPureObject, isFunction, isString, getParentClass } = require("./base-factory")

/**
 * abstract hierarchical factory class
 */
export class CustomFactory extends BaseFactory {
  /**
   * The Root Factory name
   * @abstract
   * @optional
   * @type {string}
   */
  static ROOT_NAME = undefined
  // static baseNameOnly = 1

  static findRootFactory() {
    return this._findRootFactory(CustomFactory)
  }

  static getClassList(ctor) {
    const Factory = this.Factory
    const results = []
    while (ctor && ctor !== Factory) {
      const item = ctor
      ctor = getParentClass(ctor)
      results.push(item)
    }
    return results
  }

  static getClassNameList(ctor) {
    const Factory = this.Factory
    const results = []
    while (ctor && ctor !== Factory) {
      const item = ctor.prototype.name
      ctor = getParentClass(ctor)
      results.push(item)
    }
    return results
  }

  static formatNameFromClass(aClass, aParentClass, aBaseNameOnly) {
    // get the root factory
    const Factory = this.Factory
    let result = aClass.name
    let len = result.length

    if (typeof aParentClass === 'number') {
      aBaseNameOnly = aParentClass
      aParentClass = undefined
    }
    if (aBaseNameOnly == null) {
      aBaseNameOnly = Factory._baseNameOnly
    }

    /*
    if vFactoryName and vFactoryName.length and
      result.substring(len-vFactoryName.length) is vFactoryName
      result = result.substring(0, len-vFactoryName.length)
     */
    if (aBaseNameOnly > 0) {
      if (!aParentClass) {
        aParentClass = this
      }
      const names = this.getClassNameList(aParentClass)
      let vFactoryName = Factory.prototype.name || Factory.name
      names.push(vFactoryName)
      const ref = names.reverse();
      for (let j = 0; j < ref.length; j++) {
        vFactoryName = ref[j];
        if (vFactoryName && vFactoryName.length && result.substring(len - vFactoryName.length) === vFactoryName) {
          result = result.substring(0, len - vFactoryName.length);
          len = result.length;
        }
        if (--aBaseNameOnly <= 0) {
          break;
        }
      }
    }
    return Factory.formatName(result);
  }

  static path(aClass, aRootName) {
    return '/' + this.pathArray(aClass, aRootName).join('/')
  }

  static pathArray(aClass, aRootName) {
    const Factory = this.Factory
    if (isString(aClass)) {
      aRootName = aClass
      aClass = this
    }
    if (!aClass) aClass = this
    let result = aClass.prototype.name
    if (result && result[0] === '/') {
      result = result.split('/').filter(Boolean)
      if (this.formatName !== BaseFactory.formatName)
        result = result.map(this.formatName)
      return result
    }

    if (aRootName == null) {
      aRootName = Factory.ROOT_NAME || Factory.prototype.name || Factory.name
    }

    result = Factory.getClassNameList(aClass)
    result.push(aRootName)

    if (this.formatName !== BaseFactory.formatName) {
      result = result.map(this.formatName)
    }
    return result.reverse()
  }

  static _registerWithParent(aClass, aParentClass, aOptions) {
    const Factory = this.Factory
    if (!isFunction(aParentClass) || !isInheritedFrom(aParentClass, Factory)) {
      throw new TypeError('register: the parent class is illegal')
    }
    return aParentClass._register(aClass, aOptions)

  }

  static register(aClass, aParentClass, aOptions) {
    const Factory = this.Factory
    if (isString(aParentClass)) {
      aOptions = aParentClass
      aParentClass = undefined
    } else if (isPureObject(aParentClass)) {
      aOptions = aParentClass
      aParentClass = aOptions.parent
    }

    if (!aParentClass) aParentClass = this
    const result = this._registerWithParent(aClass, aParentClass, aOptions)
    if (result && !aClass.hasOwnProperty('_children')) aClass._children = {}
    return result
  }
}