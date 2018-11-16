//NODEJS ws库 服务器端测试代码 支持字符串消息和二进制消息

const WebSocket = require('ws');
var ByteBuffer = require('./ByteBuffer');

const wss = new WebSocket.Server({ port: 3000 });
var tools = require('./tools');

wss.on('connection', function (ws) {
	console.log('连接成功!');

	ws.on('message', function (message) {
		if (typeof message === 'string') {
			console.log('接收字符串消息：' + message.length + ' 字符');
			var body = JSON.parse(message);
			switch(body.cmd) {
				case tools.cmd.login:
					console.log('请求登录:', body.data, '，并回复客户端登录成功');
					if (ws.readyState === WebSocket.OPEN) {
						ws.uid = body.data.uid;
						ws.send(JSON.stringify({ cmd: tools.cmd.login, data: { ret: 0 } }));

						const laba = `${body.data.uid}上线了！`;
						console.log('广播', laba);
						wss.broadcast(ws.uid, JSON.stringify({ cmd: tools.cmd.laba, data: laba }));
					}
					break;
				case tools.cmd.bigdata:
					console.log(body.data);
					break;
				case tools.cmd.friends:
					ws.send(JSON.stringify({ cmd: tools.cmd.friends, data: tools.friends }));
					break;
			}
		} else if (message instanceof Buffer) {
			console.log('接收二进制消息：' + message.length + ' 字节');
			var buf = new ByteBuffer(message).bigEndian();
			var c = buf.getUint32();
			switch (c) {
				case tools.cmd.login:
					const uid = buf.getUint32();
					ws.uid = uid;
					console.log('请求登录:', uid, '，并回复客户端登录成功');
					ws.send(new ByteBuffer().uint32(tools.cmd.login).uint32(0).pack());

					const laba = `${uid}上线了！`;
					console.log('广播', laba);
					wss.broadcast(ws.uid, new ByteBuffer().uint32(tools.cmd.laba).string(laba).pack());
					break;
				case tools.cmd.bigdata:
					const data = buf.getString();
					console.log(data);
					break;
				case tools.cmd.friends:
					sendFriends(ws);
					break;
			}
		}
	});

});

wss.broadcast = function (uid, data) {
	wss.clients.forEach(function (ws) {
		if (ws.uid !== uid && ws.readyState === WebSocket.OPEN) ws.send(data);
	});
};

function sendFriends(ws) {
	var buf = new ByteBuffer().uint32(tools.cmd.friends);
	buf.ushort(tools.friends.length);
	for (var i = 0, len = tools.friends.length; i < len; i++) {
		var o = tools.friends[i];
		buf.uint32(o.uid).string(o.nickname).string(o.avatar);
	}
	if (ws.readyState === WebSocket.OPEN) ws.send(buf.pack());
}

console.log('监听端口3000');