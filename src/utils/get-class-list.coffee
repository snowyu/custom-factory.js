getParentClass        = require('./get-parent-class')

# get class list until root
getClassList = (ctor, root)->
  result = while ctor and ctor isnt root
    item = ctor::name
    ctor = getParentClass ctor
    item
# get class name list until root
getClassNameList = (ctor, root)->
  result = while ctor and ctor isnt root
    item = ctor
    ctor = getParentClass ctor
    item

exports = module.exports = getClassList

exports.getParentClass = getClassList
exports.getClassNameList = getClassNameList
