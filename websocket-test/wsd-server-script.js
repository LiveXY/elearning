//NODEJS websocketd 服务器端脚本测试代码 字符串消息
var tools = require('./tools');

process.stdin.resume()
process.stdin.setEncoding('utf8')

process.stdin.on( 'data', function( data ) {
	var body = JSON.parse(data);
	switch(body.cmd) {
		case tools.cmd.login:
			process.stdout.write(JSON.stringify({ cmd: tools.cmd.login, data: { ret: 0 } }) + '\n')
			break;
	}
})


//websocketd --port=3000 node wsd-server-script.js
