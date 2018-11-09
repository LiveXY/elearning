const WebSocket = require('ws');

const ws = new WebSocket('ws://127.0.0.1:3000');
var cmd = require('./cmd');

ws.on('open', function open() {
    console.log('连接服务器成功，向服务器发送登录消息！');
    if (ws.readyState === WebSocket.OPEN)
        ws.send(JSON.stringify({ cmd: cmd.login, data: { uid: rand(10000, 99999) } }));
});

ws.on('message', function (message) {
    var body = JSON.parse(message);
    switch(body.cmd) {
        case cmd.login: console.log('登录服务器成功！', body.data); break;
        case cmd.laba: console.log('接收到广播：', body.data); break;
    }
});

function rand(min, max){
    return Math.floor(Math.random() * (max - min + 1) + min);
}