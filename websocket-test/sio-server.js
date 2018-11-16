//NODEJS socket.io 服务器端测试代码 JSON消息

const server = require('http').createServer();
const io = require('socket.io')(server);
var tools = require('./tools');

io.on('connection', client => {
	console.log(client.id, '连接成功!');

	client.on(tools.cmd.login, (data, cb) => {
		client.uid = data.uid;
		console.log(client.id, '请求登录:', data, '，并回复客户端登录成功');
		cb({ ret: 0 });

		const laba = `${data.uid}上线了！`;
		console.log('广播', laba);
		client.broadcast.emit(tools.cmd.laba, laba);
	});

	client.on(tools.cmd.bigdata, data => {
		console.log(data);
	});

	client.on('disconnect', () => {
		console.log(client.id, '断开连接');
	});

});

server.listen(3000);
console.log('监听端口3000');
