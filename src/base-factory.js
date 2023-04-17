/**
 * @typedef {Object} IBaseFactoryOptions
 * @property {string=} name
 * @property {string=} displayName
 * @property {boolean=} baseNameOnly
 * @property {string[]|string=} aliases
 * @property {string[]|string=} alias
 * @property {Function|boolean} [isFactory] defaults to true
 * @property {boolean} [autoInherits] defaults to true
 */

// const inherits = require('inherits-ex/lib/inherits')
// const isInheritedFrom = require('inherits-ex/lib/isInheritedFrom')
// const getPrototypeOf = require('inherits-ex/lib/getPrototypeOf')
// const createObject = require('inherits-ex/lib/createObject')
import inherits from 'inherits-ex/lib/inherits.js'
import isInheritedFrom from 'inherits-ex/lib/isInheritedFrom.js'
import getPrototypeOf from 'inherits-ex/lib/getPrototypeOf.js'
import createObject from 'inherits-ex/lib/createObject.js'


// const slice = [].slice
const getObjectKeys = Object.keys

/**
 * get the parent class(ctor) of the ctor
 * @param {Function} ctor
 * @returns the parent ctor
 */
export function getParentClass(ctor) {
  // get the internal __proto__([[prototype]]) property
  return ctor.super_ || getPrototypeOf(ctor)
}

/**
 * Detect the value whether is a function
 * @param {*} v the value to detect
 */
export function isFunction(v) {
  return 'function' === typeof v
}

/**
 * Detect the value whether is a string
 * @param {*} v the value to detect
 */
export function isString(v) {
  return 'string' === typeof v
}

/**
 * Detect the value whether is an object
 * @param {*} v the value to detect
 */
export function isObject(v) {
  return v != null && 'object' === typeof v
}

/**
 * Detect the object whether is a pure object(the ctor is Object)
 * @param {*} v the value to detect
 */
export function isPureObject(v) {
  return isObject(v) && v.constructor === Object
}

/**
 * Set the displayname to the class in the Factory if no displayname exists
 * @param {typeof BaseFactory} Factory
 * @param {string|Function} aClass the class in the Factory
 * @param {string=} aDisplayName the displayname to set
 * @returns {String} the unique name of the aClass in the Factory
 */
function _getClassNameEnsureDisplayName(Factory, aClass, aDisplayName) {
  let vClass
  if (isString(aClass)) {
    vClass = Factory.registeredClass(aClass)
  } else {
    vClass = aClass
    aClass = Factory.getNameFrom(aClass)
  }
  if (vClass && !vClass.prototype.hasOwnProperty('_displayName')) {
    vClass.prototype._displayName = aDisplayName
  }
  return aClass
}

/**
 * Abstract flat factory class
 * @abstract
 */
export class BaseFactory {
  /**
   * The Root Factory class
   * @name _Factory
   * @abstract
   * @internal
   * @type {typeof BaseFactory}
   */
  static _Factory = undefined

  /**
   * The registered classes in the Factory
   * @name _children
   * @abstract
   * @internal
   * @type {{[name: string]:typeof BaseFactory}}
   */
  static _children = undefined

  /**
   * the registered alias items object.
   * the key is alias name, the value is the registered name
   * @type {[alias: string]: string}
   * @abstract
   * @internal
   */
  static _aliases = undefined

  /**
   * The Root Factory class
   */
  static get Factory() {
    if (!this._Factory) {
      let vFactory = (this._Factory = this.findRootFactory())
      /* istanbul ignore else */
      if (!vFactory._children) vFactory._children = {}
      /* istanbul ignore else */
      if (!vFactory._aliases) vFactory._aliases = {}
    }
    return this._Factory
  }

  /**
   * Extracts a specified number of words from a PascalCase class name to use as a base name for registration,
   * only if no `name` is specified. The parameter value indicates the maximum depth of the word extraction.
   *
   * In JavaScript, class names use `PascalCase` convention where each word starts with a capital letter.
   * The baseNameOnly parameter is a number that specifies which words to extract from the class name as the base name.
   * If the value is 1, it extracts the first word, 2 extracts the first two words, and 0 uses the entire class name.
   * The base name is used to register the class to the factory.
   *
   * @example
   *   such as "JsonTextCodec" if baseNameOnly is 1, the first word "Json" will be extracted from "JsonTextCodec" as
   *   the base name. If baseNameOnly is 2, the first two words "JsonText" will be extracted as the base name. If
   *   baseNameOnly is 0, the entire class name "JsonTextCodec" will be used as the base name.
   * @name _baseNameOnly
   * @type {number}
   * @default 1
   * @internal
   */
  static _baseNameOnly = 1

