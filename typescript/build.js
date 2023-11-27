import { context } from 'esbuild';
import http from 'node:http';

let ctx = await context({
    entryPoints: [
        'example/index.ts'
    ],
    bundle: true,
    sourcemap: true,
    outdir: 'public',
    external: ['acorn']
});

let { host, port } = await ctx.serve({ servedir: 'public' });

http.createServer((request, response) => {
    const options = {
        hostname: host,
        port: port,
        path: request.url,
        method: request.method,
        headers: request.headers,
    }

    // Forward each incoming request to esbuild
    const proxy_request = http.request(options, proxy_response => {
        if (proxy_response.statusCode === 404) {
            response.writeHead(404, { 'Content-Type': 'text/html' })
            response.end('<h1>A custom 404 page</h1>')
            return
        }

        // Otherwise, forward the response from esbuild to the client
        proxy_response.headers['Cross-Origin-Opener-Policy'] = 'same-origin';
        proxy_response.headers['Cross-Origin-Embedder-Policy'] = 'require-corp';
        response.writeHead(proxy_response.statusCode, proxy_response.headers);
        proxy_response.pipe(response, { end: true });
    })

    request.pipe(proxy_request, { end: true });
}).listen(3000)

console.log(`listen at ${host}:${3000}`);