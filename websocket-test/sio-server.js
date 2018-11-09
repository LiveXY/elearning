const server = require('http').createServer();
const io = require('socket.io')(server);

io.on('connection', client => {
	console.log(client.id, '连接成功!');

	client.on('login', (data, cb) => {
		client.uid = data.uid;
		console.log(client.id, '请求登录:', data, '，并回复客户端登录成功');
		cb({ ret: 0 });

		const laba = `${data.uid}上线了！`;
		console.log('广播', laba);
		client.broadcast.emit('laba', laba);
	});

	client.on('disconnect', () => {
		console.log(client.id, '断开连接');
	});

});

server.listen(3000);
console.log('监听端口3000');
