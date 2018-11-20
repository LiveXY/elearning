var Server = require('pomelo-rpc').server;
var Client = require('pomelo-rpc').client;
var tools = require('./tools');
var config = require('./servers.json');

function application() {
	var app = this;
	this.registerClient = function(serverType, cb) {
		if (!config[serverType]) return;

		var records = [], servers = [];
		records.push({namespace: 'app', serverType: serverType, path: __dirname + '/app/' + serverType});
		config[serverType].forEach(function(s){ s.serverType = serverType; servers.push(s); });

		var client = Client.create({router: function(session, msg, app, cb) {
			var serverId = servers[tools.randInt(0, servers.length - 1)].id;
			cb(null, serverId);
		}, context: app, routeContext: app});

		client.start(function(err) {
			client.addProxies(records);
			client.addServers(servers);

			if (!app.rpc) app.rpc = {};
			app.rpc[serverType] = client.proxies.app[serverType];
			if (cb) cb();
		});
	}
	this.startServer = function (s) {
		var path = __dirname + '/app/' + s.serverType;
		app.server = Server.create({paths: [{namespace: 'app', serverType: s.serverType, path: path}], port: s.port, context: app});
		app.server.start();
		console.log(s.id, '启动成功，端口:', s.port);
	}
	this.registerServer = function() {
		for (var type in config) config[type].forEach(function(s){
			s.serverType = type;
			app.startServer(s);
		});
	}
}

module.exports = application;
