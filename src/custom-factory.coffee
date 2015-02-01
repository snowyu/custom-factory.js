# Copyright (c) 2014-2015 Riceball LEE, MIT License
inherits              = require("inherits-ex/lib/inherits")
isInheritedFrom       = require("inherits-ex/lib/isInheritedFrom")
createObject          = require("inherits-ex/lib/createObject")
extend                = require("inherits-ex/lib/_extend")

module.exports = (Factory)->
  extend Factory,
    _objects: registeredObjects = {}
    _aliases: aliases = {}
    getNameFromClass: (aClass)->
      result = aClass.name
      len = result.length
      vFactoryName = Factory.name
      throw new InvalidArgumentError('can not getNameFromClass: the '+vFactoryName+'(construcor) has no name error.') unless len
      result = result.substring(0, len-vFactoryName.length) if vFactoryName and vFactoryName.length and result.substring(len-vFactoryName.length) is vFactoryName
      result
    getRealNameFromAlias: (alias)->
      aliases[alias]
    alias: alias = (aClass, aAliases...)->
      vName = Factory.getNameFromClass(aClass)
      vLowerName = vName.toLowerCase()
      if registeredObjects.hasOwnProperty(vLowerName)
        for alias in aAliases
          aliases[alias] = vLowerName
    aliases: alias
    register: (aClass, aParentClass = Factory, aOptions)->
      inherits aClass, aParentClass
      vName = Factory.getNameFromClass(aClass)
      aClass::name = vName
      vLowerName = vName.toLowerCase()
      if isInheritedFrom(aClass, Factory) and not registeredObjects.hasOwnProperty(vLowerName)
        aParentClass[vLowerName] = aClass
        if aParentClass isnt Factory
          Factory[vLowerName] = aClass
        if aOptions
          registeredObjects[vLowerName] = aOptions
        else
          registeredObjects[vLowerName] = -1 #createObject aClass, aBufferSize
      else
        false
    unregister: (aName)->
      delete registeredObjects[aName.toLowerCase()]

  class CustomFactory
    constructor: (aName, aOptions)->
      if aName instanceof Factory
        aName.initialize aOptions if aOptions
        return aName
      if 'object' is typeof aName
        aOptions = aName
        aName = undefined
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

        aName = aName.toLowerCase()
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
          result = if 'object' is typeof result then extend(result, aOptions) else aOptions
          result = registeredObjects[aName] = createObject Factory[aName], result
        return result
      else
        @initialize(aOptions)
    initialize: (aOptions)->
    toString: ->
      @name.toLowerCase()

    inherits Factory, CustomFactory

