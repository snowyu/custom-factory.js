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

- [BaseFactoryCoreMethods](modules.md#basefactorycoremethods)
- [CustomFactoryCoreMethods](modules.md#customfactorycoremethods)
- [ObjectFactoryCoreMethods](modules.md#objectfactorycoremethods)

### Functions

- [addBaseFactoryAbility](modules.md#addbasefactoryability)
- [addFactoryAbility](modules.md#addfactoryability)
- [addObjectInstanceForFactoryAbility](modules.md#addobjectinstanceforfactoryability)
- [getParentClass](modules.md#getparentclass)
- [isFunction](modules.md#isfunction)
- [isObject](modules.md#isobject)
- [isPureObject](modules.md#ispureobject)
- [isString](modules.md#isstring)

## Type Aliases

### ICustomFactoryOptions

Ƭ **ICustomFactoryOptions**\<\>: `IBaseFactoryOptions` & \{ `baseNameOnly?`: `number` ; `parent?`: typeof [`CustomFactory`](classes/CustomFactory.md)  }

#### Defined in

[src/custom-factory.js:6](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/custom-factory.js#L6)

## Variables

### BaseFactoryCoreMethods

• `Const` **BaseFactoryCoreMethods**: `string`[]

#### Defined in

[src/base-factory-ability.js:7](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/base-factory-ability.js#L7)

___

### CustomFactoryCoreMethods

• `Const` **CustomFactoryCoreMethods**: `string`[]

#### Defined in

[src/custom-factory-ability.js:9](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/custom-factory-ability.js#L9)

___

### ObjectFactoryCoreMethods

• `Const` **ObjectFactoryCoreMethods**: `string`[]

#### Defined in

[src/object-factory-ability.js:48](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/object-factory-ability.js#L48)

## Functions

### addBaseFactoryAbility

▸ **addBaseFactoryAbility**(`targetClass`, `options?`): `Function`

#### Parameters

| Name | Type |
| :------ | :------ |
| `targetClass` | `Function` |
| `options?` | `AbilityOptions` |

#### Returns

`Function`

#### Defined in

node_modules/custom-ability/lib/custom-ability.d.ts:27

___

### addFactoryAbility

▸ **addFactoryAbility**(`targetClass`, `options?`): `Function`

#### Parameters

| Name | Type |
| :------ | :------ |
| `targetClass` | `Function` |
| `options?` | `AbilityOptions` |

#### Returns

`Function`

#### Defined in

node_modules/custom-ability/lib/custom-ability.d.ts:27

___

### addObjectInstanceForFactoryAbility

▸ **addObjectInstanceForFactoryAbility**(`targetClass`, `options?`): `Function`

Helper ability for factory, You must add a factory ability first.

#### Parameters

| Name | Type |
| :------ | :------ |
| `targetClass` | `Function` |
| `options?` | `AbilityOptions` |

#### Returns

`Function`

#### Defined in

node_modules/custom-ability/lib/custom-ability.d.ts:27

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

[src/base-factory.js:35](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/base-factory.js#L35)

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

[src/base-factory.js:51](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/base-factory.js#L51)

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

[src/base-factory.js:59](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/base-factory.js#L59)

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

[src/base-factory.js:43](https://github.com/snowyu/custom-factory.js/blob/1dd0708/src/base-factory.js#L43)
