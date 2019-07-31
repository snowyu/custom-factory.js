getPrototypeOf = require('inherits-ex/lib/getPrototypeOf')

getParentClass = (ctor)-> ctor.super_ || getPrototypeOf(ctor)
exports = module.exports = getParentClass

exports.getParentClass = getParentClass
