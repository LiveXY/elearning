var net = require('net');
var fs = require('fs');
const protobuf = require('protocol-buffers');

var ExBuffer = require('./ExBuffer');
var ByteBuffer = require('./ByteBuffer');
var tools = require('./tools');

var exBuffer = new ExBuffer().uint32Head().littleEndian();
var messages = protobuf(fs.readFileSync('./messages.proto'));

var client = net.connect(3000, function() {
	console.log('连接服务器成功，向服务器发送登录消息！');
	var buf = messages.user.encode({ uid: tools.randInt(10000, 99999) });
	client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.login).buffer(buf).pack());
});

client.on('data', exBuffer.put);

exBuffer.on('data', function(data) {
	var buf = new ByteBuffer(data).littleEndian();
	var c = buf.getUint32();
	var buf = buf.getBuffer();
	switch (c) {
		case tools.cmd.login:
			var result = messages.result.decode(buf);
			console.log('登录服务器成功！', result.ret);
			setTimeout(bigdata, 2000);
			break;
		case tools.cmd.laba:
			const laba = buf.getString();
			console.log('接收到广播：', laba);
			break;
		case tools.cmd.friends:
			showFriends(buf);
			break;
	}
});

function bigdata() {
	for (var i = 0; i < 10; i++) {
		var str = i + '->' + tools.randString(100, 10000);
		console.log(str);
		if (client.writable) {
			var buf = messages.laba.encode({ data: str });
			client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.bigdata).buffer(buf).pack());
		}
	};
	getFriends();
}

function getFriends() {
	if (client.writable) {
		var buf = messages.user.encode({ uid: tools.randInt(10000, 99999) });
		client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.friends).buffer(buf).pack());
	}
}

function showFriends(buf) {
	var list = messages.friends.decode(buf);
	console.log('我的好友列表：', list);
}