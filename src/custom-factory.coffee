# Copyright (c) 2014-2015 Riceball LEE, MIT License
inherits              = require("inherits-ex/lib/inherits")
isInheritedFrom       = require("inherits-ex/lib/isInheritedFrom")
createObject          = require("inherits-ex/lib/createObject")
extend                = require("inherits-ex/lib/_extend")
isFunction            = (v)-> 'function' is typeof v
isString              = (v)-> 'string' is typeof v
isObject              = (v)-> v? and 'object' is typeof v

module.exports = (Factory, aOptions)->
  flatOnly = aOptions.flatOnly if isObject aOptions

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
    extendClass: extendClass = (aParentClass) ->
      extend aParentClass,
        register: _register = (aClass, aOptions)->
          result = inherits aClass, aParentClass
          if result
            extendClass(aClass) unless flatOnly
            vName = aOptions.name if aOptions
            vName = Factory.getNameFromClass(aClass) unless vName
            aClass::name = vName
            result = not registeredObjects.hasOwnProperty(vName)
            if result
              aParentClass[vName] = aClass
              Factory[vName] = aClass unless aParentClass is Factory
              if aOptions?
                registeredObjects[vName] = aOptions
              else
                registeredObjects[vName] = null #createObject aClass, aBufferSize
          result
        _register: _register
        unregister: (aName)->
          if isString aName
            vClass = Factory[aName]
          else
            vClass = aName
            aName = Factory.getNameFromClass(aName)
          result = vClass and isInheritedFrom vClass, aParentClass
          if result
            #TODO:should I unregister all children?
            while vClass and vClass.super_ and vClass.super_ isnt Factory
              vClass = vClass.super_
              delete vClass[aName]
            delete registeredObjects[aName]
            delete Factory[aName]
            for k, v of aliases
              delete aliases[k] if v is aName
          !!result
  Factory.extendClass Factory
  Factory.register = (aClass, aParentClass, aOptions)->
    if aParentClass
      if not isInheritedFrom aParentClass, Factory
        aOptions = aParentClass
        aParentClass = aOptions.parent
        aParentClass = Factory if flatOnly or not aParentClass
      else if flatOnly
        throw new TypeError "It's a flat factory, register to the parent class is not allowed"
    else
      aParentClass = Factory
    if aParentClass is Factory
      Factory._register aClass, aOptions
    else
      aParentClass.register aClass, aOptions

  class CustomFactory
    constructor: (aName, aOptions)->
      if aName instanceof Factory
        aName.initialize aOptions
        return aName
      if aName
        if isObject aName
          aOptions = aName
          aName = aOptions.name
        else if not isString aName
          aOptions = aName
          aName = undefined
      if not (this instanceof Factory)
        if not aName
          # arguments.callee is forbidden if strict mode enabled.
          try vCaller = arguments.callee.caller
          if vCaller and isInheritedFrom vCaller, Factory
            aName = vCaller
            vCaller = vCaller.caller
            #get farest hierarchical registered class
            while isInheritedFrom vCaller, aName
              aName = vCaller
              vCaller = vCaller.caller
            aName = Factory.getNameFromClass(aName) if aName
          return unless aName

        #aName = aName.toLowerCase()
        result = registeredObjects[aName]
        if result is undefined
          # Is it a alias?
          alias = aName
          aName = Factory.getRealNameFromAlias alias
          if aName
            result = registeredObjects[aName]
          return if result is undefined
        if result instanceof Factory
          result.initialize aOptions
        else
          result = if isObject result then extend(result, aOptions) else if aOptions? then aOptions else result
          result = registeredObjects[aName] = createObject Factory[aName], undefined, result
        return result
      else
        @initialize(aOptions)
    initialize: (aOptions)->
    toString: ->
      #@name.toLowerCase()
      @name

    if not flatOnly
      @::register= (aClass, aOptions)-> @constructor.register aClass, aOptions
      @::unregister= (aName)-> @constructor.unregister aName
      @::registered= (aName)-> Factory(aName)
      @::registeredClass= (aName)-> @constructor[aName]

    inherits Factory, CustomFactory

