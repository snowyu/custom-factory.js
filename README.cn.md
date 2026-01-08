# CustomFactory [![Build Status](https://github.com/snowyu/custom-factory.js/actions/workflows/nodejs.yml/badge.svg)](https://github.com/snowyu/custom-factory.js/actions/workflows/nodejs.yml) [![npm](https://img.shields.io/npm/v/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![downloads](https://img.shields.io/npm/dm/custom-factory.svg)](https://npmjs.org/package/custom-factory) [![license](https://img.shields.io/npm/l/custom-factory.svg)](https://npmjs.org/package/custom-factory)

**CustomFactory** 是一个强大的工具，用于为您的类或对象添加工厂能力。它允许您通过注册、别名和层级结构来管理类和实例。

无论您是需要一个简单的扁平注册表，还是一个复杂的层级系统（类似文件系统），CustomFactory 都能满足您的需求。它同时支持 **继承 (Inheritance)**（扩展基类）和 **能力 (Ability/Mixin)** 模式，使其能够轻松集成到现有的代码库中。

## 特性

* **工厂模式：**
  * **扁平工厂 (`BaseFactory`)：** 一个简单的单层级注册表。
  * **层级工厂 (`CustomFactory`)：** 一个多层级注册表，工厂可以包含其他工厂（类似文件夹结构）。
* **灵活注册：** 支持使用唯一名称、显示名称和多个别名来注册类。
* **智能命名：** 自动推导注册名称，智能剥离后缀（例如 `TextCodec` 在 `Codec` 工厂中自动注册为 `Text`）。
* **单例支持：** 获取或创建单例实例。
* **集成方式：**
  * **继承：** 继承 `BaseFactory` 或 `CustomFactory`。
  * **能力 (Ability/Mixin)：** 为*任何*现有类添加工厂特性，而不破坏原有的继承链。
* **自动继承：** 注册时自动继承工厂类（可配置）。
* **大小写敏感：** 可配置名称格式化（默认区分大小写）。

## 安装

```bash
npm install custom-factory
```

## 快速开始

### 方法 1: 继承模式 (推荐用于新项目)

#### 扁平工厂 (`BaseFactory`)

使用 `BaseFactory` 来创建一个简单、非嵌套的注册表。

```javascript
import { BaseFactory } from 'custom-factory'

class ShapeFactory extends BaseFactory {}

// 1. 注册类
class Circle extends ShapeFactory {} // 自动注册为 'Circle'
ShapeFactory.register(Circle)

// 2. 使用别名和选项注册
class Square {}
ShapeFactory.register(Square, {
  name: 'Square',
  aliases: ['sq', 'box']
})

// 3. 使用
const shape = ShapeFactory.createObject('Circle') // 返回一个 Circle 实例
const sq = ShapeFactory.get('sq') // 返回 Square 类
```

#### 层级工厂 (`CustomFactory`)

当您需要嵌套结构（例如 `Codec` -> `Image` -> `Png`）时，使用 `CustomFactory`。

```javascript
import { CustomFactory } from 'custom-factory'

class RootFactory extends CustomFactory {}

// 第一层
class Codec extends RootFactory {}
RootFactory.register(Codec)

// 第二层
class ImageCodec extends Codec {}
Codec.register(ImageCodec, { name: 'Image' }) // 在 'Codec' 下注册为 'Image'

// 第三层
class PngCodec extends ImageCodec {}
ImageCodec.register(PngCodec, { name: 'Png' })

// 使用
console.log(RootFactory.path(PngCodec)) // 输出: '/Codec/Image/Png'
const PngClass = RootFactory.get('Codec').get('Image').get('Png')
```

### 方法 2: 能力 / Mixin 模式 (推荐用于现有类)

如果您已经有了一个类继承体系，并且希望在不更改父类的情况下添加工厂能力，请使用 `Ability` 函数。

```javascript
import { addBaseFactoryAbility, addFactoryAbility } from 'custom-factory'

class MyBaseClass {
  constructor(name) { this.name = name }
}

// 添加扁平工厂能力
addBaseFactoryAbility(MyBaseClass)

class Plugin extends MyBaseClass {}
MyBaseClass.register(Plugin, { name: 'MyPlugin' })

const instance = MyBaseClass.createObject('MyPlugin', 'instanceName')
```

对于层级能力，请使用 `addFactoryAbility(MyBaseClass)`。

## 核心概念

### 1. 扁平工厂 (`BaseFactory`)

`BaseFactory` 为所有注册项提供一个单一的命名空间。非常适合简单的插件系统或类型注册表。

**关键方法：**

* `register(Class, [options])`: 注册一个类。
* `get(name)`: 通过名称或别名获取类。
* `createObject(name, ...args)`: 创建注册类的实例。
* `forEach(callback)`: 遍历注册的类。

### 2. 层级工厂 (`CustomFactory`)

`CustomFactory` 继承自 `BaseFactory` 以支持嵌套。注册的项本身也可以是其他项的工厂。

**关键方法 (继承自 BaseFactory)：**

* `register(Class, [parent], [options])`: 注册一个类，可选指定父工厂。
* `path(Class)`: 返回完整的路径字符串 (例如 `/Root/Parent/Child`)。
* `pathArray(Class)`: 返回路径数组。

### 3. 自动名称生成

