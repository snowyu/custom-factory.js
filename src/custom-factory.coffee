# Copyright (c) 2014-2015 Riceball LEE, MIT License
inherits              = require("inherits-ex/lib/inherits")
isInheritedFrom       = require("inherits-ex/lib/isInheritedFrom")
createObject          = require("inherits-ex/lib/createObject")
extend                = require("inherits-ex/lib/_extend")
isFunction            = (v)-> 'function' is typeof v
isString              = (v)-> 'string' is typeof v
isObject              = (v)-> 'object' is typeof v

module.exports = (Factory)->
  extend Factory,
    _objects: registeredObjects = {}
    _aliases: aliases = {}
    getNameFromClass: (aClass)->
      result = aClass.name
      len = result.length
      vFactoryName = Factory.name
      throw new InvalidArgumentError('can not getNameFromClass: the '+vFactoryName+'(constructor) has no name error.') unless len
      result = result.substring(0, len-vFactoryName.length) if vFactoryName and vFactoryName.length and result.substring(len-vFactoryName.length) is vFactoryName
      result
    getRealNameFromAlias: (alias)->
      aliases[alias]
    alias: alias = (aClass, aAliases...)->
      # aClass could be a class or class name.
      aClass = Factory.getNameFromClass(aClass) if isFunction aClass
      #vLowerName = vName.toLowerCase()
      #if registeredObjects.hasOwnProperty(aClass)
      for alias in aAliases
        aliases[alias] = aClass
      return
    aliases: alias
    register: register = (aClass, aParentClass, aOptions)->
      if aParentClass
        if not isInheritedFrom aParentClass, Factory
          aOptions = aParentClass
          aParentClass = aOptions.parent
          aParentClass = Factory unless aParentClass
      else
        aParentClass = Factory
      inherits aClass, aParentClass
      vName = aOptions.name if aOptions
      vName = Factory.getNameFromClass(aClass) unless vName
      aClass::name = vName
      #vLowerName = vName.toLowerCase()
      if isInheritedFrom(aClass, Factory) and not registeredObjects.hasOwnProperty(vName)
        aParentClass[vName] = aClass
        if aParentClass isnt Factory
          Factory[vName] = aClass
        if aOptions
          registeredObjects[vName] = aOptions
        else
          registeredObjects[vName] = -1 #createObject aClass, aBufferSize
      else
        false
    unregister: unregister = (aName)->
      if isString aName
        vClass = Factory[aName]
      else
        vClass = aName
        aName = Factory.getNameFromClass(aName)
      if vClass
        #TODO:should I unregister all children?
        while vClass and vClass.super_ and vClass.super_ isnt Factory
          vClass = vClass.super_
          delete vClass[aName]
        delete registeredObjects[aName]
        delete Factory[aName]
        for k, v of aliases
          delete aliases[k] if v is aName
      !!vClass

  class CustomFactory
    constructor: (aName, aOptions)->
      if aName instanceof Factory
        aName.initialize aOptions if aOptions
        return aName
      if isObject aName
        aOptions = aName
        aName = aOptions.name
      if not (this instanceof Factory)
        if not aName
          # arguments.callee is forbidden if strict mode enabled.
          try vCaller = arguments.callee.caller
          if vCaller
            while isInheritedFrom vCaller, Factory
              aName = vCaller
              vCaller = vCaller.caller
            aName = Factory.getNameFromClass(aName) if aName
          return unless aName

        #aName = aName.toLowerCase()
        result = registeredObjects[aName]
        if not result?
          # Is it a alias?
          alias = aName
          aName = Factory.getRealNameFromAlias alias
          if aName
            result = registeredObjects[aName]
        if result instanceof Factory
          result.initialize aOptions
        else if result
          result = if isObject result then extend(result, aOptions) else aOptions
          result = registeredObjects[aName] = createObject Factory[aName], result
        return result
      else
        @initialize(aOptions)
    initialize: (aOptions)->
    toString: ->
      #@name.toLowerCase()
      @name
    register: (aClass, aOptions)-> register aClass, @constructor, aOptions
    unregister: (aName)-> unregister aName
    registered: (aName)-> Factory(aName)
    registeredClass: (aName)-> @constructor[aName]

    inherits Factory, CustomFactory

