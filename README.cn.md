类工厂模式是一种面向对象的设计模式，它允许我们动态地注册和创建对象。这种模式主要有两个实现方式：BaseFactory 和 HierarchicalFactory。

工厂模式是一种面向对象的设计模式，它的目的是将对象的创建过程与使用过程分离开来。工厂模式通过一个工厂类来创建产品类的实例，而不是在使用时直接通过 new 关键字来创建对象实例。

类工厂模式是工厂模式的一种实现方式，它可以注册、注销指定的类，并能通过名字或别名得到已经注册的类。在类工厂模式中，注册类时还可以指定多个别名，这使得我们可以通过不同的名称来获取同一个类的实例。此外，类工厂模式还支持单例模式，它可以保证同一个类的实例只被创建一次。

在类工厂模式中，我们通常需要实现两个核心的类：BaseFactory 和 HierarchicalFactory。其中，BaseFactory 用于最简单的工厂模式，它没有层级注册功能，或者说只有底层（单层级）有注册/注销功能。而 HierarchicalFactory 是带层级的工厂模式，可以在每一个注册的类上再次进行注册/注销，从而形成类似目录的层级。

注册到`工厂`的类,又称为`产品`,而`产品`又可以是`工厂`.这可以通过注册时候的选项`isFactory`控制:

* 如果`isFactory`为`true`,那么注册时就会检测该注册类是否继承自`Factory`,如果不是则自动继承自`Factory`类(当`autoInherits`选项启用时)
* 如果`isFactory`为`Function`函数构造者,那么注册时就会检测该注册类是否继承自该函数构造者,如果不是则自动继承自该函数构造者(当`autoInherits`选项启用时)

默认注册的项都是即是产品又是工厂. 换句话说,`isFactory`选项默认为真,`autoInherits`选项默认为真.

1. BaseFactory：这是最简单的工厂模式，它只有一层注册/注销功能，没有层级结构。通过静态方法 register，我们可以将一个类注册到工厂中，并通过名称或别名获取已注册的类。还可以通过重载 createObject 方法，实现单件模式。BaseFactory 还提供了一些静态方法和实例方法，用于管理和操作注册类和对象实例。

2. HierarchicalFactory：这是带有层级结构的工厂模式，通过继承自 BaseFactory 实现。与 BaseFactory 不同的是，HierarchicalFactory 允许我们在每个注册类上再次进行注册/注销，从而形成类似目录的层级结构。除此之外，HierarchicalFactory 还提供了一些额外的静态方法，用于获取工厂结构的路径。


下面我们来更详细地介绍这两个类工厂模式的实现。

### BaseFactory

BaseFactory 的核心是静态方法 `register`，我们可以通过它将一个类注册到工厂中。`register` 方法接受两个参数：`ctor` 和 `options`。`ctor` 表示要注册的类的构造函数，`options` 是一个对象或字符串，它包含了注册选项，也可以直接传入字符串作为注册名。

以下是 `options` 可以包含的选项：

* `name`：表示注册名，如果没有指定，将使用类名作为注册名。
* `displayName`：表示显示名，可选。
* `alias` 或 `aliases`：表示别名，可以是一个字符串或字符串数组，可选。
* `baseNameOnly`：表示从类名中提取基本名称以进行注册，默认为 `1`，即只提取一级名称。例如，如果我们将 `TextCodec` 类注册到 `Codec` 工厂中，使用 `baseNameOnly` 为 1，`TextCodec` 将被注册为 `Text`；如果 `baseNameOnly` 为 2，`TextCodec` 将被注册为 `Json`。
* `isFactory` `{Function|boolean}`：表示注册项是否是工厂类型，默认为 `true`, isFactory如果是`Function`那么就以它代替自动继承的工厂类
* `autoInherits` `{boolean}`: 当注册项是工厂类型时,是否自动检查并继承自工厂类，默认为 `true`

除了 `register` 方法，`BaseFactory` 还提供了以下静态方法：

* `unregister`：用于注销类或注册名。
* `setAliases`：用于添加或更新类的别名。
* `forEach`：用于遍历所有注册类。
* `get`：用于根据名称获取已注册类。
* `formatName`：用于格式化(改变)注册名,默认不做任何改变(即名称会区分大小写),重载该方法可实现自己的格式化注册名(比如,不区分大小写)。

