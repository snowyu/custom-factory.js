const getPrototypeOf = require('inherits-ex/lib/getPrototypeOf');
const isInheritedFrom = require('inherits-ex/lib/isInheritedFrom')

const { BaseFactory, isPureObject, isFunction, isString, getParentClass } = require("./base-factory")

/**
 * @typedef {Object} ICustomFactoryOptions
 * @extends IBaseFactoryOptions
 * @property {number=} baseNameOnly
 * @property {typeof CustomFactory} parent
 */

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

  static getNameFromClass(aClass, aParentClass, aBaseNameOnly) {
    // get the root factory
    const Factory = this.Factory
    let len, result
    result = aClass.prototype.name || aClass.name
    len = result.length
    if (!len) {
      throw new InvalidArgumentError(
        'can not getNameFromClass: the class(constructor) has no name error.')
    }
    if (typeof aParentClass === 'number') {
      aBaseNameOnly = aParentClass
      aParentClass = undefined
    }
    if (aBaseNameOnly == null) {
      aBaseNameOnly = Factory.baseNameOnly
    }

    /*
    if vFactoryName and vFactoryName.length and
      result.substring(len-vFactoryName.length) is vFactoryName
      result = result.substring(0, len-vFactoryName.length)
     */
    if (aBaseNameOnly) {
      if (!aParentClass) {
        aParentClass = this;
      }
      const names = this.getClassNameList(aParentClass);
      let vFactoryName = Factory.prototype.name || Factory.name
      names.push(vFactoryName);
      if (names.length) {
        const ref = names.reverse();
        for (let j = 0; j < ref.length; j++) {
          vFactoryName = ref[j];
          if (vFactoryName && vFactoryName.length && result.substring(len - vFactoryName.length) === vFactoryName) {
            result = result.substring(0, len - vFactoryName.length);
            len = result.length;
          }
          if (!--aBaseNameOnly) {
            break;
          }
        }
      }
    }
    return Factory.formatName(result);
  }

  static path(aClass, aRootName) {
    return '/' + this.pathArray(aClass, aRootName).join('/')
  }

  static pathArray(aClass, aRootName) {
    const Factory = this.Factory || this
    let result = aClass.prototype.name
    if (result && result[0] === '/') {
      return result.split('/').filter(Boolean)
    }

    if (aRootName == null) {
      aRootName = Factory.ROOT_NAME || Factory.prototype.name || Factory.name
    }

    result = Factory.getClassNameList(aClass)
    if (aRootName) {
      result.push(aRootName)
    }

    if (this.formatName !== BaseFactory.formatName) {
      result = result.map(this.formatName)
    }
    return result.reverse()
  }

  static _registerWithParent(aClass, aParentClass, aOptions) {
    const Factory = this.Factory || this
    if (!isFunction(aParentClass) || !isInheritedFrom(aParentClass, Factory)) {
      throw new TypeError('register: the parent class is illegal')
    }
    return aParentClass._register(aClass, aOptions)

  }

  static register(aClass, aParentClass, aOptions) {
    const Factory = this.Factory || this
    if (isString(aParentClass)) {
      aOptions = aParentClass
      aParentClass = undefined
    } else if (isPureObject(aParentClass)) {
      aOptions = aParentClass
      aParentClass = aOptions.parent
    }

    if (!aParentClass) aParentClass = Factory
    return this._registerWithParent(aClass, aParentClass, aOptions)

  }
}
