var prpc = require('./prpc');
var tools = require('./tools');

var app = new prpc();
app.registerServer();
app.registerClient('data');
