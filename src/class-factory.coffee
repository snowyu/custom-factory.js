# Copyright (c) 2014-2019 Riceball LEE, MIT License
deprecate             = require('depd')('custom-factory')
inherits              = require('inherits-ex/lib/inherits')
isInheritedFrom       = require('inherits-ex/lib/isInheritedFrom')
createObject          = require('inherits-ex/lib/createObject')
getPrototypeOf        = require('inherits-ex/lib/getPrototypeOf')
customAbility         = require('custom-ability')
extend                = require('./extend')
{getFlatClassFactory} = require('./flat-class-factory')
isFunction            = (v)-> 'function' is typeof v
isString              = (v)-> 'string' is typeof v
isObject              = (v)-> v? and 'object' is typeof v
getObjectKeys         = Object.keys

getParentClass = (ctor)-> ctor.super_ || getPrototypeOf(ctor)

getClassFactoryable = (Factory, aOptions) ->
  ClassFactory = getFlatClassFactory(Factory, aOptions)

  if isObject aOptions
    baseNameOnly = aOptions.baseNameOnly if aOptions.baseNameOnly?
    registeredName = aOptions.registeredName if aOptions.registeredName?

  baseNameOnly ?= 1
  # Factory[registeredName] = {} if registeredName
  # hold all registered classes here
  registeredOnRoot = (registeredName && Factory[registeredName]) || Factory
  # Factory.ROOT_NAME = Factory.name

  extend ClassFactory,
    getClassList: (ctor)->
      result = while ctor and ctor isnt Factory
        item = ctor
        ctor = getParentClass ctor
        item
    getClassNameList: getClassNameList = (ctor)->
      result = while ctor and ctor isnt Factory
        item = ctor::name
        ctor = getParentClass ctor
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
        aParentClass = getParentClass(aClass) unless aParentClass
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

  ClassFactory

exports = module.exports = customAbility getFlatClassFactoryable, ['@register', '@getFactoryItem', '@formatName']

exports.getClassFactory = getClassFactoryable
