const { build } = require("esbuild")

build({
    entryPoints: [
        "src/index.ts",
    ],
    bundle: true,
    minify: true,
    treeShaking: true,
    outdir: "./dist",
}).catch(() => process.exit(1))