[custom-factory](README.md) / Exports

# custom-factory

## Table of contents

### Classes

- [BaseFactory](classes/BaseFactory.md)
- [CustomFactory](classes/CustomFactory.md)

### Interfaces

- [IBaseFactoryOptions](interfaces/IBaseFactoryOptions.md)

### Type Aliases

- [ICustomFactoryOptions](modules.md#icustomfactoryoptions)

### Variables

- [coreMethods](modules.md#coremethods)

### Functions

- [addBaseFactoryAbility](modules.md#addbasefactoryability)
- [addFactoryAbility](modules.md#addfactoryability)
- [getParentClass](modules.md#getparentclass)
- [isFunction](modules.md#isfunction)
- [isObject](modules.md#isobject)
- [isPureObject](modules.md#ispureobject)
- [isString](modules.md#isstring)

## Type Aliases

### ICustomFactoryOptions

Ƭ **ICustomFactoryOptions**<\>: `IBaseFactoryOptions` & { `baseNameOnly?`: `number` ; `parent?`: typeof [`CustomFactory`](classes/CustomFactory.md)  }

#### Defined in

[src/custom-factory.js:6](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/custom-factory.js#L6)

## Variables

### coreMethods

• `Const` **coreMethods**: `string`[]

#### Defined in

[src/base-factory-ability.js:7](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory-ability.js#L7)

## Functions

### addBaseFactoryAbility

▸ **addBaseFactoryAbility**(`targetClass`, `options?`): `Function`

A function that adds(injects) the ability of a specified ability class to a target class.

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `targetClass` | `Function` | The target class to which the ability will be added. |
| `options?` | `AbilityOptions` | An optional ability configuration object. |

#### Returns

`Function`

- An injected target class that takes a class and adds the ability to it using the specified
                      options.

#### Defined in

node_modules/custom-ability/lib/custom-ability.d.ts:30

___

### addFactoryAbility

▸ **addFactoryAbility**(`targetClass`, `options?`): `Function`

A function that adds(injects) the ability of a specified ability class to a target class.

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `targetClass` | `Function` | The target class to which the ability will be added. |
| `options?` | `AbilityOptions` | An optional ability configuration object. |

#### Returns

`Function`

- An injected target class that takes a class and adds the ability to it using the specified
                      options.

#### Defined in

node_modules/custom-ability/lib/custom-ability.d.ts:30

___

### getParentClass

▸ **getParentClass**(`ctor`): `Function`

get the parent class(ctor) of the ctor

#### Parameters

| Name | Type |
| :------ | :------ |
| `ctor` | `Function` |

#### Returns

`Function`

the parent ctor

#### Defined in

node_modules/inherits-ex/lib/getSuperCtor.d.ts:6

___

### isFunction

▸ **isFunction**(`v`): `boolean`

Detect the value whether is a function

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `v` | `any` | the value to detect |

#### Returns

`boolean`

#### Defined in

[src/base-factory.js:35](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L35)

___

### isObject

▸ **isObject**(`v`): `boolean`

Detect the value whether is an object

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `v` | `any` | the value to detect |

#### Returns

`boolean`

#### Defined in

[src/base-factory.js:51](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L51)

___

### isPureObject

▸ **isPureObject**(`v`): `boolean`

Detect the object whether is a pure object(the ctor is Object)

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `v` | `any` | the value to detect |

#### Returns

`boolean`

#### Defined in

[src/base-factory.js:59](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L59)

___

### isString

▸ **isString**(`v`): `boolean`

Detect the value whether is a string

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `v` | `any` | the value to detect |

#### Returns

`boolean`

#### Defined in

[src/base-factory.js:43](https://github.com/snowyu/custom-factory.js/blob/bb4b1fd/src/base-factory.js#L43)
