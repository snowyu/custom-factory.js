[**custom-factory**](../README.md)

***

[custom-factory](../globals.md) / CustomFactory

# Class: CustomFactory

Defined in: [src/custom-factory.js:32](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L32)

Abstract hierarchical factory class

## Extends

- [`BaseFactory`](BaseFactory.md)

## Constructors

### Constructor

> **new CustomFactory**(...`args`): `CustomFactory`

Defined in: [src/base-factory.js:620](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L620)

#### Parameters

##### args

...`any`[]

#### Returns

`CustomFactory`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`constructor`](BaseFactory.md#constructor)

## Properties

### \_aliases

> `abstract` `static` **\_aliases**: \[`string`\] = `undefined`

Defined in: [src/base-factory.js:114](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L114)

**`Internal`**

the registered alias items object.
the key is alias name, the value is the registered name

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`_aliases`](BaseFactory.md#_aliases)

***

### \_baseNameOnly

> `static` **\_baseNameOnly**: `number` = `1`

Defined in: [src/base-factory.js:152](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L152)

**`Internal`**

Extracts a specified number of words from a PascalCase class name to use as a base name for registration,
only if no `name` is specified. The parameter value indicates the maximum depth of the word extraction.

In JavaScript, class names use `PascalCase` convention where each word starts with a capital letter.
The baseNameOnly parameter is a number that specifies which words to extract from the class name as the base name.
If the value is 1, it extracts the first word, 2 extracts the first two words, and 0 uses the entire class name.
The base name is used to register the class to the factory.

#### Example

```ts
such as "JsonTextCodec" if baseNameOnly is 1, the first word "Json" will be extracted from "JsonTextCodec" as
  the base name. If baseNameOnly is 2, the first two words "JsonText" will be extracted as the base name. If
  baseNameOnly is 0, the entire class name "JsonTextCodec" will be used as the base name.
```

#### Name

_baseNameOnly

#### Default

```ts
1
@internal
```

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`_baseNameOnly`](BaseFactory.md#_basenameonly)

***

### \_children

> `abstract` `static` **\_children**: `object` = `undefined`

Defined in: [src/base-factory.js:105](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L105)

**`Internal`**

The registered classes in the Factory

#### Index Signature

\[`name`: `string`\]: `any`

#### Name

_children

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`_children`](BaseFactory.md#_children)

***

### \_Factory

> `abstract` `static` **\_Factory**: *typeof* [`BaseFactory`](BaseFactory.md) = `undefined`

Defined in: [src/base-factory.js:96](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L96)

**`Internal`**

The Root Factory class

#### Name

_Factory

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`_Factory`](BaseFactory.md#_factory)

***

### ROOT\_NAME

> `abstract` `static` **ROOT\_NAME**: `string` = `undefined`

Defined in: [src/custom-factory.js:39](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L39)

The Root Factory name

#### Optional

## Accessors

### aliases

#### Get Signature

> **get** `static` **aliases**(): `string`[]

Defined in: [src/base-factory.js:491](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L491)

the aliases of itself

##### Returns

`string`[]

#### Set Signature

> **set** `static` **aliases**(`value`): `void`

Defined in: [src/base-factory.js:495](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L495)

##### Parameters

###### value

`string`[]

##### Returns

`void`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`aliases`](BaseFactory.md#aliases)

***

### Factory

#### Get Signature

> **get** `static` **Factory**(): *typeof* [`BaseFactory`](BaseFactory.md)

Defined in: [src/base-factory.js:119](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L119)

The Root Factory class

##### Returns

*typeof* [`BaseFactory`](BaseFactory.md)

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`Factory`](BaseFactory.md#factory)

## Methods

### initialize()

> `abstract` **initialize**(...`args?`): `void`

Defined in: [src/base-factory.js:631](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L631)

**`Internal`**

initialize instance method

#### Parameters

##### args?

...`any`[]

pass through all arguments coming from constructor

#### Returns

`void`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`initialize`](BaseFactory.md#initialize)

***

### \_findRootFactory()

> `static` **\_findRootFactory**(`aClass`): *typeof* [`BaseFactory`](BaseFactory.md)

Defined in: [src/base-factory.js:174](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L174)

**`Internal`**

find the real root factory

#### Parameters

##### aClass

*typeof* [`BaseFactory`](BaseFactory.md)

the abstract root factory class

#### Returns

*typeof* [`BaseFactory`](BaseFactory.md)

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`_findRootFactory`](BaseFactory.md#_findrootfactory)

***

### \_get()

> `static` **\_get**(`name`): `any`

Defined in: [src/base-factory.js:581](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L581)

#### Parameters

##### name

`any`

#### Returns

`any`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`_get`](BaseFactory.md#_get)

***

### \_register()

> `static` **\_register**(`aClass`, `aOptions?`): `boolean`

Defined in: [src/base-factory.js:273](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L273)

**`Internal`**

register the aClass to the factory

#### Parameters

##### aClass

*typeof* [`BaseFactory`](BaseFactory.md)

the class to register the Factory

##### aOptions?

`any`

the options for the class and the factory

#### Returns

`boolean`

return true if successful.

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`_register`](BaseFactory.md#_register)

***

### \_registerWithParent()

> `static` **\_registerWithParent**(`aClass`, `aParentClass`, `aOptions`): `any`

Defined in: [src/custom-factory.js:162](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L162)

#### Parameters

##### aClass

`any`

##### aParentClass

`any`

##### aOptions

`any`

#### Returns

`any`

***

### cleanAliases()

> `static` **cleanAliases**(`aName`): `void`

Defined in: [src/base-factory.js:398](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L398)

remove all aliases of the registered item or itself

#### Parameters

##### aName

the registered item or name

`string` | *typeof* [`BaseFactory`](BaseFactory.md)

#### Returns

`void`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`cleanAliases`](BaseFactory.md#cleanaliases)

***

### createObject()

> `static` **createObject**(`aName`, `aOptions`): [`BaseFactory`](BaseFactory.md)

Defined in: [src/base-factory.js:595](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L595)

Create a new object instance of Factory

#### Parameters

##### aName

`string` | [`BaseFactory`](BaseFactory.md)

##### aOptions

`any`

#### Returns

[`BaseFactory`](BaseFactory.md)

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`createObject`](BaseFactory.md#createobject)

***

### findRootFactory()

> `abstract` `static` **findRootFactory**(): *typeof* [`BaseFactory`](BaseFactory.md)

Defined in: [src/custom-factory.js:42](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L42)

**`Internal`**

find the real root factory

You can overwrite it to specify your root factory class
or set _Factory directly.

#### Returns

*typeof* [`BaseFactory`](BaseFactory.md)

the root factory class

#### Overrides

[`BaseFactory`](BaseFactory.md).[`findRootFactory`](BaseFactory.md#findrootfactory)

***

### forEach()

> `static` **forEach**(`cb`): `any`

Defined in: [src/base-factory.js:553](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L553)

executes a provided callback function once for each registered element.

#### Parameters

##### cb

`FactoryClassForEachFn`

the forEach callback function

#### Returns

`any`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`forEach`](BaseFactory.md#foreach)

***

### formatName()

> `abstract` `static` **formatName**(`aName`): `string`

Defined in: [src/base-factory.js:210](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L210)

**`Internal`**

format(transform) the name to be registered.

defaults to returning the name unchanged. By overloading this method, case-insensitive names can be achieved.

#### Parameters

##### aName

`string`

#### Returns

`string`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`formatName`](BaseFactory.md#formatname)

***

### formatNameFromClass()

> `static` **formatNameFromClass**(`aClass`, `aParentClass?`, `aBaseNameOnly?`): `string`

Defined in: [src/custom-factory.js:75](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L75)

**`Internal`**

#### Parameters

##### aClass

`any`

##### aParentClass?

`any`

##### aBaseNameOnly?

`number`

#### Returns

`string`

#### Overrides

[`BaseFactory`](BaseFactory.md).[`formatNameFromClass`](BaseFactory.md#formatnamefromclass)

***

### get()

> `static` **get**(`name`): *typeof* [`BaseFactory`](BaseFactory.md)

Defined in: [src/base-factory.js:577](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L577)

Get the registered class via name

#### Parameters

##### name

`any`

#### Returns

*typeof* [`BaseFactory`](BaseFactory.md)

return the registered class if found the name

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`get`](BaseFactory.md#get)

***

### getAliases()

> `static` **getAliases**(`aClass`): `string`[]

Defined in: [src/base-factory.js:475](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L475)

get the aliases of the aClass

#### Parameters

##### aClass

the class or name to get aliases, means itself if no aClass specified

`string` | *typeof* [`BaseFactory`](BaseFactory.md)

#### Returns

`string`[]

aliases

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`getAliases`](BaseFactory.md#getaliases)

***

### getClassList()

> `static` **getClassList**(`ctor`): `any`[]

Defined in: [src/custom-factory.js:46](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L46)

#### Parameters

##### ctor

`any`

#### Returns

`any`[]

***

### getClassNameList()

> `static` **getClassNameList**(`ctor`): `any`[]

Defined in: [src/custom-factory.js:57](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L57)

#### Parameters

##### ctor

`any`

#### Returns

`any`[]

***

### getDisplayName()

> `static` **getDisplayName**(`aClass`): `string`

Defined in: [src/base-factory.js:506](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L506)

Get the display name from aClass

#### Parameters

##### aClass

the class, name or itself, means itself if no aClass

`string` | `Function`

#### Returns

`string`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`getDisplayName`](BaseFactory.md#getdisplayname)

***

### getNameFrom()

> `static` **getNameFrom**(`aClass`): `string`

Defined in: [src/base-factory.js:219](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L219)

Get the unique(registered) name in the factory

#### Parameters

##### aClass

`string` | `Function`

#### Returns

`string`

the unique name in the factory

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`getNameFrom`](BaseFactory.md#getnamefrom)

***

### getRealName()

> `static` **getRealName**(`name`): `any`

Defined in: [src/base-factory.js:184](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L184)

#### Parameters

##### name

`any`

#### Returns

`any`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`getRealName`](BaseFactory.md#getrealname)

***

### getRealNameFromAlias()

> `static` **getRealNameFromAlias**(`alias`): `string`

Defined in: [src/base-factory.js:197](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L197)

get the unique name in the factory from an alias name

#### Parameters

##### alias

`string`

the alias name

#### Returns

`string`

the unique name in the factory

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`getRealNameFromAlias`](BaseFactory.md#getrealnamefromalias)

***

### path()

> `static` **path**(`aClass`, `aRootName`): `string`[]

Defined in: [src/custom-factory.js:124](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L124)

get path of a class or itself

#### Parameters

##### aClass

`any`

##### aRootName

`any`

#### Returns

`string`[]

***

### pathArray()

> `static` **pathArray**(`aClass`, `aRootName`): `string`[]

Defined in: [src/custom-factory.js:134](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L134)

get path array of a class or itself

#### Parameters

##### aClass

`any`

##### aRootName

`any`

#### Returns

`string`[]

***

### register()

> `static` **register**(`aClass`, `aParentClass`, `aOptions`): `boolean`

Defined in: [src/custom-factory.js:177](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/custom-factory.js#L177)

register the aClass to the factory

#### Parameters

##### aClass

*typeof* `CustomFactory`

the class to register the Factory

##### aParentClass

the optional parent class

*typeof* `CustomFactory` | [`ICustomFactoryOptions`](../type-aliases/ICustomFactoryOptions.md)

##### aOptions

`any`

the options for the class and the factory

#### Returns

`boolean`

return true if successful.

#### Overrides

[`BaseFactory`](BaseFactory.md).[`register`](BaseFactory.md#register)

***

### registeredClass()

> `static` **registeredClass**(`aName`): `false` \| *typeof* [`BaseFactory`](BaseFactory.md)

Defined in: [src/base-factory.js:339](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L339)

Check the name, alias or itself whether registered.

#### Parameters

##### aName

`string`

the class name

#### Returns

`false` \| *typeof* [`BaseFactory`](BaseFactory.md)

the registered class if registered, otherwise returns false

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`registeredClass`](BaseFactory.md#registeredclass)

***

### removeAlias()

> `static` **removeAlias**(...`aliases`): `void`

Defined in: [src/base-factory.js:415](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L415)

remove specified aliases

#### Parameters

##### aliases

...`string`[]

the aliases to remove

#### Returns

`void`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`removeAlias`](BaseFactory.md#removealias)

***

### setAlias()

> `static` **setAlias**(`aClass`, `alias`): `void`

Defined in: [src/base-factory.js:459](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L459)

set alias to a class

#### Parameters

##### aClass

the class to set alias

`string` | *typeof* [`BaseFactory`](BaseFactory.md)

##### alias

`string`

#### Returns

`void`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`setAlias`](BaseFactory.md#setalias)

***

### setAliases()

> `static` **setAliases**(`aClass`, ...`aAliases`): `void`

Defined in: [src/base-factory.js:436](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L436)

set aliases to a class

#### Parameters

##### aClass

the class to set aliases

`string` | *typeof* [`BaseFactory`](BaseFactory.md)

##### aAliases

...`any`[]

#### Returns

`void`

#### Example

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

[`BaseFactory`](BaseFactory.md).[`setAliases`](BaseFactory.md#setaliases)

***

### setDisplayName()

> `static` **setDisplayName**(`aClass`, `aDisplayName`): `void`

Defined in: [src/base-factory.js:521](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L521)

Set the display name to the aClass

#### Parameters

##### aClass

the class, name or itself, means itself if no aClass

`string` | `Function`

##### aDisplayName

the display name to set

`string` | \{ `displayName`: `string`; \}

#### Returns

`void`

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`setDisplayName`](BaseFactory.md#setdisplayname)

***

### unregister()

> `static` **unregister**(`aName`): `boolean`

Defined in: [src/base-factory.js:366](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L366)

unregister this class in the factory

#### Parameters

##### aName

the registered name or class, no name means unregister itself.

`string` | `Function`

#### Returns

`boolean`

true means successful

#### Inherited from

[`BaseFactory`](BaseFactory.md).[`unregister`](BaseFactory.md#unregister)
