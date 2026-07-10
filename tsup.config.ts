import { defineConfig } from 'tsup'

export default defineConfig({
  entry: ['src/index.js'],
  format: ['cjs', 'esm'],
  outDir: 'lib',
  dts: true,
  splitting: false,
  sourcemap: false,
  clean: true,
  target: 'es2015',
  platform: 'node',
  external: ['inherits-ex', 'custom-ability'],
})
