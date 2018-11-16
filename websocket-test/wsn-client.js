//NODEJS websocket 客户端测试代码 字符串消息

var WebSocketClient = require('websocket').client;

var client = new WebSocketClient();
var tools = require('./tools');

client.on('connectFailed', function(error) {
	console.log('连接错误：' + error.toString());
});

client.on('connect', function(ws) {

	ws.on('error', function(error) {
		console.log('连接错误：' + error.toString());
	});

	ws.on('close', function() {
		console.log('断开连接');
	});

	ws.on('message', function(message) {
		if (message.type === 'utf8') {
			var body = JSON.parse(message.utf8Data);
			switch(body.cmd) {
				case tools.cmd.login:
					console.log('登录服务器成功！', body.data);
					setTimeout(bigdata, 2000);
					break;
				case tools.cmd.laba: console.log('接收到广播：', body.data); break;
			}
		}
	});

	function login() {
		if (ws.connected) ws.sendUTF(JSON.stringify({ cmd: tools.cmd.login, data: { uid: tools.randInt(10000, 99999) } }));
	}

	//测试大数据
	function bigdata() {
		for (var i = 0; i < 10; i++) {
			var str = i + '->' + tools.randString(100, 10000);
			console.log(str);
			if (ws.connected)
				ws.sendUTF(JSON.stringify({ cmd: tools.cmd.bigdata, data: str }));
		};
	}
	console.log('连接服务器成功，向服务器发送登录消息！');
	login();
});

client.connect('ws://localhost:3000/');
