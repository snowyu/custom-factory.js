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

### Functions

- [getParentClass](modules.md#getparentclass)
- [isFunction](modules.md#isfunction)
- [isObject](modules.md#isobject)
- [isPureObject](modules.md#ispureobject)
- [isString](modules.md#isstring)

## Type Aliases

### ICustomFactoryOptions

Ƭ **ICustomFactoryOptions**<\>: `IBaseFactoryOptions` & { `baseNameOnly?`: `number` ; `parent?`: typeof [`CustomFactory`](classes/CustomFactory.md)  }

#### Defined in

[custom-factory.js:6](https://github.com/snowyu/custom-factory.js/blob/b940e0d/src/custom-factory.js#L6)

## Functions

### getParentClass

▸ **getParentClass**(`ctor`): `any`

get the parent class(ctor) of the ctor

#### Parameters

| Name | Type |
| :------ | :------ |
| `ctor` | `Function` |

#### Returns

`any`

the parent ctor

#### Defined in

[base-factory.js:30](https://github.com/snowyu/custom-factory.js/blob/b940e0d/src/base-factory.js#L30)

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

[base-factory.js:39](https://github.com/snowyu/custom-factory.js/blob/b940e0d/src/base-factory.js#L39)

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

[base-factory.js:55](https://github.com/snowyu/custom-factory.js/blob/b940e0d/src/base-factory.js#L55)

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

[base-factory.js:63](https://github.com/snowyu/custom-factory.js/blob/b940e0d/src/base-factory.js#L63)

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

[base-factory.js:47](https://github.com/snowyu/custom-factory.js/blob/b940e0d/src/base-factory.js#L47)
