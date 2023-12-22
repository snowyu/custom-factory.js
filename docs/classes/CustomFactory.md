[custom-factory](../README.md) / [Exports](../modules.md) / CustomFactory

# Class: CustomFactory

Abstract hierarchical factory class

## Hierarchy

- [`BaseFactory`](BaseFactory.md)

  ↳ **`CustomFactory`**

## Table of contents

### Constructors

- [constructor](CustomFactory.md#constructor)

### Properties

- [ROOT\_NAME](CustomFactory.md#root_name)
- [\_Factory](CustomFactory.md#_factory)
- [\_aliases](CustomFactory.md#_aliases)
- [\_baseNameOnly](CustomFactory.md#_basenameonly)
- [\_children](CustomFactory.md#_children)

### Accessors

- [Factory](CustomFactory.md#factory)
- [aliases](CustomFactory.md#aliases)

### Methods

- [initialize](CustomFactory.md#initialize)
- [\_findRootFactory](CustomFactory.md#_findrootfactory)
- [\_get](CustomFactory.md#_get)
- [\_register](CustomFactory.md#_register)
- [\_registerWithParent](CustomFactory.md#_registerwithparent)
- [cleanAliases](CustomFactory.md#cleanaliases)
- [createObject](CustomFactory.md#createobject)
- [findRootFactory](CustomFactory.md#findrootfactory)
- [forEach](CustomFactory.md#foreach)
- [formatName](CustomFactory.md#formatname)
- [formatNameFromClass](CustomFactory.md#formatnamefromclass)
- [get](CustomFactory.md#get)
- [getAliases](CustomFactory.md#getaliases)
- [getClassList](CustomFactory.md#getclasslist)
- [getClassNameList](CustomFactory.md#getclassnamelist)
- [getDisplayName](CustomFactory.md#getdisplayname)
- [getNameFrom](CustomFactory.md#getnamefrom)
- [getRealName](CustomFactory.md#getrealname)
- [getRealNameFromAlias](CustomFactory.md#getrealnamefromalias)
- [path](CustomFactory.md#path)
- [pathArray](CustomFactory.md#patharray)
- [register](CustomFactory.md#register)
- [registeredClass](CustomFactory.md#registeredclass)
- [removeAlias](CustomFactory.md#removealias)
- [setAlias](CustomFactory.md#setalias)
- [setAliases](CustomFactory.md#setaliases)
- [setDisplayName](CustomFactory.md#setdisplayname)
- [unregister](CustomFactory.md#unregister)

## Constructors

### constructor

• **new CustomFactory**(`...args`): [`CustomFactory`](CustomFactory.md)

#### Parameters

| Name | Type |
| :------ | :------ |
| `...args` | `any` |

#### Returns

[`CustomFactory`](CustomFactory.md)

#### Inherited from

[BaseFactory](BaseFactory.md).[constructor](BaseFactory.md#constructor)

#### Defined in

[src/base-factory.js:620](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L620)

## Properties

### ROOT\_NAME

▪ `Static` **ROOT\_NAME**: `string` = `undefined`

The Root Factory name

**`Abstract`**

**`Optional`**

#### Defined in

[src/custom-factory.js:39](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L39)

___

### \_Factory

▪ `Static` **\_Factory**: typeof [`BaseFactory`](BaseFactory.md) = `undefined`

The Root Factory class

**`Name`**

_Factory

**`Abstract`**

#### Inherited from

[BaseFactory](BaseFactory.md).[_Factory](BaseFactory.md#_factory)

#### Defined in

[src/base-factory.js:96](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L96)

___

### \_aliases

▪ `Static` **\_aliases**: [alias: string] = `undefined`

the registered alias items object.
the key is alias name, the value is the registered name

**`Abstract`**

#### Inherited from

[BaseFactory](BaseFactory.md).[_aliases](BaseFactory.md#_aliases)

#### Defined in

[src/base-factory.js:114](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L114)

___

### \_baseNameOnly

▪ `Static` **\_baseNameOnly**: `number` = `1`

Extracts a specified number of words from a PascalCase class name to use as a base name for registration,
only if no `name` is specified. The parameter value indicates the maximum depth of the word extraction.

In JavaScript, class names use `PascalCase` convention where each word starts with a capital letter.
The baseNameOnly parameter is a number that specifies which words to extract from the class name as the base name.
If the value is 1, it extracts the first word, 2 extracts the first two words, and 0 uses the entire class name.
The base name is used to register the class to the factory.

**`Example`**

```ts
such as "JsonTextCodec" if baseNameOnly is 1, the first word "Json" will be extracted from "JsonTextCodec" as
  the base name. If baseNameOnly is 2, the first two words "JsonText" will be extracted as the base name. If
  baseNameOnly is 0, the entire class name "JsonTextCodec" will be used as the base name.
```

**`Name`**

_baseNameOnly

**`Default`**

```ts
1
@internal
```

#### Inherited from

[BaseFactory](BaseFactory.md).[_baseNameOnly](BaseFactory.md#_basenameonly)

#### Defined in

[src/base-factory.js:152](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L152)

___

### \_children

▪ `Static` **\_children**: `Object` = `undefined`

The registered classes in the Factory

**`Name`**

_children

**`Abstract`**

#### Index signature

▪ [name: `string`]: `any` \| typeof [`BaseFactory`](BaseFactory.md)

#### Inherited from

[BaseFactory](BaseFactory.md).[_children](BaseFactory.md#_children)

#### Defined in

[src/base-factory.js:105](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L105)

## Accessors

### Factory

• `get` **Factory**(): typeof [`BaseFactory`](BaseFactory.md)

The Root Factory class

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

#### Inherited from

BaseFactory.Factory

#### Defined in

[src/base-factory.js:119](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L119)

___

### aliases

• `get` **aliases**(): `string`[]

the aliases of itself

#### Returns

`string`[]

#### Inherited from

BaseFactory.aliases

#### Defined in

[src/base-factory.js:491](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L491)

• `set` **aliases**(`value`): `void`

#### Parameters

| Name | Type |
| :------ | :------ |
| `value` | `string`[] |

#### Returns

`void`

#### Inherited from

BaseFactory.aliases

#### Defined in

[src/base-factory.js:495](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L495)

## Methods

### initialize

▸ **initialize**(`...args?`): `void`

initialize instance method

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `...args?` | `any`[] | pass through all arguments coming from constructor |

#### Returns

`void`

**`Abstract`**

#### Inherited from

[BaseFactory](BaseFactory.md).[initialize](BaseFactory.md#initialize)

#### Defined in

[src/base-factory.js:631](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L631)

___

### \_findRootFactory

▸ **_findRootFactory**(`aClass`): typeof [`BaseFactory`](BaseFactory.md)

find the real root factory

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | typeof [`BaseFactory`](BaseFactory.md) | the abstract root factory class |

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

#### Inherited from

[BaseFactory](BaseFactory.md).[_findRootFactory](BaseFactory.md#_findrootfactory)

#### Defined in

[src/base-factory.js:174](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L174)

___

### \_get

▸ **_get**(`name`): `any`

#### Parameters

| Name | Type |
| :------ | :------ |
| `name` | `any` |

#### Returns

`any`

#### Inherited from

[BaseFactory](BaseFactory.md).[_get](BaseFactory.md#_get)

#### Defined in

[src/base-factory.js:581](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L581)

___

### \_register

▸ **_register**(`aClass`, `aOptions?`): `boolean`

register the aClass to the factory

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | typeof [`BaseFactory`](BaseFactory.md) | the class to register the Factory |
| `aOptions?` | `any` | the options for the class and the factory |

#### Returns

`boolean`

return true if successful.

#### Inherited from

[BaseFactory](BaseFactory.md).[_register](BaseFactory.md#_register)

#### Defined in

[src/base-factory.js:273](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L273)

___

### \_registerWithParent

▸ **_registerWithParent**(`aClass`, `aParentClass`, `aOptions`): `any`

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aParentClass` | `any` |
| `aOptions` | `any` |

#### Returns

`any`

#### Defined in

[src/custom-factory.js:162](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L162)

___

### cleanAliases

▸ **cleanAliases**(`aName`): `void`

remove all aliases of the registered item or itself

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aName` | `string` \| typeof [`BaseFactory`](BaseFactory.md) | the registered item or name |

#### Returns

`void`

#### Inherited from

[BaseFactory](BaseFactory.md).[cleanAliases](BaseFactory.md#cleanaliases)

#### Defined in

[src/base-factory.js:398](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L398)

___

### createObject

▸ **createObject**(`aName`, `aOptions`): [`BaseFactory`](BaseFactory.md)

Create a new object instance of Factory

#### Parameters

| Name | Type |
| :------ | :------ |
| `aName` | `string` \| [`BaseFactory`](BaseFactory.md) |
| `aOptions` | `any` |

#### Returns

[`BaseFactory`](BaseFactory.md)

#### Inherited from

[BaseFactory](BaseFactory.md).[createObject](BaseFactory.md#createobject)

#### Defined in

[src/base-factory.js:595](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L595)

___

### findRootFactory

▸ **findRootFactory**(): typeof [`BaseFactory`](BaseFactory.md)

find the real root factory

You can overwrite it to specify your root factory class
or set _Factory directly.

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

the root factory class

**`Abstract`**

#### Overrides

[BaseFactory](BaseFactory.md).[findRootFactory](BaseFactory.md#findrootfactory)

#### Defined in

[src/custom-factory.js:42](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L42)

___

### forEach

▸ **forEach**(`cb`): `any`

executes a provided callback function once for each registered element.

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `cb` | `FactoryClassForEachFn` | the forEach callback function |

#### Returns

`any`

#### Inherited from

[BaseFactory](BaseFactory.md).[forEach](BaseFactory.md#foreach)

#### Defined in

[src/base-factory.js:553](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L553)

___

### formatName

▸ **formatName**(`aName`): `string`

format(transform) the name to be registered.

defaults to returning the name unchanged. By overloading this method, case-insensitive names can be achieved.

#### Parameters

| Name | Type |
| :------ | :------ |
| `aName` | `string` |

#### Returns

`string`

**`Abstract`**

#### Inherited from

[BaseFactory](BaseFactory.md).[formatName](BaseFactory.md#formatname)

#### Defined in

[src/base-factory.js:210](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L210)

___

### formatNameFromClass

▸ **formatNameFromClass**(`aClass`, `aParentClass?`, `aBaseNameOnly?`): `string`

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aParentClass?` | `any` |
| `aBaseNameOnly?` | `number` |

#### Returns

`string`

#### Overrides

[BaseFactory](BaseFactory.md).[formatNameFromClass](BaseFactory.md#formatnamefromclass)

#### Defined in

[src/custom-factory.js:75](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L75)

___

### get

▸ **get**(`name`): typeof [`BaseFactory`](BaseFactory.md)

Get the registered class via name

#### Parameters

| Name | Type |
| :------ | :------ |
| `name` | `any` |

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

return the registered class if found the name

#### Inherited from

[BaseFactory](BaseFactory.md).[get](BaseFactory.md#get)

#### Defined in

[src/base-factory.js:577](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L577)

___

### getAliases

▸ **getAliases**(`aClass`): `string`[]

get the aliases of the aClass

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | `string` \| typeof [`BaseFactory`](BaseFactory.md) | the class or name to get aliases, means itself if no aClass specified |

#### Returns

`string`[]

aliases

#### Inherited from

[BaseFactory](BaseFactory.md).[getAliases](BaseFactory.md#getaliases)

#### Defined in

[src/base-factory.js:475](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L475)

___

### getClassList

▸ **getClassList**(`ctor`): `any`[]

#### Parameters

| Name | Type |
| :------ | :------ |
| `ctor` | `any` |

#### Returns

`any`[]

#### Defined in

[src/custom-factory.js:46](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L46)

___

### getClassNameList

▸ **getClassNameList**(`ctor`): `any`[]

#### Parameters

| Name | Type |
| :------ | :------ |
| `ctor` | `any` |

#### Returns

`any`[]

#### Defined in

[src/custom-factory.js:57](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L57)

___

### getDisplayName

▸ **getDisplayName**(`aClass`): `string`

Get the display name from aClass

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | `string` \| `Function` | the class, name or itself, means itself if no aClass |

#### Returns

`string`

#### Inherited from

[BaseFactory](BaseFactory.md).[getDisplayName](BaseFactory.md#getdisplayname)

#### Defined in

[src/base-factory.js:506](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L506)

___

### getNameFrom

▸ **getNameFrom**(`aClass`): `string`

Get the unique(registered) name in the factory

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `string` \| `Function` |

#### Returns

`string`

the unique name in the factory

#### Inherited from

[BaseFactory](BaseFactory.md).[getNameFrom](BaseFactory.md#getnamefrom)

#### Defined in

[src/base-factory.js:219](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L219)

___

### getRealName

▸ **getRealName**(`name`): `any`

#### Parameters

| Name | Type |
| :------ | :------ |
| `name` | `any` |

#### Returns

`any`

#### Inherited from

[BaseFactory](BaseFactory.md).[getRealName](BaseFactory.md#getrealname)

#### Defined in

[src/base-factory.js:184](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L184)

___

### getRealNameFromAlias

▸ **getRealNameFromAlias**(`alias`): `string`

get the unique name in the factory from an alias name

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `alias` | `string` | the alias name |

#### Returns

`string`

the unique name in the factory

#### Inherited from

[BaseFactory](BaseFactory.md).[getRealNameFromAlias](BaseFactory.md#getrealnamefromalias)

#### Defined in

[src/base-factory.js:197](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L197)

___

### path

▸ **path**(`aClass`, `aRootName`): `string`[]

get path of a class or itself

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aRootName` | `any` |

#### Returns

`string`[]

#### Defined in

[src/custom-factory.js:124](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L124)

___

### pathArray

▸ **pathArray**(`aClass`, `aRootName`): `string`[]

get path array of a class or itself

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aRootName` | `any` |

#### Returns

`string`[]

#### Defined in

[src/custom-factory.js:134](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L134)

___

### register

▸ **register**(`aClass`, `aParentClass`, `aOptions`): `boolean`

register the aClass to the factory

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | typeof [`CustomFactory`](CustomFactory.md) | the class to register the Factory |
| `aParentClass` | typeof [`CustomFactory`](CustomFactory.md) \| [`ICustomFactoryOptions`](../modules.md#icustomfactoryoptions) | the optional parent class |
| `aOptions` | `any` | the options for the class and the factory |

#### Returns

`boolean`

return true if successful.

#### Overrides

[BaseFactory](BaseFactory.md).[register](BaseFactory.md#register)

#### Defined in

[src/custom-factory.js:177](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/custom-factory.js#L177)

___

### registeredClass

▸ **registeredClass**(`aName`): ``false`` \| typeof [`BaseFactory`](BaseFactory.md)

Check the name, alias or itself whether registered.

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aName` | `string` | the class name |

#### Returns

``false`` \| typeof [`BaseFactory`](BaseFactory.md)

the registered class if registered, otherwise returns false

#### Inherited from

[BaseFactory](BaseFactory.md).[registeredClass](BaseFactory.md#registeredclass)

#### Defined in

[src/base-factory.js:339](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L339)

___

### removeAlias

▸ **removeAlias**(`...aliases`): `void`

remove specified aliases

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `...aliases` | `string`[] | the aliases to remove |

#### Returns

`void`

#### Inherited from

[BaseFactory](BaseFactory.md).[removeAlias](BaseFactory.md#removealias)

#### Defined in

[src/base-factory.js:415](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L415)

___

### setAlias

▸ **setAlias**(`aClass`, `alias`): `void`

set alias to a class

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | `string` \| typeof [`BaseFactory`](BaseFactory.md) | the class to set alias |
| `alias` | `string` |  |

#### Returns

`void`

#### Inherited from

[BaseFactory](BaseFactory.md).[setAlias](BaseFactory.md#setalias)

#### Defined in

[src/base-factory.js:459](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L459)

___

### setAliases

▸ **setAliases**(`aClass`, `...aAliases`): `void`

set aliases to a class

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | `string` \| typeof [`BaseFactory`](BaseFactory.md) | the class to set aliases |
| `...aAliases` | `any`[] | - |

#### Returns

`void`

**`Example`**

```ts
import { BaseFactory } from 'custom-factory'
  class Factory extends BaseFactory {}
  const register = Factory.register.bind(Factory)
  const aliases = Factory.setAliases.bind(Factory)
  class MyFactory {}
  register(MyFactory)
  aliases(MyFactory, 'my', 'MY')
```

#### Inherited from

[BaseFactory](BaseFactory.md).[setAliases](BaseFactory.md#setaliases)

#### Defined in

[src/base-factory.js:436](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L436)

___

### setDisplayName

▸ **setDisplayName**(`aClass`, `aDisplayName`): `void`

Set the display name to the aClass

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | `string` \| `Function` | the class, name or itself, means itself if no aClass |
| `aDisplayName` | `string` \| \{ `displayName`: `string`  } | the display name to set |

#### Returns

`void`

#### Inherited from

[BaseFactory](BaseFactory.md).[setDisplayName](BaseFactory.md#setdisplayname)

#### Defined in

[src/base-factory.js:521](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L521)

___

### unregister

▸ **unregister**(`aName`): `boolean`

unregister this class in the factory

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aName` | `string` \| `Function` | the registered name or class, no name means unregister itself. |

#### Returns

`boolean`

true means successful

#### Inherited from

[BaseFactory](BaseFactory.md).[unregister](BaseFactory.md#unregister)

#### Defined in

[src/base-factory.js:366](https://github.com/snowyu/custom-factory.js/blob/7469d19/src/base-factory.js#L366)
