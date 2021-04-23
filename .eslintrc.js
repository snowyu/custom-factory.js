module.exports = {
  'parser': '@babel/eslint-parser',
  'plugins': [
    'prettier',
    'flowtype'
  ],
  'extends': [
    'plugin:prettier/recommended',
    'plugin:flowtype/recommended'
  ],
  'rules': {
    'no-unused-vars': 'error',
    'prettier/prettier': 'error'
  },
  'settings': {
    'flowtype': {
      'onlyFilesWithFlowAnnotation': true
    }
  },
  overrides: [{
    files: ['*.ts', '*.tsx'],
    parser: '@typescript-eslint/parser',
    plugins: [
      'prettier',
      '@typescript-eslint',
    ],
    extends: [
      'plugin:prettier/recommended',
      'eslint:recommended',
      'plugin:@typescript-eslint/recommended',
    ],
  }]
};