此外，`BaseFactory` 还可以通过重载 `createObject` 方法来创建对象实例，以实现单件模式。`BaseFactory` 实例还可以通过 `initialize` 方法进行初始化。

### HierarchicalFactory

HierarchicalFactory 继承自 BaseFactory，它添加了层级结构的功能。与 BaseFactory 不同的是，我们可以将一个类注册到另一个类中，从而形成层级结构。

HierarchicalFactory 的核心方法是`register`，它可以将一个类注册到另一个类中，形成类似于目录的层级结构。具体来说，`register(aClass, aParentClass, aOptions)` 方法将 `aClass` 注册到 `aParentClass` 的工厂中，而 `register(aClass, aOptions)` 方法将 `aClass` 注册到自身或者 `aOptions.parent` 的工厂中。

与 `BaseFactory` 类似，`HierarchicalFactory` 也提供了 `unregister` 方法来注销类或者工厂本身，以及 `get` 方法来获取已经注册的类。此外，`HierarchicalFactory` 还提供了 `path` 和 `pathArray` 方法来获取类在层级结构中的路径，可以用于调试或者查找。

需要注意的是，`HierarchicalFactory` 中的类的名称并不一定和它们注册时指定的名称相同，因为注册时可以通过 `baseNameOnly` 参数指定从类名中提取的基本名称。例如，在 `Codec` 工厂中注册 `TextCodec` 类时，如果 `baseNameOnly` 设置为 1，则注册的名称为 `Text`；如果设置为 2，则注册的名称为 `Json`。

`baseNameOnly`: 在 JavaScript 中，类名通常使用 `PascalCase` 命名规则，这意味着每个单词的首字母都大写，例如 "JsonTextCodec"。参数 baseNameOnly 是一个数字，它决定了要从类名中提取哪些单词作为基本名称。例如，如果 baseNameOnly 是 1，我们就会从 "JsonTextCodec" 中提取第一个单词 "Json" 作为基本名称。如果 baseNameOnly 是 2，我们就会从 "JsonTextCodec" 中提取前两个单词 "JsonText" 作为基本名称。如果 baseNameOnly 是 0，则使用整个类名作为基本名称。这个基本名称用于注册类或工厂。

BaseFactory 类有以下几个核心方法：

* register(ctor, options)：将一个类注册到工厂中。
  * ctor：表示要注册的类的构造函数。
  * options：表示要注册的类的配置信息，包括 name、displayName、alias 等。
* unregister(aName|aClass|undefined)：从工厂中注销一个类，支持传入类名、类或者不传参数三种方式。
* setAliases(aClass, ...aliases: string[])：为一个类添加或更新别名。
* forEach(cb: (class: typeof BaseFactory, name: string)=>'brk'|string|undefined)：遍历工厂中的所有类，并执行回调函数。
* get(name: string): typeof BaseFactory：根据类名或别名获取工厂中的类。
* formatName(aName: string): string：格式化注册名称，默认与传入名称相同，可以重写此方法实现大小写不敏感等功能。

HierarchicalFactory 类继承自 BaseFactory，它额外提供了以下几个核心方法：

* `register(aClass, aParentClass, [aOptions])`：将一个类注册到指定的父类下。
  * aClass：表示要注册的类的构造函数。
  * aParentClass：表示父类的构造函数。
  * aOptions：表示要注册的类的配置信息，包括 name、displayName、alias 等。
* `path(aClass?: typeof CustomFactory, aRootName?: string)`：获取指定类的工厂路径字符串。
  * aClass：表示要获取路径的类的构造函数。
  * aRootName：表示根目录的名称，默认为 RootFactory.ROOT_NAME 或 RootFactory.prototype.name 或 RootFactory.name。
* `pathArray(aClass?: typeof CustomFactory, aRootName?: string)` 方法用于获取指定类的层级路径数组。
  * 参数 `aClass` 是一个可选的类，用于指定需要获取层级路径数组的类。如果不指定，该方法将返回当前工厂实例的层级路径数组。
  * 参数 `aRootName` 也是可选的，用于指定根工厂的名称。如果没有指定，则默认使用 `RootFactory.ROOT_NAME`、`RootFactory.prototype.name` 或者 `RootFactory.name`。
  * 该方法返回一个字符串数组，表示类从根工厂开始的层级路径。例如，如果 `MyFactory` 工厂在 `RootFactory` 的 `A` 工厂下，那么该工厂的层级路径数组为 `['A', 'MyFactory']`。

