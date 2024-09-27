const http = require('http')
const path = require('path')
const fs = require('fs')

const server = http.createServer((request, response) => {
	switch (request.url) {
	case '/':
	case '/index.html':
		response.writeHead(200, {
			'Content-Type': 'text/html; charset=utf8',
			'Cross-Origin-Opener-Policy': 'same-origin',
			'Cross-Origin-Embedder-Policy': 'require-corp',
		})
		response.write(fs.readFileSync(path.resolve(__dirname, 'index.html')))
		break
	case '/worker.js':
		response.writeHead(200, {
			'Content-Type': 'application/javascript; charset=utf8',
			'Cross-Origin-Opener-Policy': 'same-origin',
			'Cross-Origin-Embedder-Policy': 'require-corp',
		})
		response.write(fs.readFileSync(path.resolve(__dirname, 'worker.js')))
		break
	case '/lib.js':
		response.writeHead(200, {
			'Content-Type': 'application/javascript; charset=utf8',
			'Cross-Origin-Opener-Policy': 'same-origin',
			'Cross-Origin-Embedder-Policy': 'require-corp',
		})
		response.write(fs.readFileSync(path.resolve(__dirname, '../../dist/web/index.js')))
		break
	default:
		response.writeHead(404, {
			'Content-Type': 'text/plain; charset=utf8'
		})
		response.write('404 Not Found')
		break
	}
	response.end()
})

server.listen(8080)

console.log('server running at http://localhost:8080/')
