var prpc = require('./prpc');
var tools = require('./tools');

var app = new prpc();
app.registerClient('connector', function() {
	console.log('连接服务器成功，向服务器发送登录消息！');
	app.rpc.connector.user.login(null, { uid: tools.randInt(10000, 99999) }, function(err, r) {
		console.log('登录服务器成功！', r);

		app.rpc.connector.user.friends(null, { uid: tools.randInt(10000, 99999) }, function(err, r) {
			console.log('获取好友数据！', r);
		});
	});
});



