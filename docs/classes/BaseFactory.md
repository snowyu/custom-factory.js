[**custom-factory**](../README.md)

***

[custom-factory](../globals.md) / BaseFactory

# Abstract Class: BaseFactory

Defined in: [src/base-factory.js:88](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L88)

Abstract flat factory class

## Extended by

- [`CustomFactory`](CustomFactory.md)

## Constructors

### Constructor

> **new BaseFactory**(...`args`): `BaseFactory`

Defined in: [src/base-factory.js:620](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L620)

#### Parameters

##### args

...`any`[]

#### Returns

`BaseFactory`

## Properties

### \_aliases

> `abstract` `static` **\_aliases**: \[`string`\] = `undefined`

Defined in: [src/base-factory.js:114](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L114)

**`Internal`**

the registered alias items object.
the key is alias name, the value is the registered name

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

***

### \_Factory

> `abstract` `static` **\_Factory**: *typeof* `BaseFactory` = `undefined`

Defined in: [src/base-factory.js:96](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L96)

**`Internal`**

The Root Factory class

#### Name

_Factory

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

***

### Factory

#### Get Signature

> **get** `static` **Factory**(): *typeof* `BaseFactory`

Defined in: [src/base-factory.js:119](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L119)

The Root Factory class

##### Returns

*typeof* `BaseFactory`

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

***

### \_findRootFactory()

> `static` **\_findRootFactory**(`aClass`): *typeof* `BaseFactory`

Defined in: [src/base-factory.js:174](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L174)

**`Internal`**

find the real root factory

#### Parameters

##### aClass

*typeof* `BaseFactory`

the abstract root factory class

#### Returns

*typeof* `BaseFactory`

***

### \_get()

> `static` **\_get**(`name`): `any`

Defined in: [src/base-factory.js:581](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L581)

#### Parameters

##### name

`any`

#### Returns

`any`

***

### \_register()

> `static` **\_register**(`aClass`, `aOptions?`): `boolean`

Defined in: [src/base-factory.js:273](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L273)

**`Internal`**

register the aClass to the factory

#### Parameters

##### aClass

*typeof* `BaseFactory`

the class to register the Factory

##### aOptions?

`any`

the options for the class and the factory

#### Returns

`boolean`

return true if successful.

***

### cleanAliases()

> `static` **cleanAliases**(`aName`): `void`

Defined in: [src/base-factory.js:398](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L398)

remove all aliases of the registered item or itself

#### Parameters

##### aName

the registered item or name

`string` | *typeof* `BaseFactory`

#### Returns

`void`

***

### createObject()

> `static` **createObject**(`aName`, `aOptions`): `BaseFactory`

Defined in: [src/base-factory.js:595](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L595)

Create a new object instance of Factory

#### Parameters

##### aName

`string` | `BaseFactory`

##### aOptions

`any`

#### Returns

`BaseFactory`

***

### findRootFactory()

> `abstract` `static` **findRootFactory**(): *typeof* `BaseFactory`

Defined in: [src/base-factory.js:163](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L163)

**`Internal`**

find the real root factory

You can overwrite it to specify your root factory class
or set _Factory directly.

#### Returns

*typeof* `BaseFactory`

the root factory class

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

***

### formatNameFromClass()

> `static` **formatNameFromClass**(`aClass`, `aBaseNameOnly?`): `string`

Defined in: [src/base-factory.js:234](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L234)

**`Internal`**

format(transform) the name to be registered for the aClass

#### Parameters

##### aClass

`any`

##### aBaseNameOnly?

`number`

#### Returns

`string`

the name to register

***

### get()

> `static` **get**(`name`): *typeof* `BaseFactory`

Defined in: [src/base-factory.js:577](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L577)

Get the registered class via name

#### Parameters

##### name

`any`

#### Returns

*typeof* `BaseFactory`

return the registered class if found the name

***

### getAliases()

> `static` **getAliases**(`aClass`): `string`[]

Defined in: [src/base-factory.js:475](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L475)

get the aliases of the aClass

#### Parameters

##### aClass

the class or name to get aliases, means itself if no aClass specified

`string` | *typeof* `BaseFactory`

#### Returns

`string`[]

aliases

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

***

### getRealName()

> `static` **getRealName**(`name`): `any`

Defined in: [src/base-factory.js:184](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L184)

#### Parameters

##### name

`any`

#### Returns

`any`

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

***

### register()

> `static` **register**(...`args`): `boolean`

Defined in: [src/base-factory.js:262](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L262)

register the aClass to the factory

#### Parameters

##### args

...`any`[]

#### Returns

`boolean`

return true if successful.

***

### registeredClass()

> `static` **registeredClass**(`aName`): `false` \| *typeof* `BaseFactory`

Defined in: [src/base-factory.js:339](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L339)

Check the name, alias or itself whether registered.

#### Parameters

##### aName

`string`

the class name

#### Returns

`false` \| *typeof* `BaseFactory`

the registered class if registered, otherwise returns false

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

***

### setAlias()

> `static` **setAlias**(`aClass`, `alias`): `void`

Defined in: [src/base-factory.js:459](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L459)

set alias to a class

#### Parameters

##### aClass

the class to set alias

`string` | *typeof* `BaseFactory`

##### alias

`string`

#### Returns

`void`

***

### setAliases()

> `static` **setAliases**(`aClass`, ...`aAliases`): `void`

Defined in: [src/base-factory.js:436](https://github.com/snowyu/custom-factory.js/blob/15593f29ac15322b3998d605546074093a726252/src/base-factory.js#L436)

set aliases to a class

#### Parameters

##### aClass

the class to set aliases

`string` | *typeof* `BaseFactory`

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
