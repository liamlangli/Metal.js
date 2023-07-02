const { build } = require("esbuild")
const { exec } = require('child_process');

exec('rm -rf ../Metal.js/js/example');
build({
    entryPoints: [
        "src/index.ts",
    ],
    bundle: true,
    minify: true,
    treeShaking: true,
    outdir: "../Metal.js/js/example",
}).catch(() => process.exit(1))