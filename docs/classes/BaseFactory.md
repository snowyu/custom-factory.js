[custom-factory](../README.md) / [Exports](../modules.md) / BaseFactory

# Class: BaseFactory

Abstract flat factory class

**`Abstract`**

## Hierarchy

- **`BaseFactory`**

  ↳ [`CustomFactory`](CustomFactory.md)

## Table of contents

### Constructors

- [constructor](BaseFactory.md#constructor)

### Properties

- [\_Factory](BaseFactory.md#_factory)
- [\_aliases](BaseFactory.md#_aliases)
- [\_baseNameOnly](BaseFactory.md#_basenameonly)
- [\_children](BaseFactory.md#_children)

### Accessors

- [Factory](BaseFactory.md#factory)
- [aliases](BaseFactory.md#aliases)

### Methods

- [initialize](BaseFactory.md#initialize)
- [\_findRootFactory](BaseFactory.md#_findrootfactory)
- [\_get](BaseFactory.md#_get)
- [\_register](BaseFactory.md#_register)
- [cleanAliases](BaseFactory.md#cleanaliases)
- [createObject](BaseFactory.md#createobject)
- [findRootFactory](BaseFactory.md#findrootfactory)
- [forEach](BaseFactory.md#foreach)
- [formatName](BaseFactory.md#formatname)
- [formatNameFromClass](BaseFactory.md#formatnamefromclass)
- [get](BaseFactory.md#get)
- [getAliases](BaseFactory.md#getaliases)
- [getDisplayName](BaseFactory.md#getdisplayname)
- [getNameFrom](BaseFactory.md#getnamefrom)
- [getRealNameFromAlias](BaseFactory.md#getrealnamefromalias)
- [register](BaseFactory.md#register)
- [registeredClass](BaseFactory.md#registeredclass)
- [removeAlias](BaseFactory.md#removealias)
- [setAlias](BaseFactory.md#setalias)
- [setAliases](BaseFactory.md#setaliases)
- [setDisplayName](BaseFactory.md#setdisplayname)
- [unregister](BaseFactory.md#unregister)

## Constructors

### constructor

• **new BaseFactory**(`...args`)

#### Parameters

| Name | Type |
| :------ | :------ |
| `...args` | `any` |

#### Defined in

[src/base-factory.js:618](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L618)

## Properties

### \_Factory

▪ `Static` **\_Factory**: typeof [`BaseFactory`](BaseFactory.md) = `undefined`

The Root Factory class

**`Name`**

_Factory

**`Abstract`**

#### Defined in

[src/base-factory.js:96](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L96)

___

### \_aliases

▪ `Static` **\_aliases**: [alias: string] = `undefined`

the registered alias items object.
the key is alias name, the value is the registered name

**`Abstract`**

#### Defined in

[src/base-factory.js:114](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L114)

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

#### Defined in

[src/base-factory.js:152](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L152)

___

### \_children

▪ `Static` **\_children**: `Object` = `undefined`

The registered classes in the Factory

**`Name`**

_children

**`Abstract`**

#### Index signature

▪ [name: `string`]: `any` \| typeof [`BaseFactory`](BaseFactory.md)

#### Defined in

[src/base-factory.js:105](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L105)

## Accessors

### Factory

• `Static` `get` **Factory**(): typeof [`BaseFactory`](BaseFactory.md)

The Root Factory class

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

#### Defined in

[src/base-factory.js:119](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L119)

___

### aliases

• `Static` `get` **aliases**(): `string`[]

the aliases of itself

#### Returns

`string`[]

#### Defined in

[src/base-factory.js:487](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L487)

• `Static` `set` **aliases**(`value`): `void`

#### Parameters

| Name | Type |
| :------ | :------ |
| `value` | `string`[] |

#### Returns

`void`

#### Defined in

[src/base-factory.js:491](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L491)

## Methods

### initialize

▸ **initialize**(`...args?`): `void`

initialize instance method

**`Abstract`**

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `...args?` | `any`[] | pass through all arguments coming from constructor |

#### Returns

`void`

#### Defined in

[src/base-factory.js:629](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L629)

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

#### Defined in

[src/base-factory.js:174](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L174)

___

### \_get

▸ `Static` **_get**(`name`): `any`

#### Parameters

| Name | Type |
| :------ | :------ |
| `name` | `any` |

#### Returns

`any`

#### Defined in

[src/base-factory.js:577](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L577)

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

#### Defined in

[src/base-factory.js:265](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L265)

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

#### Defined in

[src/base-factory.js:394](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L394)

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

#### Defined in

[src/base-factory.js:593](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L593)

___

### findRootFactory

▸ `Static` **findRootFactory**(): typeof [`BaseFactory`](BaseFactory.md)

find the real root factory

You can overwrite it to specify your root factory class
or set _Factory directly.

**`Abstract`**

#### Returns

typeof [`BaseFactory`](BaseFactory.md)

the root factory class

#### Defined in

[src/base-factory.js:163](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L163)

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

#### Defined in

[src/base-factory.js:549](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L549)

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

#### Defined in

[src/base-factory.js:202](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L202)

___

### formatNameFromClass

▸ `Static` **formatNameFromClass**(`aClass`, `aBaseNameOnly?`): `string`

format(transform) the name to be registered for the aClass

#### Parameters

| Name | Type |
| :------ | :------ |
| `aClass` | `any` |
| `aBaseNameOnly?` | `number` |

#### Returns

`string`

the name to register

#### Defined in

[src/base-factory.js:226](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L226)

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

#### Defined in

[src/base-factory.js:573](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L573)

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

#### Defined in

[src/base-factory.js:471](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L471)

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

#### Defined in

[src/base-factory.js:502](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L502)

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

#### Defined in

[src/base-factory.js:211](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L211)

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

#### Defined in

[src/base-factory.js:189](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L189)

___

### register

▸ `Static` **register**(`...args`): `boolean`

register the aClass to the factory

#### Parameters

| Name | Type |
| :------ | :------ |
| `...args` | `any` |

#### Returns

`boolean`

return true if successful.

#### Defined in

[src/base-factory.js:254](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L254)

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

#### Defined in

[src/base-factory.js:331](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L331)

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

#### Defined in

[src/base-factory.js:411](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L411)

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

#### Defined in

[src/base-factory.js:455](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L455)

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

#### Defined in

[src/base-factory.js:432](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L432)

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

#### Defined in

[src/base-factory.js:517](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L517)

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

#### Defined in

[src/base-factory.js:358](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L358)