  /**
   * find the real root factory
   *
   * You can overwrite it to specify your root factory class
   * @abstract
   * @internal
   * @returns {typeof BaseFactory|undefined} the root factory class
   */
  static findRootFactory() {
    return this._findRootFactory(BaseFactory)
  }

  /**
   * find the real root factory
   * @internal
   * @param {typeof BaseFactory} aClass the abstract root factory class
   * @returns {typeof BaseFactory|undefined}
   */
  static _findRootFactory(aClass) {
    let result
    let ctor = this
    while (ctor && ctor !== aClass) {
      result = ctor
      ctor = getParentClass(ctor)
    }
    return result
  }

  /**
   * get the unique name in the factory from an alias name
   * @param {string} alias the alias name
   * @returns {string|undefined} the unique name in the factory
   */
  static getRealNameFromAlias(alias) {
    return this._aliases[alias]
  }

  /**
   * format(transform) the name to be registered.
   *
   * defaults to returning the name unchanged. By overloading this method, case-insensitive names can be achieved.
   * @abstract
   * @internal
   * @param {string} aName
   * @returns {string}
   */
  static formatName(aName) {
    return aName
  }

  /**
   * Get the unique(registered) name in the factory
   * @param {string|Function} aClass
   * @returns {string} the unique name in the factory
   */
  static getNameFrom(aClass) {
    const Factory = this.Factory
    const result = isFunction(aClass)
      ? aClass.prototype.name
      : Factory.formatName(aClass)
    return result
  }

  /**
   * format(transform) the name to be registered for the aClass
   * @param {*} aClass
   * @param {number} [aBaseNameOnly]
   * @returns {string} the name to register
   * @internal
   */
  static formatNameFromClass(aClass, aBaseNameOnly) {
    // get the root factory
    const Factory = this.Factory
    let result = aClass.name
    let len = result.length

    if (aBaseNameOnly == null) {
      aBaseNameOnly = Factory._baseNameOnly
    }

    if (aBaseNameOnly) {
      const vFactoryName = Factory.prototype.name || Factory.name
      if (
        vFactoryName &&
        vFactoryName.length &&
        result.substring(len - vFactoryName.length) === vFactoryName
      )
        result = result.substring(0, len - vFactoryName.length)
    }
    return Factory.formatName(result)
  }

  /**
   * register the aClass to the factory
   * @param {typeof BaseFactory} aClass the class to register the Factory
   * @param {IBaseFactoryOptions|any} [aOptions] the options for the class and the factory
   * @returns {boolean} return true if successful.
   */
  static register() {
    return this._register.apply(this, arguments)
  }

  /**
   * register the aClass to the factory
   * @internal
   * @param {typeof BaseFactory} aClass the class to register the Factory
   * @param {IBaseFactoryOptions|any} [aOptions] the options for the class and the factory
   * @returns {boolean} return true if successful.
   */
  static _register(aClass, aOptions) {
    const Factory = this.Factory
    const vChildren = this._children
    let isFactoryItem = true
    let autoInherits = true
    let result, vDisplayName, vName, baseNameOnly
    if (isString(aOptions)) {
      vName = aOptions
      aOptions = undefined
    } else if (aOptions) {
      vName = aOptions.name
      vDisplayName = aOptions.displayName
      baseNameOnly = aOptions.baseNameOnly
      if (aOptions.isFactory != null) isFactoryItem = aOptions.isFactory
      if (aOptions.autoInherits != null) autoInherits = aOptions.autoInherits
    }
    if (baseNameOnly == null) baseNameOnly = Factory._baseNameOnly

    vName = vName
      ? Factory.formatName(vName)
      : Factory.formatNameFromClass(aClass, baseNameOnly)

    result = !vChildren.hasOwnProperty(vName)
    if (!result) {
      throw new TypeError('the ' + vName + ' has already been registered.')
    }

    if (isFactoryItem) {
      if (isFactoryItem === true) {isFactoryItem = this}
      const isInherited = isInheritedFrom(aClass, isFactoryItem)
      if (autoInherits) {
        if (!isInherited) inherits(aClass, isFactoryItem)
      } else {
        throw new TypeError('the factory item "' + vName + '" is not inherited from "' + isFactoryItem.name + '"')
      }
    }


    /* istanbul ignore else */
    if (result) {
      aClass.prototype.name = vName
      if (vDisplayName) {
        aClass.prototype._displayName = vDisplayName
      }
      Factory._children[vName] = aClass
      if (Factory !== this) {
        vChildren[vName] = aClass
      }
      const alias = aOptions && (aOptions.alias || aOptions.aliases)
      if (alias) {
        /* istanbul ignore else */
        if (isString(alias)) {
          Factory.setAlias(aClass, alias)
        } else if (Array.isArray(alias)) {
          Factory.setAliases(aClass, ...alias)
        }
      }
    }
    return result
  }

