# Copyright (c) 2014-2015 Riceball LEE, MIT License
inherits              = require("inherits-ex/lib/inherits")
isInheritedFrom       = require("inherits-ex/lib/isInheritedFrom")
createObject          = require("inherits-ex/lib/createObject")
xtend                 = require("xtend/mutable")

module.exports = class CustomFactory

  @_objects: registeredObjects = {}
  @_aliases: aliases = {}
  constructor: (aName, aOptions)->
    if aName instanceof CustomFactory
      aName.initialize aOptions if aOptions
      return aName
    if 'object' is typeof aName
      aOptions = aName
      aName = undefined
    if not (this instanceof CustomFactory)
      if not aName
        # arguments.callee is forbidden if strict mode enabled.
        try vCaller = arguments.callee.caller
        if vCaller
          while isInheritedFrom vCaller, CustomFactory
            aName = vCaller
            vCaller = vCaller.caller
          aName = CustomFactory.getNameFromClass(aName) if aName
        return unless aName

      aName = aName.toLowerCase()
      result = registeredObjects[aName]
      if not result?
        # Is it a alias?
        alias = aName
        aName = CustomFactory.getRealNameFromAlias alias
        if aName
          result = registeredObjects[aName]
      if result instanceof CustomFactory
        result.initialize aOptions
      else if result
        result = if 'object' is typeof result then xtend(result, aOptions) else aOptions
        result = registeredObjects[aName] = createObject CustomFactory[aName], result
      return result
    else
      @initialize(aOptions)
  initialize: (aOptions)->
  toString: ->
    @name.toLowerCase()
  @getNameFromClass: (aClass)->
    result = aClass.name
    len = result.length
    throw new InvalidArgumentError('the CustomFactory(construcor) has no name error.') unless len
    vBasicClass = isInheritedFrom aClass, CustomFactory
    vBasicClass = vBasicClass.name if vBasicClass
    result = result.substring(0, len-vBasicClass.length) if vBasicClass and vBasicClass.length and result.substring(len-vBasicClass.length) is vBasicClass
    result
  @getRealNameFromAlias: (alias)->
    aliases[alias]
  @alias: (aClass, aAliases...)->
    vName = CustomFactory.getNameFromClass(aClass)
    vLowerName = vName.toLowerCase()
    if registeredObjects.hasOwnProperty(vLowerName)
      for alias in aAliases
        aliases[alias] = vLowerName
  @aliases: @alias
  @register: (aClass, aParentClass = CustomFactory, aOptions)->
    inherits aClass, aParentClass
    vName = CustomFactory.getNameFromClass(aClass)
    aClass::name = vName
    vLowerName = vName.toLowerCase()
    if isInheritedFrom(aClass, CustomFactory) and not registeredObjects.hasOwnProperty(vLowerName)
      aParentClass[vLowerName] = aClass
      if aParentClass isnt CustomFactory
        CustomFactory[vLowerName] = aClass
      if aOptions
        registeredObjects[vLowerName] = aOptions
      else
        registeredObjects[vLowerName] = -1 #createObject aClass, aBufferSize
    else
      false
  @unregister: (aName)->
    delete registeredObjects[aName.toLowerCase()]

