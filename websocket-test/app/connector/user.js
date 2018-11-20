module.exports = function(app) {
	return {
		login: function(data, cb) {
			cb(null, { ret: 0 });
		},
		friends: function(data, cb) {
			app.rpc.data.db.friends(null, data.uid, cb);
		}
	};
};