当您在注册类而没有提供明确的 `name` 时，工厂会尝试通过剥离冗余后缀来生成一个干净的名称。

* **明确指定名称**：您可以在注册时提供名称，或者在类中定义 `static name` 和 `static aliases`：
  ```javascript
  // 通过注册选项
  Factory.register(MyClass, { name: "custom-name", aliases: ["c", "alias"] });
  // 或者通过类中的静态属性 (声明式风格)
  class MyClass {
    static name = "custom-name";
    static aliases = ["c", "alias"];
  }
  Factory.register(MyClass);
  ```

* **`baseNameOnly` (默认值: 1)**：工厂检查类名是否以工厂名称（或层级结构中的祖先名称）结尾并将其剥离。

  * **扁平示例:** 将 `TextCodec` 注册到 `CodecFactory` -> 名称变为 `Text`。
  * **层级示例:**
    * 根: `Codec`
    * 子: `ImageCodec` (注册为 `Image`)
    * 孙: `PngImageCodec` (注册为 `Png`) -> 剥离 `ImageCodec` (父) 和 `Codec` (根)。
* **`baseNameOnly: 0`:** 禁用后缀剥离。使用完整的类名。

### 4. 自定义名称格式化

默认情况下，名称是 **区分大小写** 的。您可以通过重写工厂中的静态 `formatName` 方法来更改此行为。

```javascript
class MyFactory extends BaseFactory {
  static formatName(name) {
    return name.toLowerCase(); // 转换为小写以实现不区分大小写
  }
}
```

在使用 **能力 (Ability)** 时，您也可以通过在添加能力之前在类上定义 `formatName`，或者在选项中传递它来重写 `formatName`：

```javascript
class MyCodec {
  static formatName(name) { return name.toLowerCase() }
}
addFactoryAbility(MyCodec)
// 或者
addFactoryAbility(MyCodec, { formatName: (name) => name.toLowerCase() })
```

### 5. 高级注册：`isFactory` 和 `autoInherits`

`register` 方法接受高级选项来控制继承和工厂行为。

* **`isFactory`** (`boolean` | `Class`, 默认值: `true`):
  * `true`: 注册的类被视为 **工厂节点 (Factory Node)**。它可以拥有自己的子类。
  * `false`: 注册的类被视为 **产品/叶子节点 (Product/Leaf)**。它不能拥有子类。
  * `Class` (构造函数): 注册的类是一个工厂，且 **必须** 继承自该特定类。

  **关于 `isFactory` 优先级的说明:**
  该值按以下顺序确定：
  1. 传递给 `register()` 的 `options.isFactory`。
  2. 定义在 **被注册类** 上的 `static _isFactory`。
  3. 定义在 **当前工厂类** 上的 `static _isFactory`。
  4. 定义在 **根工厂类** (`this.Factory`) 上的 `static _isFactory`。
  5. 默认值为 `true`。

* **`autoInherits`** (`boolean`, 默认值: `true`):
  * `true`: 如果注册项（作为工厂）尚未继承自父工厂，CustomFactory 将 **自动修改其原型链** 以实现继承。这对于“混合搭配 (Mix-and-Match)”的组合方式非常有用。
  * `false`: 禁用自动继承。如果类没有正确继承，将抛出 `TypeError`。

### 6. 别名 (Aliases)

别名允许您使用不同的名称来引用同一个已注册的类。这对于提供缩写或保持向后兼容性非常有用。

* **在注册时指定**：
  ```javascript
  Factory.register(MyClass, { aliases: ['m', 'my'] });
  ```
* **注册后设置**：
  ```javascript
  Factory.setAliases(MyClass, 'shortcut', 'another');
  // 或者设置单个别名
  Factory.setAlias(MyClass, 'short');
  ```
* **使用属性操作**：如果类已经注册，您可以使用 `aliases` 属性：
  ```javascript
  MyClass.aliases = ['a', 'b']; // 替换当前的别名
  console.log(MyClass.aliases); // ['a', 'b']
  ```
* **检索**：在 `get()` 或 `createObject()` 中使用任何别名：
  ```javascript
  const instance = Factory.createObject('shortcut');
  ```
* **注意**：别名同样会受到工厂 `formatName` 方法的处理（例如，如果工厂设置为不区分大小写，别名也会遵循此规则）。

## API 参考

### 静态属性

* `_isFactory`: 工厂的默认 `isFactory` 值 (默认值: `true`)。
* `_baseNameOnly`: 工厂的默认 `baseNameOnly` 值 (默认值: `1`)。

### 静态方法

* `register(class, [options])`: 注册一个类。
* `unregister(name|class)`: 从工厂中移除一个类。
* `get(name)`: 获取已注册的类。
* `createObject(name, ...args)`: 创建实例。
* `setAliases(class, ...aliases)`: 设置别名。
* `getAliases(class)`: 获取别名。
* `forEach(callback)`: 遍历注册项。
* `formatName(name)`: 重写此方法以更改名称匹配规则（例如，实现不区分大小写）。

### 实例方法

* `initialize(...args)`: 由构造函数调用。重写此方法以添加初始化逻辑。

*(仅限 `CustomFactory`)*

* `path(class)`: 获取层级路径。
* `pathArray(class)`: 获取层级路径数组。

## 许可证

MIT
