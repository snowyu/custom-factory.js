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

• **new CustomFactory**(`...args`)

#### Parameters

| Name | Type |
| :------ | :------ |
| `...args` | `any` |

#### Inherited from

[BaseFactory](BaseFactory.md).[constructor](BaseFactory.md#constructor)

#### Defined in

[base-factory.js:616](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L616)

## Properties

### ROOT\_NAME

▪ `Static` **ROOT\_NAME**: `string` = `undefined`

The Root Factory name

**`Abstract`**

**`Optional`**

#### Defined in

[custom-factory.js:39](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L39)

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

[base-factory.js:100](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L100)

___

### \_aliases

▪ `Static` **\_aliases**: [alias: string] = `undefined`

the registered alias items object.
the key is alias name, the value is the registered name

**`Abstract`**

#### Inherited from

[BaseFactory](BaseFactory.md).[_aliases](BaseFactory.md#_aliases)

#### Defined in

[base-factory.js:118](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L118)

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

[base-factory.js:152](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L152)

___

### \_children

▪ `Static` **\_children**: `Object` = `undefined`

The registered classes in the Factory

**`Name`**

_children

**`Abstract`**

#### Index signature

▪ [name: `string`]: typeof [`BaseFactory`](BaseFactory.md)

#### Inherited from

[BaseFactory](BaseFactory.md).[_children](BaseFactory.md#_children)

#### Defined in

[base-factory.js:109](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L109)

## Accessors

### Factory

• `Static` `get` **Factory**(): typeof [`BaseFactory`](BaseFactory.md)

The Root Factory class

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

#### Inherited from

BaseFactory.Factory

#### Defined in

[base-factory.js:123](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L123)

___

### aliases

• `Static` `get` **aliases**(): `string`[]

the aliases of itself

#### Returns

`string`[]

#### Inherited from

BaseFactory.aliases

#### Defined in

[base-factory.js:485](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L485)

• `Static` `set` **aliases**(`value`): `void`

#### Parameters

| Name | Type |
| :------ | :------ |
| `value` | `string`[] |

#### Returns

`void`

#### Inherited from

BaseFactory.aliases

#### Defined in

[base-factory.js:489](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L489)

## Methods

### initialize

▸ **initialize**(): `void`

initialize instance method

**`Abstract`**

#### Returns

`void`

#### Inherited from

[BaseFactory](BaseFactory.md).[initialize](BaseFactory.md#initialize)

#### Defined in

[base-factory.js:627](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L627)

___

### \_findRootFactory

▸ `Static` **_findRootFactory**(`aClass`): typeof [`BaseFactory`](BaseFactory.md)

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

[base-factory.js:172](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L172)

___

### \_get

▸ `Static` **_get**(`name`): typeof [`BaseFactory`](BaseFactory.md)

#### Parameters

| Name | Type |
| :------ | :------ |
| `name` | `any` |

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

#### Inherited from

[BaseFactory](BaseFactory.md).[_get](BaseFactory.md#_get)

#### Defined in

[base-factory.js:575](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L575)

___

### \_register

▸ `Static` **_register**(`aClass`, `aOptions?`): `boolean`

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

[base-factory.js:263](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L263)

___

### \_registerWithParent

▸ `Static` **_registerWithParent**(`aClass`, `aParentClass`, `aOptions`): `any`

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aParentClass` | `any` |
| `aOptions` | `any` |

#### Returns

`any`

#### Defined in

[custom-factory.js:156](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L156)

___

### cleanAliases

▸ `Static` **cleanAliases**(`aName`): `void`

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

[base-factory.js:392](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L392)

___

### createObject

▸ `Static` **createObject**(`aName`, `aOptions`): [`BaseFactory`](BaseFactory.md)

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

[base-factory.js:591](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L591)

___

### findRootFactory

▸ `Static` **findRootFactory**(): typeof [`BaseFactory`](BaseFactory.md)

find the real root factory

You can overwrite it to specify your root factory class

**`Abstract`**

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

the root factory class

#### Overrides

[BaseFactory](BaseFactory.md).[findRootFactory](BaseFactory.md#findrootfactory)

#### Defined in

[custom-factory.js:42](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L42)

___

### forEach

▸ `Static` **forEach**(`cb`): `any`

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

[base-factory.js:547](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L547)

___

### formatName

▸ `Static` **formatName**(`aName`): `string`

format(transform) the name to be registered.

defaults to returning the name unchanged. By overloading this method, case-insensitive names can be achieved.

**`Abstract`**

#### Parameters

| Name | Type |
| :------ | :------ |
| `aName` | `string` |

#### Returns

`string`

#### Inherited from

[BaseFactory](BaseFactory.md).[formatName](BaseFactory.md#formatname)

#### Defined in

[base-factory.js:200](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L200)

___

### formatNameFromClass

▸ `Static` **formatNameFromClass**(`aClass`, `aParentClass`, `aBaseNameOnly`): `string`

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aParentClass` | `any` |
| `aBaseNameOnly` | `any` |

#### Returns

`string`

#### Overrides

[BaseFactory](BaseFactory.md).[formatNameFromClass](BaseFactory.md#formatnamefromclass)

#### Defined in

[custom-factory.js:69](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L69)

___

### get

▸ `Static` **get**(`name`): typeof [`BaseFactory`](BaseFactory.md)

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

[base-factory.js:571](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L571)

___

### getAliases

▸ `Static` **getAliases**(`aClass`): `string`[]

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

[base-factory.js:469](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L469)

___

### getClassList

▸ `Static` **getClassList**(`ctor`): `any`[]

#### Parameters

| Name | Type |
| :------ | :------ |
| `ctor` | `any` |

#### Returns

`any`[]

#### Defined in

[custom-factory.js:46](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L46)

___

### getClassNameList

▸ `Static` **getClassNameList**(`ctor`): `any`[]

#### Parameters

| Name | Type |
| :------ | :------ |
| `ctor` | `any` |

#### Returns

`any`[]

#### Defined in

[custom-factory.js:57](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L57)

___

### getDisplayName

▸ `Static` **getDisplayName**(`aClass`): `string`

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

[base-factory.js:500](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L500)

___

### getNameFrom

▸ `Static` **getNameFrom**(`aClass`): `string`

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

[base-factory.js:209](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L209)

___

### getRealNameFromAlias

▸ `Static` **getRealNameFromAlias**(`alias`): `string`

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

[base-factory.js:187](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L187)

___

### path

▸ `Static` **path**(`aClass`, `aRootName`): `string`[]

get path of a class or itself

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aRootName` | `any` |

#### Returns

`string`[]

#### Defined in

[custom-factory.js:118](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L118)

___

### pathArray

▸ `Static` **pathArray**(`aClass`, `aRootName`): `string`[]

get path array of a class or itself

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aRootName` | `any` |

#### Returns

`string`[]

#### Defined in

[custom-factory.js:128](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L128)

___

### register

▸ `Static` **register**(`aClass`, `aParentClass`, `aOptions`): `boolean`

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

[custom-factory.js:171](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/custom-factory.js#L171)

___

### registeredClass

▸ `Static` **registeredClass**(`aName`): ``false`` \| typeof [`BaseFactory`](BaseFactory.md)

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

[base-factory.js:329](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L329)

___

### removeAlias

▸ `Static` **removeAlias**(`...aliases`): `void`

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

[base-factory.js:409](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L409)

___

### setAlias

▸ `Static` **setAlias**(`aClass`, `alias`): `void`

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

[base-factory.js:453](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L453)

___

### setAliases

▸ `Static` **setAliases**(`aClass`, `...aAliases`): `void`

set aliases to a class

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

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | `string` \| typeof [`BaseFactory`](BaseFactory.md) | the class to set aliases |
| `...aAliases` | `any`[] | - |

#### Returns

`void`

#### Inherited from

[BaseFactory](BaseFactory.md).[setAliases](BaseFactory.md#setaliases)

#### Defined in

[base-factory.js:430](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L430)

___

### setDisplayName

▸ `Static` **setDisplayName**(`aClass`, `aDisplayName`): `void`

Set the display name to the aClass

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `aClass` | `string` \| `Function` | the class, name or itself, means itself if no aClass |
| `aDisplayName` | `string` \| { `displayName`: `string`  } | the display name to set |

#### Returns

`void`

#### Inherited from

[BaseFactory](BaseFactory.md).[setDisplayName](BaseFactory.md#setdisplayname)

#### Defined in

[base-factory.js:515](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L515)

___

### unregister

▸ `Static` **unregister**(`aName`): `boolean`

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

[base-factory.js:356](https://github.com/snowyu/custom-factory.js/blob/4ef6485/src/base-factory.js#L356)
