var WebSocketServer = require('websocket').server;
var http = require('http');
var cmd = require('./cmd');

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
    var connection = request.accept('echo-protocol', request.origin);
    console.log(connection.remoteAddress, '连接成功!');

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            var body = JSON.parse(message.utf8Data);
            switch(body.cmd) {
            	case cmd.login:
            		console.log(connection.remoteAddress, '请求登录:', body.data, '，并回复客户端登录成功');
            		connection.sendUTF(JSON.stringify({ cmd: cmd.login, data: { ret: 0 } }));
            		break;
            }
        }
        else if (message.type === 'binary') {
            console.log(connection.remoteAddress, '接收二进制消息：' + message.binaryData.length + ' bytes');
            switch(message.binaryData.readUInt32BE(0)) {
                case cmd.login:
                    const uid = message.binaryData.readUInt32BE(4);
                    console.log(connection.remoteAddress, '请求登录:', uid, '，并回复客户端登录成功');

                    var buffer = new Buffer(8);
                    buffer.writeUInt32BE(cmd.login, 0);
                    buffer.writeUInt32BE(0, 4);
                    connection.sendBytes(buffer);
                    break;
            }
        }
    });
    connection.on('close', function(reasonCode, description) {
        console.log(connection.remoteAddress, '断开连接');
    });
});