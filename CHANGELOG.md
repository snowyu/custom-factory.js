# Changelog

All notable changes to this project will be documented in this file. See [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version) for commit guidelines.

## [2.3.0-alpha.1](https://github.com/snowyu/custom-factory.js/compare/v2.3.0-alpha.0...v2.3.0-alpha.1) (2023-04-18)


### Bug Fixes

* **ts:** ts declaration files position error ([8108e87](https://github.com/snowyu/custom-factory.js/commit/8108e87e7977d1cdb0535ea93c25fa7efae2d529))

## [2.3.0-alpha.0](https://github.com/snowyu/custom-factory.js/compare/v2.2.0...v2.3.0-alpha.0) (2023-04-17)


### Features

* supports to register the product item and factory item via `isFactory` and autoInherits options ([3e43bb9](https://github.com/snowyu/custom-factory.js/commit/3e43bb99ee09477d3c5ab8e49556ff7826504c42))

## [2.2.0](https://github.com/snowyu/custom-factory.js/compare/v2.1.0...v2.2.0) (2023-03-13)


### Features

* Add ESM(ECMAScript module) supports for nodejs@12 and above ([3c1fb61](https://github.com/snowyu/custom-factory.js/commit/3c1fb6153351284b5cd275e2bcba5ff8f8126246))
* Use [SWC](https://swc.rs/) instead of babel. ([64ca528](https://github.com/snowyu/custom-factory.js/commit/64ca5281e943596467a591662e28c9aabdf8f687))


### Bug Fixes

* import glitch ([b2efb3b](https://github.com/snowyu/custom-factory.js/commit/b2efb3bbb14481d344f166b10d034c237b86cd04))
* some ts declaration and documents missing ([dcf027b](https://github.com/snowyu/custom-factory.js/commit/dcf027bbf6d04c5f32116fe16708ac7f83a567d8))

## [2.1.0](https://github.com/snowyu/custom-factory.js/compare/v2.1.0-alpha.0...v2.1.0) (2023-03-11)


### Bug Fixes

* **CustomFactory:** unregister child should remove itself from parent class too ([b50fb4f](https://github.com/snowyu/custom-factory.js/commit/b50fb4fe47bba3d509c26939c9de760cca9917cc))

## [2.1.0-alpha.0](https://github.com/snowyu/custom-factory.js/compare/v1.5.0...v2.1.0-alpha.0) (2021-04-25)


### Features

* add class factory ([4ed11e2](https://github.com/snowyu/custom-factory.js/commit/4ed11e28001937687233b84a653a77be29ad0b2e))
* add factory(not done) ([dc4936d](https://github.com/snowyu/custom-factory.js/commit/dc4936d696a0bd3a385bf79a6820054f3925bffd))
* add flat class factory basically ([39d5880](https://github.com/snowyu/custom-factory.js/commit/39d5880a922b0ac9728ca0eccb6b1baacfd8cd44))
* add flat-factory ([200c6e1](https://github.com/snowyu/custom-factory.js/commit/200c6e17e7e6ac3d5a94e33d935600502021d9b9))
* add get/set displayName methods ([cda825f](https://github.com/snowyu/custom-factory.js/commit/cda825fdccaffdb60a12f1bcf77a726a97c0595b))
* add index file ([86b850e](https://github.com/snowyu/custom-factory.js/commit/86b850ee8695f9233e36af80b72402aa6b8e5fa7))
* add src/utils ([7c9e6bb](https://github.com/snowyu/custom-factory.js/commit/7c9e6bb7abb686385238283e111ee9a68ad6026a))
* apply custom-ability to flat-factory ([36f58a9](https://github.com/snowyu/custom-factory.js/commit/36f58a9203a18e143b448ce94667d12d88c1d166))
* export func to get flat class factory ([4447130](https://github.com/snowyu/custom-factory.js/commit/4447130e9b8b69fac2df6e7cb6de5cb157ba0bf6))
* refact the factory class ([c4ccf03](https://github.com/snowyu/custom-factory.js/commit/c4ccf0357f69bbeec7c1dccf7994ebfbd4ff2383))


### Bug Fixes

* lint error ([19846a9](https://github.com/snowyu/custom-factory.js/commit/19846a91896d234a46cb47dcfef9920df8752d5d))
* should add _children property to registered child factory ([724a111](https://github.com/snowyu/custom-factory.js/commit/724a1118edaeb9aacc0cf2562f67e881a608cba4))
