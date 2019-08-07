customAbility         = require('custom-ability')
isInheritedFrom       = require('inherits-ex/lib/isInheritedFrom')
isFunction            = require('util-ex/lib/is/type/function')
isString              = require('util-ex/lib/is/type/string')
isObject              = require('util-ex/lib/is/type/object')
defineProperty        = require 'util-ex/lib/defineProperty'
getKeyByValue         = require('./utils/get-key-by-value')
getObjectKeys         = Object.keys

class FlatFactoriable
  # define non-enumerable properties:
  @__aliases: {}
  @getRealNameFromAlias: (alias)-> @__aliases[alias]
  @formatName: (aName)->aName
  @getFactoryItem: (aName, aOptions)->
    result = this[aName]
    if result is undefined and @__aliases
      # Is it an alias?
      aName = this.getRealNameFromAlias aName
      result = this[aName] if aName
    result
  @register: (aItem, aOptions)->
    throw new Error('registered item should not be undefined') if aItem is undefined
    if isString aOptions
      vName = aOptions
    else if aOptions
      vName = aOptions.name
      vDisplayName = aOptions.displayName
    vTypeItem = typeof aItem
    if not vName
      if vTypeItem is 'object' or vTypeItem is 'function'
        vName = aItem.name || aItem['名']
        if vName
          vFactoryName = @name
          len = vName.length
          vLen = vFactoryName.length
          if vName.substring(len - vLen) is vFactoryName
            vName = vName.substring(0, len - vLen)
      unless vName
        throw new TypeError('The registered item should have a name.')
    vName = @formatName vName
    result = @getFactoryItem(vName)

    throw new TypeError(
      'the ' + vName + ' has already been registered.'
    ) unless result is undefined

    if vTypeItem is 'object' or vTypeItem is 'function'
      aItem::name = vName
      aItem::_displayName = vDisplayName if vDisplayName
    this[vName] = aItem
    @
  @unregister: (aName)->
    if isString aName
      aName = @formatName aName
      vItem = @hasOwnProperty(aName) and this[aName]
    else
      vItem = aName
      aName = getKeyByValue(this, vItem)
    if aName
      delete this[aName]
      if @__aliases
        for k, v of @__aliases
          delete @__aliases[k] if v is aName
    !!aName
  @forEach: (cb)->
    if isFunction cb
      for k in getObjectKeys @
        v = this[k]
        break if cb(v, k) == 'brk'
    @
  @aliases: (aItem, aAliases...)->
    vItemName = getKeyByValue(this, aItem)
    throw new Error('This item is not registered!') unless vItemName
    if aAliases.length
      for alias in aAliases.map this.formatName
        @__aliases[alias] = vItemName
      @
    else
      result = []
      for k,v of @__aliases
        result.push k if v is vItemName
      result
  @_constructor: (aName, aOptions)->
    if aName instanceof FlatFactory
      # do not initialize if no aOptions
      aName.initialize aOptions if aOptions? && isFunction aName.initialize
      return aName
    if aName
      if isObject aName
        aOptions = aName
        aName = aOptions.name
      else if not isString aName
        aOptions = aName
        aName = undefined
    if not (this instanceof FlatFactory)
      # arguments.callee is forbidden if strict mode enabled.
      # get real factory which store registered items.
      try vFactory = arguments.callee.caller.caller
      return unless vFactory and isInheritedFrom vFactory, FlatFactory
      if not aName
        # hierarchical factory usage:
        # var textCodec = TextCodec() 因为是复用的ctor，所以需要这样来得到真实的调用方。
        aName = vFactory
        vCaller = vFactory.caller
        #get farest hierarchical registered class
        while isInheritedFrom vCaller, aName
          aName = vCaller
          vCaller = vCaller.caller
        #aName = Factory.getNameFromClass(aName) if aName
        aName = aName::name || aName.name if aName
        return unless aName
      else
        aName = vFactory.formatName aName
      return vFactory.getFactoryItem aName, aOptions
    else if isFunction @initialize
        @initialize(aOptions)

flatFactory = customAbility FlatFactoriable, ['@register', '@getFactoryItem', '@formatName']
flatFactory.flatFactory = flatFactory

module.exports.FlatFactory = class FlatFactory
  flatFactory FlatFactory
  constructor: (aName, aOptions)-> return FlatFactory._constructor.apply(this, arguments)
module.exports.flatFactory = flatFactory

