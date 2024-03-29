// package-scripts.js is a convention used by the 'nps' utility
// It's like package.json scripts, but more flexible.
// const { concurrent, series, runInNewWindow, rimraf } = require('nps-utils')
// const { series, rimraf } = require('nps-utils')
const fs = require('fs')
const path = require('path')
const glob = require('glob').globSync

function series(...scripts) {
  return scripts.filter(Boolean).join(' && ')
}

// const pkg = require('./package.json')

// extension should include the dot, for example '.html'
function changeExtension(file, extension) {
  const basename = path.basename(file, path.extname(file))
  return path.join(path.dirname(file), basename + extension)
}

function renameFileExt(path, extname) {
  fs.renameSync(path, changeExtension(path, extname))
}

function renameAllFileExt(path, extname) {
  const files = glob(path)
  files.forEach(f => renameFileExt(f, extname))
}

const transpile =
  'babel --config-file ./.babelrc.js --out-dir lib --ignore __tests__,__mocks__,**/*.spec.js,**/*.test.js src'
const cleanDist = "rimraf 'lib'"

// const retry = n => cmd =>
//   Array(n)
//     .fill(`(${cmd})`)
//     .join(' || ')
// const retry3 = retry(3)

const quote = (cmd) =>
  cmd.replace(new RegExp("'", 'g'), "\\'").replace(new RegExp('"', 'g'), '\\"')

const optional = (cmd) =>
  `(${cmd}) || echo "Optional command '${quote(cmd)}' failed".`

// const timeout = n => cmd => `timeout -t ${n}m -- ${cmd}`
// const timeout5 = timeout(5)

module.exports = {
  scripts: {
    clean: {
      default: {
        description: 'clear the libs folder',
        script: cleanDist,
      },
    },
    release: {
      default: 'npx standard-version',
      alpha: 'npx standard-version --prerelease alpha',
    },
    renameMjs: 'for f in `find lib/esm/*.js -iname "*.js" -type f -print`;do  mv "$f" ${f%.js}.mjs; done',
    build: {
      default: {
        description:
          'deletes the `lib` directory and transpiles all relevant `src` to the `lib`',
        script: series(cleanDist, 'nps build.swc', 'nps build.ts'),
      },
      babel: transpile,
      swc: {
        default: {
          description: 'transpiles to cjs(commonjs) and mjs(esm)',
          script: series('nps build.swc.cjs', 'nps build.swc.mjs'),
        },
        cjs: 'swc src -d lib/cjs -C module.type=commonjs',
        mjs: 'swc src -d lib/esm -C module.type=es6 && nps renameMjs',
        // mjs: 'swc src -d lib/esm -C module.type=es6 --out-file-extension .mjs', //the out-file-extension has not been merge https://github.com/swc-project/swc/issues/3067
      },
      ts: {
        description: 'build the typescript declaration files',
        script: series(
          'tsc',
          // 'npx remove-internal --outdir=./types types/*.d.ts'
        ),
      },
      watch: 'nps "build --watch"',
    },
    test: {
      default: 'jest --runInBand --config .jest.config.js',
      cov: 'nps "test --coverage"',
      watch: 'nps "test --watchAll"',
      coveralls: 'nps test.cov && cat ./.coverage/lcov.info | coveralls',
    },
    lint: {
      default: 'npx eslint --config .eslintrc.js .',
      fix: optional('nps "lint --fix"'),
    },
    doc: {
      description: 'generate the API Document',
      default: series('nps build', 'nps doc.md'),
      md: {
        description: 'generate the API Markdown Document',
        script: series('npx typedoc'),
      },
      html: {
        description: 'generate the API HTML Document',
        script: series('npx typedoc --plugin none'),
      },
    },
  },
}
