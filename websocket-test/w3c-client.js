var W3CWebSocket = require('websocket').w3cwebsocket;

var client = new W3CWebSocket('ws://127.0.0.1:3000/', 'echo-protocol');

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
            case 'login': console.log('登录服务器成功！', body.data); break;
        }
    }
}

client.onclose = function() {
    console.log('断开连接');
}

function login() {
    if (client.readyState === client.OPEN)
        client.send(JSON.stringify({ cmd: 'login', data: { uid: rand(10000, 99999) } }));
}

function rand(min, max){
	return Math.floor(Math.random() * (max - min + 1) + min);
}
