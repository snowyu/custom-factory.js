# Copyright (c) 2014-2015 Riceball LEE, MIT License
deprecate             = require('depd')('custom-factory')
inherits              = require('inherits-ex/lib/inherits')
isInheritedFrom       = require('inherits-ex/lib/isInheritedFrom')
createObject          = require('inherits-ex/lib/createObject')
extend                = require('./extend')
isFunction            = (v)-> 'function' is typeof v
isString              = (v)-> 'string' is typeof v
isObject              = (v)-> v? and 'object' is typeof v
getObjectKeys         = Object.keys

exports = module.exports = (Factory, aOptions)->
  if isObject aOptions
    flatOnly = aOptions.flatOnly
    baseNameOnly = aOptions.baseNameOnly if aOptions.baseNameOnly?
  baseNameOnly ?= 1

  # the Static(Class) Methods for Factory:
  extend Factory,
    ROOT_NAME: Factory.name
    getClassList: (ctor)->
      result = while ctor and ctor isnt Factory
        item = ctor
        ctor = ctor.super_
        item
    getClassNameList: getClassNameList = (ctor)->
      result = while ctor and ctor isnt Factory
        item = ctor::name
        ctor = ctor.super_
        item
    path: (aClass, aRootName)->
      '/' + @pathArray(aClass, aRootName).join '/'
    pathArray: (aClass, aRootName) ->
      result = aClass::name
      return result.split('/').filter(Boolean) if result and result[0] is '/'
      aRootName = Factory.ROOT_NAME unless aRootName?
      result = getClassNameList(aClass)
      result.push aRootName if aRootName
      if Factory.formatName isnt formatName
        result = (Factory.formatName(i) for i in result)
      result.reverse()
    _objects: registeredObjects = {}
    _aliases: aliases = {}
    formatName: formatName = (aName)->aName
    getNameFrom: (aClass)->
      if isFunction aClass
        #Factory.getNameFromClass(aClass)
        aClass::name
      else
        Factory.formatName aClass
    getNameFromClass: (aClass, aParentClass, aBaseNameOnly)->
      result = aClass.name
      len = result.length

      throw new InvalidArgumentError(
        'can not getNameFromClass: the ' +
         vFactoryName+'(constructor) has no name error.'
      ) unless len
      aBaseNameOnly = baseNameOnly unless aBaseNameOnly?

      ###
      vFactoryName = Factory.name
      if vFactoryName and vFactoryName.length and
         result.substring(len-vFactoryName.length) is vFactoryName
        result = result.substring(0, len-vFactoryName.length)
      ###
      if aBaseNameOnly # then remove Parent Name if any
        aParentClass = aClass.super_ unless aParentClass
        names = getClassNameList aParentClass
        names.push Factory.name
        if names.length
          for vFactoryName in names.reverse()
            if vFactoryName and vFactoryName.length and
               result.substring(len-vFactoryName.length) is vFactoryName
              result = result.substring(0, len-vFactoryName.length)
              len = result.length
            break unless --aBaseNameOnly
      Factory.formatName result
    _get: getInstance = (aName, aOptions)->
      result = registeredObjects[aName]
      if result is undefined
        # Is it a alias?
        aName = Factory.getRealNameFromAlias aName
        if aName
          result = registeredObjects[aName]
        return if result is undefined
      if result instanceof Factory
        # do not initialize if no aOptions
        result.initialize aOptions if aOptions?
      else
        result = if isObject result then extend(result, aOptions) else
          if aOptions? then aOptions else result

        cls = Factory[aName]
        if cls
          result = createObject cls, undefined, result
          registeredObjects[aName] = result
        else
          result = undefined
      return result
    get: (aName, aOptions)-> getInstance(aName, aOptions)
    extendClass: extendClass = (aParentClass) ->
      extend aParentClass,
        forEachClass: (cb)->
          if isFunction cb
            for k in getObjectKeys aParentClass
              v = aParentClass[k]
              if isInheritedFrom v, Factory
                break if cb(v, k) == 'brk'
          aParentClass
        forEach: (aOptions, cb)->
          if isFunction aOptions
            cb = aOptions
            aOptions = null
          if isFunction cb
            aParentClass.forEachClass (v,k)->
              cb(Factory.get(k, aOptions), k)
          aParentClass
        register: _register = (aClass, aOptions)->
          if isString aOptions
            vName = aOptions
          else if aOptions
            vName = aOptions.name
            vDisplayName = aOptions.displayName
            vCreateOnDemand = aOptions.createOnDemand
          if not vName
            if aOptions && aOptions.baseNameOnly
              vBaseNameOnly = aOptions.baseNameOnly
            else
              vBaseNameOnly = baseNameOnly
            vName = Factory.getNameFromClass(aClass, aParentClass, vBaseNameOnly)
          else
            vName = Factory.formatName vName
          result = not registeredObjects.hasOwnProperty(vName)

          throw new TypeError(
            'the ' + vName + ' has already been registered.'
          ) unless result

          result = inherits aClass, aParentClass
          if result
            extendClass(aClass) unless flatOnly
            aClass::name = vName
            aClass::_displayName = vDisplayName if vDisplayName
            if result
              aParentClass[vName] = aClass
              Factory[vName] = aClass unless aParentClass is Factory
              if vCreateOnDemand isnt false
                registeredObjects[vName] = if aOptions? then aOptions else null
              else
                registeredObjects[vName] =
                  createObject aClass, undefined, aOptions
          result
        _register: _register
        unregister: (aName)->
          if isString aName
            aName = Factory.formatName aName
            vClass = Factory.hasOwnProperty(aName) and Factory[aName]
          else
            vClass = aName
            #aName = Factory.getNameFromClass(aName)
          result = vClass and isInheritedFrom vClass, aParentClass
          if result
            aName = vClass::name
            #TODO:should I unregister all children?
            while vClass and vClass.super_ and vClass.super_ isnt Factory
              vClass = vClass.super_
              delete vClass[aName]
            delete registeredObjects[aName]
            delete Factory[aName]
            for k, v of aliases
              delete aliases[k] if v is aName
          !!result
        registeredClass: (aName)->
          aName   = Factory.formatName aName
          result  = aParentClass.hasOwnProperty(aName) and aParentClass[aName]
          return result if result
          aName  = Factory.getRealNameFromAlias aName
          return aParentClass.hasOwnProperty(aName) and aParentClass[aName] if aName
      if not flatOnly or aParentClass is Factory
        extend aParentClass,
          getRealNameFromAlias: (alias)->
            aliases[alias]
          displayName: (aClass, aValue)->
            if isString aClass
              aValue = aClass
              aClass = aParentClass
            if isString aValue
              if isFunction aClass
                if !aValue
                  vClassName = Factory.getNameFrom(aClass)
                  for k,v of aliases
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
            aClass = aParentClass unless aClass
            # if isString aClass
            #   aClass = Factory.registeredClass aClass
            if isFunction aClass
              result = aClass::_displayName if aClass::hasOwnProperty '_displayName'
              result ?= aClass::name
            else
              throw new TypeError 'get displayName: Invalid Class'
            result
          alias: alias = (aClass, aAliases...)->
            if aAliases.length
              # aClass could be a class or class name.
              vClass = aClass
              aClass = Factory.getNameFrom(aClass)
              aAliases = aAliases.map Factory.formatName
              vClass = Factory.registeredClass(aClass) if !isFunction vClass
              if vClass and not vClass::hasOwnProperty '_displayName'
                vClass::_displayName = aAliases[0]
              for alias in aAliases
                aliases[alias] = aClass
              return
            aClass = aParentClass unless aClass
            aClass = Factory.getNameFrom(aClass)
            result = []
            for k,v of aliases
              result.push k if v is aClass
            result
          aliases: alias
          create: (aName, aOptions)->
            result = aParentClass.registeredClass aName
            if result is undefined and aParentClass isnt Factory
              # search the root factory
              result = Factory.registeredClass aName
            if result then createObject result, aOptions

  Factory.extendClass Factory
  Factory::_objects = registeredObjects
  Factory::_aliases = aliases
  deprecate.property Factory, '_objects', 'use Factory::_objects instead'
  deprecate.property Factory, '_aliases', 'use Factory::_aliases instead'
  Factory.register = (aClass, aParentClass, aOptions)->
    if aParentClass
      if not isFunction aParentClass or
         not isInheritedFrom aParentClass, Factory
        aOptions = aParentClass
        aParentClass = aOptions.parent
        aParentClass = Factory if flatOnly or not aParentClass
      else if flatOnly
        throw new TypeError "
          It's a flat factory, register to the parent class is not allowed"
    else
      aParentClass = Factory
    if aParentClass is Factory
      Factory._register aClass, aOptions
    else
      aParentClass.register aClass, aOptions

  if aOptions and isFunction aOptions.fnGet
    vNewGetInstance = aOptions.fnGet
    getInstance = ((inherited)->
      that =
        super: inherited
        self: this
      return -> vNewGetInstance.apply(that, arguments)
    )(Factory._get)
    Factory.get = getInstance

  class CustomFactory
    constructor: (aName, aOptions)->
      if aName instanceof Factory
        # do not initialize if no aOptions
        aName.initialize aOptions if aOptions?
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
            #aName = Factory.getNameFromClass(aName) if aName
            aName = aName::name if aName
          return unless aName
        else
          aName = Factory.formatName aName
        return Factory.get aName, aOptions
      else
        @initialize(aOptions)
    #@_create: createInstance = (aName, aOptions)->
    initialize: (aOptions)->
    toString: ->
      #@name.toLowerCase()
      @name
    getFactoryItem: (aName, aOptions)->Factory.get.call(@, aName, aOptions)
    aliases: -> @Class.aliases.apply @, arguments
    displayName: (aClass, aValue)-> @Class.displayName.call @, aClass, aValue


    if not flatOnly
      @::register= (aClass, aOptions)-> @Class.register.call @, aClass, aOptions
      @::unregister= (aName)-> @Class.unregister.call @, aName
      @::registered= (aName)-> Factory(aName)
      @::registeredClass= (aName)->
        aName = Factory.formatName aName
        result = @Class.hasOwnProperty(aName) and @Class[aName]
        return result if result
        aName  = Factory.getRealNameFromAlias.call @, aName
        return @Class.hasOwnProperty(aName) and @Class[aName] if aName
        return
      @::path = (aRootName)->
        '/' + @pathArray(aRootName).join '/'
      @::pathArray = (aRootName) ->Factory.pathArray(@Class, aRootName)

    inherits Factory, CustomFactory
