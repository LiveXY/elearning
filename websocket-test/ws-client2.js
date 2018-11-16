//NODEJS ws库 客户端测试代码 二进制消息

const WebSocket = require('ws');
var ByteBuffer = require('./ByteBuffer');

const ws = new WebSocket('ws://127.0.0.1:3000');
var tools = require('./tools');

ws.on('open', function open() {
	console.log('连接服务器成功，向服务器发送登录消息！');
	login();
});

ws.on('message', function (message) {
	var buf = new ByteBuffer(message).bigEndian();
	var c = buf.getUint32();
	switch (c) {
		case tools.cmd.login:
			const rel = buf.getUint32();
			console.log('登录服务器成功！', rel);
			setTimeout(bigdata, 2000);
			break;
		case tools.cmd.laba:
			const laba = buf.getString();
			console.log('接收到广播：', laba);
			break;
	}
});

function login() {
	if (ws.readyState === WebSocket.OPEN) {
		ws.send(new ByteBuffer().uint32(tools.cmd.login).uint32(tools.randInt(10000, 99999)).pack());
	}
}

//测试大数据
function bigdata() {
	for (var i = 0; i < 10; i++) {
		var str = i + '->' + tools.randString(100, 10000);
		var data = new ByteBuffer().uint32(tools.cmd.bigdata).string(str).pack();
		console.log(str);
		ws.send(data);
	};
}
