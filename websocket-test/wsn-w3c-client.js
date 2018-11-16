//NODEJS websocket 客户端测试代码 字符串消息

var W3CWebSocket = require('websocket').w3cwebsocket;

var client = new W3CWebSocket('ws://127.0.0.1:3000/');
var tools = require('./tools');

client.onerror = function(error) {
	console.log('连接错误：', error);
};

client.onopen = function() {
	console.log('连接服务器成功，向服务器发送登录消息！');
	login();
};

client.onmessage = function(e) {
	if (typeof e.data === 'string') {
		var body = JSON.parse(e.data);
		switch(body.cmd) {
			case tools.cmd.login:
				console.log('登录服务器成功！', body.data);
				setTimeout(bigdata, 2000);
				break;
			case tools.cmd.laba: console.log('接收到广播：', body.data); break;
		}
	}
}

client.onclose = function() {
	console.log('断开连接');
}

function login() {
	if (client.readyState === client.OPEN)
		client.send(JSON.stringify({ cmd: tools.cmd.login, data: { uid: tools.randInt(10000, 99999) } }));
}

//测试大数据
function bigdata() {
	for (var i = 0; i < 10; i++) {
		var str = i + '->' + tools.randString(100, 10000);
		console.log(str);
		if (client.readyState === client.OPEN)
			client.send(JSON.stringify({ cmd: tools.cmd.bigdata, data: str }));
	};
}