  /**
   * Check the name, alias or itself whether registered.
   * @param {string|undefined} aName the class name
   * @returns {false|typeof BaseFactory} the registered class if registered, otherwise returns false
   */
  static registeredClass(aName) {
    let Factory = this.Factory
    let result
    if (aName) {
      result = this.get(aName)
    } else {
      result = Factory === this
      // if (!result) {
      //   // no name specified and the Factory is this, try to use the parent as Factory
      //   const vParent = getParentClass(this)
      //   result = vParent !== BaseFactory
      //   if (result) Factory = vParent
      // }
      if (!result) {
        aName = Factory.getNameFrom(this)
        result =
          Factory._children.hasOwnProperty(aName) && Factory._children[aName]
      }
    }
    return result
  }

  /**
   * unregister this class in the factory
   * @param {string|Function|undefined} aName the registered name or class, no name means unregister itself.
   * @returns {boolean} true means successful
   */
  static unregister(aName) {
    let Factory = this.Factory
    const vChildren = this._children
    let result, vClass
    if (isString(aName)) {
      aName = Factory.formatName(aName)
      vClass = vChildren.hasOwnProperty(aName) && vChildren[aName]
      if (!vClass) {
        aName = Factory.getRealNameFromAlias(aName)
        if (aName) vClass = vChildren.hasOwnProperty(aName) && vChildren[aName]
      }
    } else if (isFunction(aName)) {
      vClass = aName
    } else {
      // const vParent = getParentClass(this)
      vClass = this
    }
    result = !!vClass
    if (result) {
      aName = Factory.getNameFrom(vClass)
      delete Factory._children[aName]
      Factory.cleanAliases(aName)
      if (isInheritedFrom(vClass, Factory)) {
        const vParentClass = getParentClass(vClass)
        if (Factory !== vParentClass) {
          delete vParentClass._children[aName]
        }
      }
    }
    return result
  }

  /**
   * remove all aliases of the registered item or itself
   * @param {string|typeof BaseFactory|undefined} aName the registered item or name
   */
  static cleanAliases(aName) {
    const Factory = this.Factory
    const _aliases = Factory._aliases
    if (!aName) aName = this
    if (isFunction(aName)) aName = aName.prototype.name
    for (let k in _aliases) {
      const v = _aliases[k]
      if (v === aName) {
        delete _aliases[k]
      }
    }
  }

  /**
   * remove specified aliases
   * @param {...string} aliases the aliases to remove
   */
  static removeAlias(...aliases) {
    const Factory = this.Factory
    const _aliases = Factory._aliases
    aliases.forEach((k) => delete _aliases[k])
  }

  /**
   * set aliases to a class
   * @param {typeof BaseFactory|string|undefined} aClass the class to set aliases
   * @param  {...string} aliases the left arguments are aliases
   *
   * @example
   *   import { BaseFactory } from 'custom-factory'
   *   class Factory extends BaseFactory {}
   *   const register = Factory.register.bind(Factory)
   *   const aliases = Factory.setAliases.bind(Factory)
   *   class MyFactory {}
   *   register(MyFactory)
   *   aliases(MyFactory, 'my', 'MY')
   *
   */
  static setAliases(aClass, ...aAliases) {
    const Factory = this.Factory
    const _aliases = Factory._aliases
    if (aAliases.length) {
      aClass = _getClassNameEnsureDisplayName(
        Factory,
        aClass || this,
        aAliases[0]
      )
      aAliases.forEach((alias) => {
        alias = Factory.formatName(alias)
        if (_aliases[alias])
          throw new TypeError('The alias:' + alias + ' already exists')
        _aliases[alias] = aClass
      })
    }
  }

  /**
   * set alias to a class
   * @param {typeof BaseFactory|string|undefined} aClass the class to set alias
   * @param {string} alias
   */
  static setAlias(aClass, alias) {
    const Factory = this.Factory
    const _aliases = Factory._aliases

    aClass = _getClassNameEnsureDisplayName(Factory, aClass || this, alias)
    alias = Factory.formatName(alias)
    if (_aliases[alias])
      throw new TypeError('The alias:' + alias + ' already exists')
    _aliases[alias] = aClass
  }