----------------------------

类工厂模式是管理类的工厂模式,而所谓工厂模式是指能够注册(`register`)/注销(`unregister`)指定的类并能通过名字或别名得到已经注册的类(`get(name_or_alias)`),注册时候还可以指定多个别名(`aliases(IntegerType, 'int', 'INT')`).
通过类工厂类(`createObject(name_or_alias)`),还可以创建对象实例, 通过重载`createObject`方法能够可以实现对象实例的单件模式.

有两种类工厂模式:

1. BaseFactory 用于最简单的工厂模式, 没有层级注册功能,或者说只有底层(单层级)有注册/注销功能.
   * BaseFactory: 扁平化的工厂
     * static members:
       * `register(ctor, options)`: register a class to the factory,
         * ctor: it will be automatically inherited to the Factory after registered if ctor isn't derived from BaseFactory
         * options*(object|string)*: the options for the class and the factory
           * it is the registered name if options is string.
           * name*(String)*: optional unique id name to register, defaults to class name
           * displayName: optional display name
           * alias,aliases*(String|string[])*: optional alias
           * baseNameOnly*(number)*: extract basename from class name to register it if no specified name.
             defaults to 1. the baseNameOnly number can be used on hierarchical factory, means max level to extract basename.
             0 means use the whole class name to register it, no extract.
             * eg, the `Codec` is a Root Factory, we add the `TextCodec` to "Codec", add the `JsonTextCodec` to "TextCodec"
               * baseNameOnly = 1: `TextCodec` name is 'Text', `JsonTextCodec` name is 'JsonText'
               * baseNameOnly = 2: `TextCodec` name is 'Text', `JsonTextCodec` name is 'Json'
       * `unregister(aName|aClass|undefined)`: unregister the class, class name or itself from the Factory
       * `setAliases(aClass, ...aliases: string[])`: add/update aliases to the aClass.
       * `forEach(cb: (class: typeof BaseFactory, name: string)=>'brk'|string|undefined)`: executes a provided callback function once for each registered element.
       * `get(name: string): typeof BaseFactory`: get the registered class via name
       * `formatName(aName: string): string`: format the registered name, defaults to same as aName. you can override this method to implement case insensitive.
     * instance members
       * `initialize()`: initialize instance method which called by `constructor()`
         * pass through all arguments coming from constructor
2. HierarchicalFactory(继承自BaseFactory) 是带层级的工厂模式,可以在每一个注册的类上(任意层级)再次进行注册/注销,从而形成类似目录的层级.
   * static members
      * `register(aClass, aParentClass, aOptions)`: register the aClass to aParentClass Class.
      * `register(aClass, aOptions)`: register the aClass to itself or `aOptions.parent`
        * `options`*(object|string)*: the options for the class and the factory
          * it is the registered name if aOptions is string.
          * `name`*(String)*: optional unique id name to register, defaults to class name
          * `displayName`: optional display name
          * `baseNameOnly`*(number)*: extract basename from class name to register it if no specified name.
            defaults to 1. the baseNameOnly number can be used on hierarchical factory, means max level to extract basename.
            0 means use the whole class name to register it, no extract.
            * eg, the `Codec` is a Root Factory, we add the `TextCodec` to "Codec", add the `JsonTextCodec` to "TextCodec"
              * baseNameOnly = 1: `TextCodec` name is 'Text', `JsonTextCodec` name is 'JsonText'
              * baseNameOnly = 2: `TextCodec` name is 'Text', `JsonTextCodec` name is 'Json'
      * `path(aClass?: typeof CustomFactory, aRootName?: string)`: get the path string of this aClass factory item or itself.
        * `aRootName`: defaults to `RootFactory.ROOT_NAME || RootFactory.prototype.name || RootFactory.name`
      * `pathArray(aClass?: typeof CustomFactory, aRootName?: string)`: get the path array of this aClass factory item or itself.
        * `aRootName`: defaults to `RootFactory.ROOT_NAME || RootFactory.prototype.name || RootFactory.name`

