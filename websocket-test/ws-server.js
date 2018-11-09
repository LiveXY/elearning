const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 3000 });
var cmd = require('./cmd');

wss.on('connection', function (ws) {
    console.log('连接成功!');

    ws.on('message', function (message) {
        if (typeof message === 'string') {
            var body = JSON.parse(message);
            switch(body.cmd) {
                case cmd.login:
                    console.log('请求登录:', body.data, '，并回复客户端登录成功');
                    if (ws.readyState === WebSocket.OPEN) {
                        ws.uid = body.data.uid;
                        ws.send(JSON.stringify({ cmd: cmd.login, data: { ret: 0 } }));

                        const laba = `${body.data.uid}上线了！`;
                        console.log('广播', laba);
                        wss.broadcast(ws.uid, JSON.stringify({ cmd: cmd.laba, data: laba }));
                    }
                    break;
            }
        } else if (message instanceof Buffer) {
            console.log('接收二进制消息：' + message.length + ' bytes');
            switch (message.readUInt32BE(0)) {
                case cmd.login:
                    const uid = message.readUInt32BE(4);
                    ws.uid = uid;
                    console.log('请求登录:', uid, '，并回复客户端登录成功');

                    var b1 = new Buffer(8);
                    b1.writeUInt32BE(cmd.login, 0);
                    b1.writeUInt32BE(0, 4);
                    ws.send(b1);

                    const laba = `${uid}上线了！`;
                    console.log('广播', laba);
                    var b2 = new Buffer(4);
                    b2.writeUInt32BE(cmd.laba, 0);
                    var b3 = new Buffer.from(laba);
                    var b4 = Buffer.concat([b2, b3]);
                    console.log(b4);
                    wss.broadcast(0, b4);
                    break;
            }
        }
    });

});

wss.broadcast = function (uid, data) {
    wss.clients.forEach(function (client) {
        if (client.uid !== uid && client.readyState === WebSocket.OPEN) client.send(data);
    });
};

console.log('监听端口3000');