//NODEJS ws库 客户端测试代码 字符串消息

const WebSocket = require('ws');

const ws = new WebSocket('ws://127.0.0.1:3000');
var tools = require('./tools');

ws.on('open', function open() {
	console.log('连接服务器成功，向服务器发送登录消息！');
	login();
});

ws.on('message', function (message) {
	var body = JSON.parse(message);
	switch(body.cmd) {
		case tools.cmd.login:
			console.log('登录服务器成功！', body.data);
			setTimeout(bigdata, 2000);
			break;
		case tools.cmd.laba: console.log('接收到广播：', body.data); break;
	}
});

function login() {
	if (ws.readyState === WebSocket.OPEN)
		ws.send(JSON.stringify({ cmd: tools.cmd.login, data: { uid: tools.randInt(10000, 99999) } }));
}

//测试大数据
function bigdata() {
	for (var i = 0; i < 10; i++) {
		var str = i + '->' + tools.randString(100, 10000);
		console.log(str);
		if (ws.readyState === WebSocket.OPEN)
			ws.send(JSON.stringify({ cmd: tools.cmd.bigdata, data: str }));
	};
}


