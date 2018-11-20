var tools = require('../../tools');

module.exports = function(context) {
	return {
		friends: function(uid, cb) {
			cb(null, tools.friends);
		}
	};
};