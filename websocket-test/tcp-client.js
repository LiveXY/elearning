var net = require('net');
var ExBuffer = require('./ExBuffer');
var ByteBuffer = require('./ByteBuffer');
var tools = require('./tools');

var exBuffer = new ExBuffer().uint32Head().littleEndian();

var client = net.connect(3000, function() {
	console.log('连接服务器成功，向服务器发送登录消息！');

	client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.login).uint32(tools.randInt(10000, 99999)).pack());
});

client.on('data', exBuffer.put);

exBuffer.on('data', function(data) {
	var buf = new ByteBuffer(data).littleEndian();
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
		case tools.cmd.friends:
			showFriends(buf);
			break;
	}
});

function bigdata() {
	for (var i = 0; i < 10; i++) {
		var str = i + '->' + tools.randString(100, 10000);
		console.log(str);
		if (client.writable) client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.bigdata).string(str).pack());
	};
	getFriends();
}

function getFriends() {
	if (client.writable)
		client.write(new ByteBuffer().littleEndian().uint32Head().uint32(tools.cmd.friends).uint32(tools.randInt(10000, 99999)).pack());
}

function showFriends(buf) {
	var list = [];
	var len = buf.getUshort();
	if (len > 0) for (var i = 0; i < len; i++) {
		var uid = buf.getUint32();
		var nickname = buf.getString();
		var avatar = buf.getString();
		list.push({uid: uid, nickname: nickname, avatar: avatar});
	}
	console.log('我的好友列表：', list);
}