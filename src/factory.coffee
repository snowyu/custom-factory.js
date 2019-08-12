isFunction            = require('util-ex/lib/is/type/function')
isString              = require('util-ex/lib/is/type/string')
isObject              = require('util-ex/lib/is/type/object')
inherits              = require('inherits-ex/lib/inherits')
isInheritedFrom       = require('inherits-ex/lib/isInheritedFrom')
extend                = require('./extend')
{ flatFactory }       = require('./flat-factory')
{ getClassList, getClassNameList } = require('./utils/get-class-list')

getFactoryable = (Factory, aOptions) ->
  class Factoriable
    flatFactory Factoriable

  if isObject aOptions
    baseNameOnly = aOptions.baseNameOnly if aOptions.baseNameOnly?
    registeredName = aOptions.registeredName if aOptions.registeredName?

  baseNameOnly ?= 1
  registeredOnRoot = (registeredName && Factory[registeredName]) || Factory

  extend Factoriable,
    path: (aClass, aRootName)->
      '/' + @pathArray(aClass, aRootName).join '/'
    pathArray: (aClass, aRootName) ->
      result = aClass::name
      return result.split('/').filter(Boolean) if result and result[0] is '/'
      aRootName = Factory.ROOT_NAME unless aRootName?
      result = getClassNameList(aClass, Factory)
      result.push aRootName if aRootName
      if Factory.formatName isnt formatName
        result = (Factory.formatName(i) for i in result)
      result.reverse()
    getNameFrom: (aClass)->
      if isFunction aClass
        #Factory.getNameFromClass(aClass)
        aClass::name
      else
        this.formatName aClass
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
        names = getClassNameList aParentClass, Factory
        names.push Factory.name
        if names.length
          for vFactoryName in names.reverse()
            if vFactoryName and vFactoryName.length and
               result.substring(len-vFactoryName.length) is vFactoryName
              result = result.substring(0, len-vFactoryName.length)
              len = result.length
            break unless --aBaseNameOnly
      Factory.formatName result
    getFactoryItem: (aName, aOptions)->
      result = registeredOnRoot[aName]
      if result is undefined
        # Is it an alias?
        aName = Factory.getRealNameFromAlias aName
        result = registeredOnRoot[aName] if aName
      result = undefined unless result and isInheritedFrom result, Factory
      result
    register: (aClass, aParentClass, aOptions)->
        if aParentClass
          if not isFunction aParentClass or not isInheritedFrom aParentClass, Factory
            aOptions = aParentClass
            aParentClass = aOptions.parent
            throw new TypeError('the parent hasn\'t registered yet.') if aParentClass && not isInheritedFrom aParentClass, Factory
            aParentClass = Factory if not aParentClass
        # else
        #   aParentClass = Factory
        # if aParentClass is Factory
        #   Factory._register aClass, aOptions
        # else
        #   aParentClass.register aClass, aOptions
        aParentClass = Factory unless aParentClass
        result = inherits aClass, aParentClass

  Factoriable
