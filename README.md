# CustomFactory [![Build Status](https://github.com/snowyu/custom-factory.js/actions/workflows/nodejs.yml/badge.svg)](https://github.com/snowyu/custom-factory.js/actions/workflows/nodejs.yml) [![npm](https://img.shields.io/npm/v/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![downloads](https://img.shields.io/npm/dm/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![license](https://img.shields.io/npm/l/custom-factory.svg)](https://npmjs.org/package/custom-factory)

**CustomFactory** is a powerful utility that adds factory capabilities to your classes or objects. It allows you to manage classes and instances through registration, aliasing, and hierarchical structures.

Whether you need a simple flat registry or a complex hierarchical system (like a file system), CustomFactory has you covered. It supports both **Inheritance** (extending a base class) and **Ability** (mixin/trait) patterns, making it easy to integrate into existing codebases.

## Features

* **Factory Patterns:**
  * **Flat Factory (`BaseFactory`):** A simple, single-level registry.
  * **Hierarchical Factory (`CustomFactory`):** A multi-level registry where factories can contain other factories (like folders).
* **Flexible Registration:** Register classes with unique names, display names, and multiple aliases.
* **Smart Naming:** Automatically deduces registered names by stripping suffixes (e.g., `TextCodec` -> `Text` in a `Codec` factory).
* **Singleton Support:** Retrieve or create singleton instances.
* **Integration Styles:**
  * **Inheritance:** Extend `BaseFactory` or `CustomFactory`.
  * **Ability (Mixin):** Add factory features to *any* existing class without breaking the inheritance chain.
* **Automatic Inheritance:** Automatically inherits from the factory class upon registration (configurable).
* **Case Sensitivity:** Configurable name formatting (case-sensitive by default).

## Installation

```bash
npm install custom-factory
```

## Quick Start

### Method 1: Inheritance (Recommended for new projects)

#### Flat Factory (`BaseFactory`)

Use `BaseFactory` for a simple, non-nested registry.

```javascript
import { BaseFactory } from 'custom-factory'

class ShapeFactory extends BaseFactory {}

// 1. Register classes
class Circle extends ShapeFactory {} // Auto-registers as 'Circle'
ShapeFactory.register(Circle)

// 2. Register with aliases and options
class Square {}
ShapeFactory.register(Square, {
  name: 'Square',
  aliases: ['sq', 'box']
})

// 3. Usage
const shape = ShapeFactory.createObject('Circle') // Returns a Circle instance
const sq = ShapeFactory.get('sq') // Returns the Square class
```

#### Hierarchical Factory (`CustomFactory`)

Use `CustomFactory` when you need a nested structure (e.g., `Codec` -> `Image` -> `Png`).

```javascript
import { CustomFactory } from 'custom-factory'

class RootFactory extends CustomFactory {}

// Level 1
class Codec extends RootFactory {}
RootFactory.register(Codec)

// Level 2
class ImageCodec extends Codec {}
Codec.register(ImageCodec, { name: 'Image' }) // Registered as 'Image' inside 'Codec'

// Level 3
class PngCodec extends ImageCodec {}
ImageCodec.register(PngCodec, { name: 'Png' })

// Usage
console.log(RootFactory.path(PngCodec)) // Output: '/Codec/Image/Png'
const PngClass = RootFactory.get('Codec').get('Image').get('Png')
```

### Method 2: Ability / Mixin (Recommended for existing classes)

If you already have a class hierarchy and want to add factory powers without changing the superclass, use the `Ability` functions.

```javascript
import { addBaseFactoryAbility, addFactoryAbility } from 'custom-factory'

class MyBaseClass {
  constructor(name) { this.name = name }
}

// Add Flat Factory capability
addBaseFactoryAbility(MyBaseClass)

class Plugin extends MyBaseClass {}
MyBaseClass.register(Plugin, { name: 'MyPlugin' })

const instance = MyBaseClass.createObject('MyPlugin', 'instanceName')
```

For hierarchical capabilities, use `addFactoryAbility(MyBaseClass)`.

## Core Concepts

