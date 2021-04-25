module.exports = {
  parser: '@babel/eslint-parser',
  plugins: ['prettier'],
  extends: ['plugin:prettier/recommended'],
  rules: {
    'no-unused-vars': 'error',
    'prettier/prettier': 'error',
  },
  settings: {},
  overrides: [
    {
      files: ['*.ts', '*.tsx'],
      parser: '@typescript-eslint/parser',
      plugins: ['prettier', '@typescript-eslint'],
      extends: [
        'plugin:prettier/recommended',
        'eslint:recommended',
        'plugin:@typescript-eslint/recommended',
      ],
    },
  ],
}
