function test_array() {
	const list = [];
	const max = 1000000
	for (let i = 0; i < max; i++) list.push(i);
	console.log('array [] list length', max);

	console.time('for<len');
	for (let i = 0, len = list.length; i < len; i++) ;
	console.timeEnd('for<len');

	console.time('for<list.length');
	for (let i = 0; i < list.length; i++) ;
	console.timeEnd('for<list.length');

	console.time('for of');
	for (let i of list) ;
	console.timeEnd('for of');

	console.time('forEach');
	list.forEach((item, i) => { });
	console.timeEnd('forEach');

	console.time('for in');
	for (let i in list) ;
	console.timeEnd('for in');
}
function test_object() {
	const list = {};
	const max = 1000000
	for (let i = 0; i < max; i++) list[i] = i;
	console.log('object {} list length', max);

	console.time('forEach');
	const keys = Object.keys(list);
	keys.forEach(() => {});
	console.timeEnd('forEach');

	console.time('for of');
	const keys2 = Object.keys(list);
	for (let i of keys2) ;
	console.timeEnd('for of');

	console.time('for in');
	for (let i in list) ;
	console.timeEnd('for in');
}
function test_object2() {
	const list = {};
	const max = 1000000
	for (let i = 0; i < max; i++) list[i] = i;
	console.log('object {} list length', max);


	console.time('forEach');
	const keys = Object.keys(list);
	keys.forEach(() => {});
	keys.forEach(() => {});
	console.timeEnd('forEach');

	console.time('for of');
	const keys2 = Object.keys(list);
	for (let i of keys2) ;
	for (let i of keys2) ;
	console.timeEnd('for of');

	console.time('for in');
	for (let i in list) ;
	for (let i in list) ;
	console.timeEnd('for in');
}
function test_switch() {
	var cmd = {};
	for (let i = 0; i < 6; i++) cmd[i] = function(i) {};

	const list = {};
	const max = 10000000
	for (let i = 0; i < max; i++) list[i] = Math.floor(Math.random() * 6); //rand 0-5
	console.log('object {} list length', max);

	console.time('kv');
	for (let i in list) {
		const v = list[i];
		if (cmd[v]) cmd[v](v);
	}
	console.timeEnd('kv');

	console.time('if');
	for (let i in list) {
		const v = list[i];
		if (v == 0) cmd[v](v);
		else if (v == 1) cmd[v](v);
		else if (v == 2) cmd[v](v);
		else if (v == 3) cmd[v](v);
		else if (v == 4) cmd[v](v);
		else if (v == 5) cmd[v](v);
	}
	console.timeEnd('if');

	console.time('switch');
	for (let i in list) {
		const v = list[i];
		switch(v) {
			case 0: cmd[v](v); break;
			case 1: cmd[v](v); break;
			case 2: cmd[v](v); break;
			case 3: cmd[v](v); break;
			case 4: cmd[v](v); break;
			case 5: cmd[v](v); break;
		}
	}
	console.timeEnd('switch');
}

//test_object();
//test_object2();
//test_array();
test_switch();