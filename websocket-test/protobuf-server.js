var net = require('net');
var fs = require('fs');
const protobuf = require('protocol-buffers');

var ExBuffer = require('./ExBuffer');
var ByteBuffer = require('./ByteBuffer');
var tools = require('./tools');

var clients = {};
var messages = protobuf(fs.readFileSync('./messages.proto'));

var server = net.createServer(client => {
	var exBuffer = new ExBuffer().littleEndian().uint32Head();
	exBuffer.on('data', data => {
		var buf = new ByteBuffer(data).littleEndian();
		var c = buf.getUint32();
		var buf = buf.getBuffer();
		switch (c) {
			case tools.cmd.login:
				var user = messages.user.decode(buf);
				client.uid = user.uid;
				console.log('请求登录:', user.uid, '，并回复客户端登录成功');

				var buf = messages.result.encode({ ret: 0 });
				client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.login).buffer(buf).pack());

				clients[user.uid] = client;

				var laba = `${user.uid}上线了！`;
				console.log('广播', laba);
				var buf = messages.laba.encode({ data: laba });
				broadcast(user.uid, new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.laba).buffer(buf).pack());
				break;
			case tools.cmd.bigdata:
				var laba = messages.laba.decode(buf);
				console.log(laba.data);
				break;
			case tools.cmd.friends:
				var user = messages.user.decode(buf);
				console.log('获取好友信息：', user);
				sendFriends(client);
				break;
		}
	});

	client.on('data', exBuffer.put);
	client.on('error', console.error);

});

function broadcast(uid, data) {
	clients.forEach(function (client) {
		if (client && client.writable && client.uid !== uid) client.write(data);
	});
}

function sendFriends(client) {
	var buf = messages.friends.encode({ list: tools.friends });
	if (client && client.writable) client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.friends).buffer(buf).pack());
}

server.on('error', console.error);
server.listen(3000);
console.log('监听端口3000');