### 1. Flat Factory (`BaseFactory`)

The `BaseFactory` provides a single namespace for all registered items. It's ideal for simple plugin systems or type registries.

**Key Methods:**

* `register(Class, [options])`: Registers a class.
* `get(name)`: Retrieves a class by name or alias.
* `createObject(name, ...args)`: Creates an instance of the registered class.
* `forEach(callback)`: Iterates through registered classes.

### 2. Hierarchical Factory (`CustomFactory`)

The `CustomFactory` extends `BaseFactory` to support nesting. Registered items can themselves be factories for other items.

**Key Methods (extends BaseFactory):**

* `register(Class, [parent], [options])`: Registers a class, optionally specifying a parent factory.
* `path(Class)`: Returns the full path string (e.g., `/Root/Parent/Child`).
* `pathArray(Class)`: Returns the path as an array.

### 3. Automatic Name Generation

When you register a class without providing an explicit `name`, the factory attempts to generate a clean name by stripping redundant suffixes. This is controlled by the `baseNameOnly` option.

* **`baseNameOnly` (default: 1):** The factory checks if the class name ends with the factory's name (or ancestor names in a hierarchy) and strips it.
  * **Flat Example:** Registering `TextCodec` to `CodecFactory` -> Name becomes `Text`.
  * **Hierarchy Example:**
    * Root: `Codec`
    * Child: `ImageCodec` (Registered as `Image`)
    * Grandchild: `PngImageCodec` (Registered as `Png`) -> Strips `ImageCodec` (parent) and `Codec` (root).
* **`baseNameOnly: 0`:** Disables suffix stripping. Uses the full class name.

### 4. Customizing Name Formatting

By default, names are **case-sensitive**. You can change this behavior by overriding the static `formatName` method in your factory.

```javascript
class MyFactory extends BaseFactory {
  static formatName(name) {
    return name.toLowerCase(); // Make everything case-insensitive
  }
}
```

When using **abilities**, you can also override `formatName` by either defining it on the class before adding the ability, or by passing it in the options:

```javascript
class MyCodec {
  static formatName(name) { return name.toLowerCase() }
}
addFactoryAbility(MyCodec)
// OR
addFactoryAbility(MyCodec, { formatName: (name) => name.toLowerCase() })
```

### 5. Advanced Registration: `isFactory` and `autoInherits`

The `register` method accepts advanced options to control inheritance and factory behavior.

* **`isFactory`** (`boolean` | `Class`, default: `true`):
  * `true`: The registered class is treated as a **Factory Node**. It can have its own children.
  * `false`: The registered class is a **Product/Leaf**. It cannot have children.
  * `Class` (Constructor): The registered class is a factory and **must** inherit from this specific class.

  **Note on `isFactory` Priority:**
  The value is determined in the following order:
  1. `options.isFactory` passed to `register()`.
  2. `static _isFactory` defined on the **registered class**.
  3. `static _isFactory` defined on the **Factory class** itself.
  4. Defaults to `true`.

* **`autoInherits`** (`boolean`, default: `true`):
  * `true`: If the registered item (which is a Factory) does not already inherit from the parent Factory, CustomFactory will **automatically modify its prototype chain** to inherit from it. This is useful for "Mix-and-Match" composition.
  * `false`: Disables automatic inheritance. If the class does not inherit correctly, a `TypeError` will be thrown.

## API Reference

### Static Methods

* `register(class, [options])`: Register a class.
* `unregister(name|class)`: Remove a class from the factory.
* `get(name)`: Get a registered class.
* `createObject(name, ...args)`: Create an instance.
* `setAliases(class, ...aliases)`: Set aliases.
* `getAliases(class)`: Get aliases.
* `forEach(callback)`: Iterate over registered items.
* `formatName(name)`: Override this to change name matching (e.g., for case-insensitivity).

### Instance Methods

* `initialize(...args)`: Called by the constructor. Override this for initialization logic.

*(For `CustomFactory` only)*

* `path(class)`: Get the hierarchical path.
* `pathArray(class)`: Get the hierarchical path as an array.

## License

MIT