  /**
   * get the aliases of the aClass
   * @param {typeof BaseFactory|string|undefined} aClass the class or name to get aliases, means itself if no aClass specified
   * @returns {string[]} aliases
   */
  static getAliases(aClass) {
    const Factory = this.Factory
    const _aliases = Factory._aliases
    if (!aClass) {
      aClass = Factory.getNameFrom(this)
    } else if (!isString(aClass)) {
      aClass = Factory.getNameFrom(aClass)
    }
    let result = Object.keys(_aliases)
    if (aClass) result = result.filter((key) => _aliases[key] === aClass)
    return result
  }

  /**
   * the aliases of itself
   */
  static get aliases() {
    return this.getAliases()
  }

  static set aliases(value) {
    this.cleanAliases()
    if (isString(value)) this.setAlias(null, value)
    else this.setAliases(null, ...value)
  }

  /**
   * Get the display name from aClass
   * @param {string|Function|undefined} aClass the class, name or itself, means itself if no aClass
   * @returns {string|undefined}
   */
  static getDisplayName(aClass) {
    const Factory = this.Factory
    if (!aClass) {
      aClass = this
    } else if (isString(aClass)) {
      aClass = Factory.get(aClass)
    }
    return aClass.prototype._displayName || Factory.getNameFrom(aClass)
  }

  /**
   * Set the display name to the aClass
   * @param {string|Function|undefined} aClass the class, name or itself, means itself if no aClass
   * @param {string|{displayName: string}} aDisplayName the display name to set
   */
  static setDisplayName(aClass, aDisplayName) {
    const Factory = this.Factory
    if (isString(aClass)) {
      if (isString(aDisplayName)) {
        aClass = Factory.get(aClass)
      } else {
        aDisplayName = aClass
        aClass = this
      }
    }
    if (isObject(aDisplayName)) {
      aDisplayName = aDisplayName.displayName
    }

    if (isString(aDisplayName)) {
      aClass.prototype._displayName = aDisplayName
    }
  }

  /**
   * This callback function is used to get all the classes in the factory. If 'brk' is returned, the function will stop.
   * @callback FactoryClassForEachFn
   * @param {typeof BaseFactory} ctor the class in the factory
   * @param {string} name the unique name in the factory
   * @returns {'brk'|string|undefined}
   */

  /**
   * executes a provided callback function once for each registered element.
   * @param {FactoryClassForEachFn} cb the forEach callback function
   * @returns {this}
   */
  static forEach(cb) {
    if (isFunction(cb)) {
      const ref = getObjectKeys(this._children)
      // root factory
      const Factory = this.Factory
      for (let j = 0; j < ref.length; j++) {
        const k = ref[j]
        const v = this._children[k]
        /* istanbul ignore else */
        if (v !== Factory && isInheritedFrom(v, Factory)) {
          if (cb(v, k) === 'brk') {
            break
          }
        }
      }
    }
    return this
  }

  /**
   * Get the registered class via name
   * @param {string} aName the class name or alias
   * @returns {undefined|typeof BaseFactory} return the registered class if found the name
   */
  static get(name) {
    return this._get(name)
  }

  static _get(name) {
    const Factory = this.Factory
    const vChildren = this._children
    name = Factory.formatName(name)
    let result = vChildren.hasOwnProperty(name) && vChildren[name]
    if (!result) name = Factory.getRealNameFromAlias(name)
    result = vChildren.hasOwnProperty(name) && vChildren[name]
    return result || undefined
  }

  /**
   * Create a new object instance of Factory
   * @param {string|BaseFactory} aName
   * @param {*} aOptions
   * @returns {BaseFactory|undefined}
   */
  static createObject(aName, aOptions) {
    if (aName instanceof BaseFactory) {
      if (aOptions != null) {
        aName.initialize(aOptions)
      }
      return aName
    }

    if (aName) {
      if (isObject(aName)) {
        aOptions = aName
        aName = aOptions.name
      } else if (!isString(aName)) {
        aOptions = aName
        aName = undefined
      }
    }

    const Factory = aName ? this.Factory : this
    let result = Factory.registeredClass(aName)
    if (result) {
      return createObject(result, aOptions)
    }
  }

  constructor() {
    this.initialize.apply(this, arguments)
  }

  /* istanbul ignore start */
  /**
   * initialize instance method
   * @abstract
   * @internal
   * @param {...any} arguments pass through all arguments coming from constructor
   */
  initialize() {}
  /* istanbul ignore end */
}
