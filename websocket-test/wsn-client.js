var WebSocketClient = require('websocket').client;

var client = new WebSocketClient();
var cmd = require('./cmd');

client.on('connectFailed', function(error) {
    console.log('连接错误：' + error.toString());
});

client.on('connect', function(connection) {

    connection.on('error', function(error) {
        console.log('连接错误：' + error.toString());
    });

    connection.on('close', function() {
        console.log('断开连接');
    });

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            var body = JSON.parse(message.utf8Data);
            switch(body.cmd) {
            	case cmd.login: console.log('登录服务器成功！', body.data); break;
            }
        }
    });

    function login() {
        if (connection.connected) connection.sendUTF(JSON.stringify({ cmd: cmd.login, data: { uid: rand(10000, 99999) } }));
    }

    console.log('连接服务器成功，向服务器发送登录消息！');
    login();
});

client.connect('ws://localhost:3000/', 'echo-protocol');

function rand(min, max){
	return Math.floor(Math.random() * (max - min + 1) + min);
}
