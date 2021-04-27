/**
 * @typedef {Object} IBaseFactoryOptions
 * @property {string=} name
 * @property {string=} displayName
 * @property {boolean=} baseNameOnly
 */

const inherits = require('inherits-ex/lib/inherits')
const isInheritedFrom = require('inherits-ex/lib/isInheritedFrom')
const getPrototypeOf = require('inherits-ex/lib/getPrototypeOf')
const createObject = require('inherits-ex/lib/createObject')

// const slice = [].slice
const getObjectKeys = Object.keys

/**
 * get the parent class of ctor
 * @param {*} ctor
 * @returns
 */
export function getParentClass(ctor) {
  return ctor.super_ || getPrototypeOf(ctor)
}

export function isFunction(v) {
  return 'function' === typeof v
}

export function isString(v) {
  return 'string' === typeof v
}

export function isObject(v) {
  return v != null && 'object' === typeof v
}

export function isPureObject(v) {
  return isObject(v) && v.constructor === Object
}

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
 * abstract flat factory class
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
   * The registered Factory classes
   * @name _children
   * @abstract
   * @internal
   * @type {{[name: string]:typeof BaseFactory}}
   */
  static _children = undefined

  /**
   * the registered items aliases object.
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

  static _baseNameOnly = 1

  /**
   * find the real root factory
   * @abstract
   * @internal
   * @returns {typeof BaseFactory} the root factory class
   */
  static findRootFactory() {
    return this._findRootFactory(BaseFactory)
  }

  static _findRootFactory(aClass) {
    let result
    let ctor = this
    while (ctor && ctor !== aClass) {
      result = ctor
      ctor = getParentClass(ctor)
    }
    return result
  }

  static getRealNameFromAlias(alias) {
    return this._aliases[alias]
  }

  static formatName(aName) {
    return aName
  }

  static getNameFrom(aClass) {
    const Factory = this.Factory
    const result = isFunction(aClass)
      ? aClass.prototype.name
      : Factory.formatName(aClass)
    return result
  }

  /**
   * format name for the aClass
   * @param {*} aClass
   * @param {*} aBaseNameOnly
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
   * @param {IBaseFactoryOptions|any} aOptions the options for the class and the factory
   * @returns {boolean} return true if successful.
   */
  static register() {
    return this._register.apply(this, arguments)
  }

  /**
   * register the aClass to the factory
   * @internal
   * @param {typeof BaseFactory} aClass the class to register the Factory
   * @param {IBaseFactoryOptions|any} aOptions the options for the class and the factory
   * @returns {boolean} return true if successful.
   */
  static _register(aClass, aOptions) {
    const Factory = this.Factory
    const vChildren = this._children
    let result, vDisplayName, vName, baseNameOnly
    if (isString(aOptions)) {
      vName = aOptions
    } else if (aOptions) {
      vName = aOptions.name
      vDisplayName = aOptions.displayName
      baseNameOnly = aOptions.baseNameOnly
    }
    if (baseNameOnly == null) baseNameOnly = Factory._baseNameOnly

    vName = vName
      ? Factory.formatName(vName)
      : Factory.formatNameFromClass(aClass, baseNameOnly)

    const isInherited = isInheritedFrom(aClass, Factory)
    result = vChildren.hasOwnProperty(vName) && isInherited
    if (result) {
      throw new TypeError('the ' + vName + ' has already been registered.')
    }
    result = isInherited ? true : inherits(aClass, this)

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
    }
    return result
  }

  /**
   * check the name, alias or itself whether registered
   * @param {string|undefined} aName the class name
   * @returns {false|typeof BaseFactory}
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
    result = vClass && isInheritedFrom(vClass, Factory)
    if (result) {
      aName = Factory.getNameFrom(vClass)
      delete Factory._children[aName]
      Factory.cleanAliases(aName)
      if (Factory !== this) delete vChildren[aName]
    }
    return !!result
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
   * get the aliases of the class
   * @param {typeof BaseFactory|string|undefined} aClass the class or name to get aliases
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

  static get aliases() {
    return this.getAliases()
  }

  static set aliases(value) {
    this.cleanAliases()
    if (isString(value)) this.setAlias(null, value)
    else this.setAliases(null, ...value)
  }

  static getDisplayName(aClass) {
    const Factory = this.Factory
    if (!aClass) {
      aClass = this
    } else if (isString(aClass)) {
      aClass = Factory.get(aClass)
    }
    return aClass.prototype._displayName || Factory.getNameFrom(aClass)
  }

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
   * @callback FactoryClassForEachFn
   * @param {typeof BaseFactory} ctor
   * @param {string} name
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
   * get the registered class via name
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
   * create a new object instance of Factory
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

  /**
   * initialize instance method
   * @abstract
   * @internal
   * @param {...any} arguments pass through all arguments coming from constructor
   */
  initialize() {}
}
