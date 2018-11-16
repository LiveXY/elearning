//NODEJS websocket 服务器端测试代码 字符串消息和二进制消息

var WebSocketServer = require('websocket').server;
var ByteBuffer = require('./ByteBuffer');

var http = require('http');
var tools = require('./tools');
var clients = {};

var server = http.createServer(function(request, response) {
	console.log('接收到HTTP请求：' + request.url);
	response.writeHead(404);
	response.end();
});
server.listen(3000, function() {
	console.log('监听端口3000');
});

wsServer = new WebSocketServer({
	httpServer: server,
	autoAcceptConnections: false
});

wsServer.on('request', function(request) {
	var ws = request.accept();
	console.log(ws.remoteAddress, '连接成功!');

	ws.on('message', function(message) {
		if (message.type === 'utf8') {
			var body = JSON.parse(message.utf8Data);
			switch(body.cmd) {
				case tools.cmd.login:
					var uid = body.data.uid;
					ws.uid = uid;
					clients[uid] = ws;
					console.log(ws.remoteAddress, '请求登录:', body.data, '，并回复客户端登录成功');
					ws.sendUTF(JSON.stringify({ cmd: tools.cmd.login, data: { ret: 0 } }));

					const laba = `${body.data.uid}上线了！`;
					console.log('广播', laba);
					broadcastUTF(ws.uid, JSON.stringify({ cmd: tools.cmd.laba, data: laba }));
					break;
				case tools.cmd.bigdata:
					console.log(body.data);
					break;
			}
		} else if (message.type === 'binary') {
			console.log(ws.remoteAddress, '接收二进制消息：' + message.binaryData.length + ' 字节');
			var buf = new ByteBuffer(message.binaryData).bigEndian();
			var c = buf.getUint32();
			switch(c) {
				case tools.cmd.login:
					const uid = buf.getUint32();
					ws.uid = uid;
					clients[uid] = ws;
					console.log('请求登录:', uid, '，并回复客户端登录成功');
					ws.sendBytes(new ByteBuffer().uint32(tools.cmd.login).uint32(0).pack());

					const laba = `${uid}上线了！`;
					console.log('广播', laba);
					broadcastBytes(ws.uid, new ByteBuffer().uint32(tools.cmd.laba).string(laba).pack());
					break;
				case tools.cmd.bigdata:
					const data = buf.getString();
					console.log(data);
					break;
			}
		}
	});
	ws.on('close', function(reasonCode, description) {
		delete clients[ws.uid];
		console.log(ws.remoteAddress, '断开连接');
	});

	function broadcastUTF(uid, data) {
		for(var i in clients) if (i != uid) clients[i].sendUTF(data);
	}
	function broadcastBytes(uid, data) {
		for(var i in clients) if (i != uid) clients[i].sendBytes(data);
	}
});