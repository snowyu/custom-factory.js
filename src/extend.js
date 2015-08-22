var defineProperty        = Object.defineProperty
if (!defineProperty)
  defineProperty = function (obj, key, descriptor){
    var value
    if (descriptor) value = descriptor.value
    obj[key] = value
  }

module.exports = extend

function extend(target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i]

    for (var key in source) {
      if (source.hasOwnProperty(key)) {
        defineProperty(target, key, {value:source[key],configurable:true,writable:true})
      }
    }
  }

  return target
}