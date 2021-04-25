const {
  engines: { node },
} = require('./package.json')

const presets = [
  [
    '@babel/env',
    {
      // Require the highest node version you can.
      // You should use at least a node version which
      // supports async/await because Babel has been
      // configured without polyfills/generators for
      // async/await.
      targets: {
        node: node.substring(2), // Strip `>=`
      },
      // "modules": false, // disable strict mode
    },
  ],
  // If you are not using flow remove the following line.
  '@babel/preset-flow',
]

const plugins = [
  '@babel/plugin-proposal-class-properties',
  ['@babel/plugin-transform-modules-commonjs', { strictMode: false }],
  // ['@babel/plugin-transform-classes', {}],
  // ['babel-plugin-transform-class', {}],
  [
    'module-resolver',
    {
      root: ['./src'],
      alias: {
        '@lib': './src/lib',
      },
    },
  ],
  // ['@babel/plugin-transform-runtime', {
  //   "absoluteRuntime": false,
  //   'corejs': false,
  //   'helpers': false,
  //   "regenerator": true,
  // }],
]

module.exports = {
  presets,
  plugins,

  // For compatibility we generate inline source maps _and_
  // source maps in dedicated files. However due to a bug in babel
  // this option is not honored at the moment.
  sourceMaps: 'both',

  // Retaining lines increases debugability but may lead to less
  // readable source code. However if you have to debug for whatever
  // reason it is better to have the lines match up than to have
  // nicer source code.
  retainLines: true,
}
