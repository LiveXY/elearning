var net = require('net');
var ExBuffer = require('./ExBuffer');
var ByteBuffer = require('./ByteBuffer');
var tools = require('./tools');
var clients = {};

var server = net.createServer(client => {
	var exBuffer = new ExBuffer().littleEndian().uint32Head();
	exBuffer.on('data', data => {
		var buf = new ByteBuffer(data).littleEndian();
		var c = buf.getUint32();
		switch (c) {
			case tools.cmd.login:
				const uid = buf.getUint32();
				client.uid = uid;
				console.log('请求登录:', uid, '，并回复客户端登录成功');
				client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.login).uint32(0).pack());

				clients[uid] = client;

				const laba = `${uid}上线了！`;
				console.log('广播', laba);
				broadcast(uid, new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.laba).string(laba).pack());
				break;
			case tools.cmd.bigdata:
				const data = buf.getString();
				console.log(data);
				break;
			case tools.cmd.friends:
				sendFriends(client);
				break;
		}
	});

	client.on('data', exBuffer.put);
	client.on('error', console.error);

});

function broadcast(uid, data) {
	for (var i in clients) {
		var client = clients[i];
		if (client && client.writable) client.write(data);
	}
}

function sendFriends(client) {
	var buf = new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.friends);
	buf.ushort(tools.friends.length);
	for (var i = 0, len = tools.friends.length; i < len; i++) {
		var o = tools.friends[i];
		buf.uint32(o.uid).string(o.nickname).string(o.avatar);
	}
	if (client && client.writable) client.write(buf.pack());
}

server.on('error', console.error);
server.listen(3000);
console.log('监听端口3000');
