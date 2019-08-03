# Copyright (c) 2014-2019 Riceball LEE, MIT License
deprecate             = require('depd')('custom-factory')
inherits              = require('inherits-ex/lib/inherits')
isInheritedFrom       = require('inherits-ex/lib/isInheritedFrom')
createObject          = require('inherits-ex/lib/createObject')
getPrototypeOf        = require('inherits-ex/lib/getPrototypeOf')
customAbility         = require('custom-ability')
extend                = require('./extend')
isFunction            = (v)-> 'function' is typeof v
isString              = (v)-> 'string' is typeof v
isObject              = (v)-> v? and 'object' is typeof v
getObjectKeys         = Object.keys

getParentClass = (ctor)-> ctor.super_ || getPrototypeOf(ctor)

# return FlatClassFactory class
getFlatClassFactory = (Factory, aOptions) ->
  if isObject aOptions
    registeredName = aOptions.registeredName if aOptions.registeredName?

  Factory[registeredName] = {} if registeredName
  # hold all registered classes here
  registeredOnRoot = (registeredName && Factory[registeredName]) || Factory
  Factory.ROOT_NAME = Factory.name

  class FlatClassFactory
    @__aliases: {}
    @getRealNameFromAlias: (alias)->
      @__aliases[alias]
    @formatName: (aName)->aName
    @getFactoryItem: (aName, aOptions)->
      result = registeredOnRoot[aName]
      if result is undefined and @__aliases
        # Is it an alias?
        aName = Factory.getRealNameFromAlias aName
        result = registeredOnRoot[aName] if aName
      result
    @register: (aClass, aOptions)->
      if isString aOptions
        vName = aOptions
      else if aOptions
        vName = aOptions.name
        vDisplayName = aOptions.displayName
        # vCreateOnDemand = aOptions.createOnDemand
      if not vName
        vName = aClass.name
        if vName.substring(len-Factory.name.length) is Factory.name
          vName = vName.substring(0, len-Factory.name.length)
      vName = this.formatName vName
      result = this.getFactoryItem(vName)

      throw new TypeError(
        'the ' + vName + ' has already been registered.'
      ) if result

      aClass::name = vName
      aClass::_displayName = vDisplayName if vDisplayName
      @
    @unregister: (aName)->
      if isString aName
        aName = this.formatName aName
        vClass = registeredOnRoot.hasOwnProperty(aName) and registeredOnRoot[aName]
      else
        vClass = aName
        #aName = Factory.getNameFromClass(aName)
      result = isFunction vClass
      if result
        aName = vClass::name
        delete registeredOnRoot[aName]
        if @__aliases
          for k, v of @__aliases
            delete @__aliases[k] if v is aName
      !!result
    @forEach: (cb)->
      if isFunction cb
        for k in getObjectKeys registeredOnRoot
          v = registeredOnRoot[k]
          if isFunction v
            break if cb(v, k) == 'brk'
      @
    @displayName: (aClass, aValue)->
      if isString aClass
        aValue = aClass
        aClass = Factory
      if isString aValue
        if isFunction aClass
          if !aValue && @__aliases
            vClassName = aClass.name
            for k,v of @__aliases
              if v is vClassName
                aValue = k
                break
          if aValue
            aClass::_displayName = aValue
          else
            delete aClass::_displayName
        else
          throw new TypeError 'set displayName: Invalid Class'
        return
      # aClass = Factory unless aClass
      # if isString aClass
      #   aClass = Factory.registeredClass aClass
      if isFunction aClass
        result = aClass::_displayName if aClass::hasOwnProperty '_displayName'
        result ?= aClass::name
      else
        throw new TypeError 'get displayName: Invalid Class'
      result
    @aliases: (aClass, aAliases...)->
      if aAliases.length
        # aClass could be a class or class name.
        vClass = aClass
        aClass = aClass.name
        aAliases = aAliases.map Factory.formatName
        vClass = registeredOnRoot[aClass] if !isFunction vClass
        if vClass and not vClass::hasOwnProperty '_displayName'
          vClass::_displayName = aAliases[0]
        for alias in aAliases
          @__aliases[alias] = aClass
        return
      aClass = aClass.name
      result = []
      for k,v of @__aliases
        result.push k if v is aClass
      result
    register: FlatClassFactory.register
    unregister: FlatClassFactory.unregister
    aliases: FlatClassFactory.aliases

  if aOptions and isFunction aOptions.fnGet
    vNewGetFactoryItem = aOptions.fnGet
    getFactoryItem = ((inherited)->
      that =
        super: inherited
        self: this
      return -> vNewGetFactoryItem.apply(that, arguments)
    )(FlatClassFactory.getFactoryItem)
    FlatClassFactory.getFactoryItem = getFactoryItem

  FlatClassFactory

module.exports.getFlatClassFactory = getFlatClassFactory
