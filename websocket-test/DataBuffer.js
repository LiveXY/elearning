'use strict';

if (!ArrayBuffer.prototype.slice) {
	ArrayBuffer.prototype.slice = function (start, end) {
		var that = new Uint8Array(this);
		if (end == undefined) end = that.length;
		var result = new ArrayBuffer(end - start);
		var resultArray = new Uint8Array(result);
		for (var i = 0; i < resultArray.length; i++)
			resultArray[i] = that[i + start];
		return result;
	}
}

var DataBuffer = function (arrayBuffer, offset) {
	var ByteType = 1;
	var ShortType = 2;
	var UShortType = 3;
	var Int32Type = 4;
	var UInt32Type = 5;
	var StringType = 6;
	var VStringType = 7;
	var Int64Type = 8;
	var FloatType = 9;
	var DoubleType = 10;
	var ByteArrayType = 11;
	var BufferType = 12;

	var dataView = arrayBuffer ? (arrayBuffer.constructor == DataView ? arrayBuffer : (arrayBuffer.constructor == Uint8Array ? new DataView(arrayBuffer.buffer, offset) : new DataView(arrayBuffer, offset))) : new DataView(new Uint8Array([]).buffer);
	offset = offset || 0;
	var list = [];
	var littleEndian = false;
	var headLen = 0;

	//指定字节序 为BigEndian
	this.bigEndian = function() { return littleEndian = false, this; };

	//指定字节序 为LittleEndian
	this.littleEndian = function() { return littleEndian = true, this; };

	//指定包头长度
	this.uint32Head = function() { return headLen = 4, this; }
	this.ushortHead = function() { return headLen = 2, this; }

	//获取一个字节
	this.getByte = function() { return offset += 1, dataView.getUint8(offset - 1, littleEndian); }
	this.byte = function (val, index) {
		if (arguments.length == 0) list.push(this.getByte());
		else splice(ByteType, val, 1, index)
		return this;
	};

	//获取Short数据
	this.getShort = function() { return read('getInt16', 2); }
	this.short = function(val, index) {
		if (arguments.length == 0) list.push(this.getShort());
		else splice(ShortType, val, 2, index);
		return this;
	};

	//获取Ushort数据
	this.getUshort = function() { return read('getUint16', 2); }
	this.ushort = function(val, index) {
		if (arguments.length == 0) list.push(this.getUshort());
		else splice(UShortType, val, 2, index);
		return this;
	};

	//获取Int32数据
	this.getInt32 = function () { return read('getInt32', 4); }
	this.int32 = function(val, index) {
		if (arguments.length == 0) list.push(this.getInt32());
		else splice(Int32Type, val, 4, index);
		return this;
	};

	//获取Uint32数据
	this.getUint32 = function() { return read('getUint32', 4); }
	this.uint32 = function(val, index) {
		if (arguments.length == 0) list.push(this.getUint32());
		else splice(UInt32Type, val, 4, index);
		return this;
	};

	//获取Uint64数据
	this.getInt64 = function () { return read('getFloat64', 8); }
	this.int64 = function(val, index) {
		if (arguments.length == 0) list.push(this.getInt64());
		else splice(Int64Type, val, 8, index);
		return this;
	};

	//获取Float数据
	this.getFloat = function() { return read('getFloat32', 4); }
	this.float = function(val, index) {
		if (arguments.length == 0) list.push(this.getFloat());
		else splice(FloatType, val, 4, index);
		return this;
	};

	//获取Double数据
	this.getDouble = function() { return read('getFloat64', 8); }
	this.double = function(val, index) {
		if (arguments.length == 0) list.push(this.getDouble());
		else splice(DoubleType, val, 8, index);
		return this;
	};

	//变长字符串 前2个字节表示字符串长度
	this.getString = function() {
		var len = dataView.getUint16(offset, littleEndian);
		offset += 2;
		offset += len;
		return utf8Read(dataView, offset - len, len);
	}
	this.string = function (val, index) {
		if (arguments.length == 0) {
			list.push(this.getString());
		} else {
			var len = 0;
			if (val) len = utf8Length(val);
			list.splice(index != undefined ? index : list.length, 0, { t: StringType, d: val, l: len });
			offset += len + 2;
		}
		return this;
	};

	//定长字符串 val为null时，读取定长字符串（需指定长度len）
	this.getVString = function(len) {
		var vlen = 0; //实际长度
		for (var i = offset; i < offset + len; i++) if (dataView.getUint8(i) > 0) vlen++;
		offset += len;
		return utf8Read(dataView, offset - len, vlen)
	}
	this.vstring = function (len, val, index) {
		if (!len) return this;
		if (arguments.length <= 1) list.push(this.getVString(len));
		else splice(VStringType, val, len, index);
		return this;
	};

	//写入或读取一段字节数组
	this.getByteArray = function(len) {
		var arr = new Uint8Array(dataView.buffer.slice(offset, offset + len));
		offset += len;
		return arr;
	}
	this.byteArray = function (len, val, index) {
		if (!len) return this;
		if (val == undefined || val == null) list.push(this.getByteArray(len));
		else splice(ByteArrayType, val, len, index);
		return this;
	};

	this.getBuffer = function() {
		var len = dataView.byteLength - offset;
		var buf = dataView.buffer.slice(offset);
		offset += len;
		return buf;
	}
	this.buffer = function(val, index) {
		if (val == undefined || val == null) list.push(this.getBuffer());
		else splice(BufferType, val, val.byteLength, index);
		return this;
	}

	//解包成数据数组
	this.unpack = function () { return list; };

	//打包成二进制
	this.pack = function () {
		dataView = new DataView(new ArrayBuffer(offset + headLen));
		var index = 0;
		if (headLen > 0) index += writeHead();

		for (var i = 0; i < list.length; i++) {
			switch (list[i].t) {
				case ByteType: index += write('setInt8', i, index); break;
				case ShortType: index += write('setInt16', i, index); break;
				case UShortType: index += write('setUint16', i, index); break;
				case Int32Type: index += write('setInt32', i, index); break;
				case UInt32Type: index += write('setUint32', i, index); break;
				case Int64Type: index += write('setFloat64', i, index); break;
				case FloatType: index += write('setFloat32', i, index); break;
				case DoubleType: index += write('setFloat64', i, index); break;
				case StringType:
					//前2个字节表示字符串长度
					dataView.setUint16(index, list[i].l, littleEndian);
					index += 2;
					utf8Write(dataView, index, list[i].d);
					index += list[i].l;
					break;
				case VStringType:
					utf8Write(dataView, index, list[i].d);
					var vlen = utf8Length(list[i].d); //字符串实际长度
					for (var j = index + vlen, l = index + list[i].l; j < l; j++) dataView.setUint8(j, 0); //补齐\0
					index += list[i].l;
					break;
				case ByteArrayType:
					var indx = 0;
					for (var j = index; j < index + list[i].l; j++) {
						if (indx < list[i].d.length) dataView.setUint8(j, list[i].d[indx]);
						else dataView.setUint8(j, 0); //不够的话，后面补齐0x00
						indx++
					}
					index += list[i].l;
					break;
				case BufferType:
					var vlen = dataView.byteLength - list[i].l;
					var ndv = new DataView(list[i].d);
					for (var j = 0, l = list[i].l; j < l; j++) dataView.setUint8(vlen + j, ndv.getUint8(j));
					index += list[i].l;
					break;
			}
		}
		return dataView.buffer;
	};

	//未读数据长度
	this.getAvailable = function () {
		if (!dataView) return offset;
		return dataView.buffer.byteLength - offset;
	};

	function splice(t, d, l, index) {
		list.splice(index != undefined ? index : list.length, 0,{t: t, d: d, l: l});
		offset += l;
	}
	function read(func, len) {
		offset += len;
		return dataView[func](offset - len, littleEndian);
	}
	function write(func, i, index) {
		if (func === 'setInt8') dataView[func](index, list[i].d);
		else dataView[func](index, list[i].d, littleEndian);
		return list[i].l;
	}
	function writeHead() {
		if (headLen === 2) dataView.setUint16(0, offset, littleEndian);
		if (headLen === 4) dataView.setUint32(0, offset, littleEndian);
		return headLen;
	}
	function utf8Write(view, index, str) {
		var c = 0;
		for (var i = 0, l = str.length; i < l; i++) {
			c = str.charCodeAt(i);
			if (c < 0x80) {
				view.setUint8(index++, c);
			} else if (c < 0x800) {
				view.setUint8(index++, 0xc0 | (c >> 6));
				view.setUint8(index++, 0x80 | (c & 0x3f));
			} else if (c < 0xd800 || c >= 0xe000) {
				view.setUint8(index++, 0xe0 | (c >> 12));
				view.setUint8(index++, 0x80 | (c >> 6) & 0x3f);
				view.setUint8(index++, 0x80 | (c & 0x3f));
			} else {
				i++;
				c = 0x10000 + (((c & 0x3ff) << 10) | (str.charCodeAt(i) & 0x3ff));
				view.setUint8(index++, 0xf0 | (c >> 18));
				view.setUint8(index++, 0x80 | (c >> 12) & 0x3f);
				view.setUint8(index++, 0x80 | (c >> 6) & 0x3f);
				view.setUint8(index++, 0x80 | (c & 0x3f));
			}
		}
	}
	function utf8Read(view, index, length) {
		var string = '', chr = 0;
		for (var i = index, end = index + length; i < end; i++) {
			var byte = view.getUint8(i);
			if ((byte & 0x80) === 0x00) {
				string += String.fromCharCode(byte);
				continue;
			}
			if ((byte & 0xe0) === 0xc0) {
				string += String.fromCharCode(((byte & 0x0f) << 6) | (view.getUint8(++i) & 0x3f));
				continue;
			}
			if ((byte & 0xf0) === 0xe0) {
				string += String.fromCharCode(((byte & 0x0f) << 12) | ((view.getUint8(++i) & 0x3f) << 6) | ((view.getUint8(++i) & 0x3f) << 0));
				continue;
			}
			if ((byte & 0xf8) === 0xf0) {
				chr = ((byte & 0x07) << 18) | ((view.getUint8(++i) & 0x3f) << 12) | ((view.getUint8(++i) & 0x3f) << 6) | ((view.getUint8(++i) & 0x3f) << 0);
				if (chr >= 0x010000) { //surrogate pair
					chr -= 0x010000;
					string += String.fromCharCode((chr >>> 10) + 0xD800, (chr & 0x3FF) + 0xDC00);
				} else {
					string += String.fromCharCode(chr);
				}
				continue;
			}
			throw new Error('Invalid byte ' + byte.toString(16));
		}
		return string;
	}
	function utf8Length(str) {
		var c = 0, length = 0;
		for (var i = 0, l = str.length; i < l; i++) {
			c = str.charCodeAt(i);
			if (c < 0x80) length += 1;
			else if (c < 0x800) length += 2;
			else if (c < 0xd800 || c >= 0xe000) length += 3;
			else {
				i++;
				length += 4;
			}
		}
		return length;
	}
}

DataBuffer.littleEndian = function() { return this.littleEndian(); }
DataBuffer.bigEndian = function() { return this.bigEndian(); }
DataBuffer.uint32Head = function() { return this.uint32Head(); }
DataBuffer.ushortHead = function() { return this.ushortHead(); }
