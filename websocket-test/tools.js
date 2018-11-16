var tools = {
	cmd: {
		login: 10000,
		laba: 10001,
		bigdata: 10002,
		friends: 10003
	},
	randInt: function (min, max) {
		return Math.floor(Math.random() * (max - min + 1) + min);
	},
	randString: function (min, max) {
		var str = "", range = this.randInt(min, max), arr = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
		for (var i = 0; i < range; i++) {
			pos = Math.round(Math.random() * (arr.length-1));
			str += arr[pos];
		}
		return str;
	},
	friends: [
		{ uid: 1, nickname: '11', avatar: '111' },
		{ uid: 2, nickname: '22', avatar: '222' },
		{ uid: 3, nickname: '33', avatar: '333' }
	]
}

try {
module.exports = tools;
} catch (r) {}