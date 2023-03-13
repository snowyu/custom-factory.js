module.exports = {
  // rootDir: 'src/',
  // verbose: true,
  // collectCoverage: true,
  coverageDirectory: '.coverage',
  // coverageReporters: ['json', 'html', 'lcov'],
  collectCoverageFrom: ['src/**/*.js'],
  coveragePathIgnorePatterns: ['.jest.config.cjs', 'src/index.js'],
  // Fail if there is less than 20% branch, line, and function coverage,
  // or if there are more than 20 uncovered statements:
  coverageThreshold: {
    global: {
      branches: 20,
      functions: 20,
      lines: 20,
      statements: -10,
    },
  },
  transform: {
    '^.+\\.js$': '@swc/jest',
  },
  testMatch: [
    // '<rootDir>/test/jest/__tests__/**/*.spec.js',
    // '<rootDir>/test/jest/__tests__/**/*.test.js',
    '<rootDir>/src/**/__tests__/*_jest.spec.(t|j)s',
    '<rootDir>/src/**/*.(spec|test).(t|j)s',
    // '<rootDir>/src/**/__tests__/*_jest.spec.ts',
    '<rootDir>/test/jest/__tests__/**/*.(spec|test).(t|j)s',
    // '<rootDir>/test/jest/__tests__/**/*.test.js',
  ],
  moduleFileExtensions: ['js'],
  setupFilesAfterEnv: ['jest-extended'],
}
