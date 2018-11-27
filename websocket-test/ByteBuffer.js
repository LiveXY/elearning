'use strict';

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

var ByteBuffer = function (buffer, offset) {
	offset = offset || 0;
	var encoding = 'utf8';
	var list = [];
	ByteBuffer.Endian = ByteBuffer.Endian || 'BE';
	ByteBuffer.HeadLen = ByteBuffer.HeadLen || 0;

	//指定文字编码
	this.encoding = function(encode) { return encoding = encode, this; };

	//指定字节序 为BigEndian
	this.bigEndian = function() { return ByteBuffer.Endian = 'BE', this; };

	//指定字节序 为LittleEndian
	this.littleEndian = function() { return ByteBuffer.Endian = 'LE', this; };

	//指定包头长度
	this.uint32Head = function() { return ByteBuffer.HeadLen = 4, this; }
	this.ushortHead = function() { return ByteBuffer.HeadLen = 2, this; }

	//获取一个字节
	this.getByte = function() { return offset += 1, buffer.readUInt8(offset - 1); }
	this.byte = function(val, index) {
		if (val == undefined || val == null) list.push(this.getByte());
		else splice(ByteType, val, 1, index)
		return this;
	};

	//获取Short数据
	this.getShort = function() { return read('readInt16', 2); }
	this.short = function(val, index) {
		if (val == undefined || val == null)list.push(this.getShort());
		else splice(ShortType, val, 2, index);
		return this;
	};

	//获取Ushort数据
	this.getUshort = function() { return read('readUInt16', 2); }
	this.ushort = function(val, index) {
		if (val == undefined || val == null) list.push(this.getUshort());
		else splice(UShortType, val, 2, index);
		return this;
	};

	//获取Int32数据
	this.getInt32 = function () { return read('readInt32', 4); }
	this.int32 = function(val, index) {
		if (val == undefined || val == null) list.push(this.getInt32());
		else splice(Int32Type, val, 4, index);
		return this;
	};

	//获取Uint32数据
	this.getUint32 = function() { return read('readUInt32', 4); }
	this.uint32 = function(val, index) {
		if (val == undefined || val == null) list.push(this.getUint32());
		else splice(UInt32Type, val, 4, index);
		return this;
	};

	//获取Uint64数据
	this.getInt64 = function () { return read('readDouble', 8); }
	this.int64 = function(val, index) {
		if (val == undefined || val == null) list.push(this.getInt64());
		else splice(Int64Type, val, 8, index);
		return this;
	};

	//获取Float数据
	this.getFloat = function() { return read('readFloat', 4); }
	this.float = function(val, index) {
		if (val == undefined || val == null) list.push(this.getFloat());
		else splice(FloatType, val, 4, index);
		return this;
	};

	//获取Double数据
	this.getDouble = function() { return read('readDouble', 8); }
	this.double = function(val, index) {
		if (val == undefined || val == null) list.push(this.getDouble());
		else splice(DoubleType, val, 8, index);
		return this;
	};

	//获取变长字符串 前2个字节表示字符串长度
	this.getString = function() {
		var len = buffer['readUInt16' + ByteBuffer.Endian](offset);
		offset += 2;
		offset += len;
		return buffer.toString(encoding, offset - len, offset);
	}
	this.string = function(val, index) {
		if (val == undefined || val == null) {
			list.push(this.getString());
		} else {
			var len = 0;
			if (val) len = Buffer.byteLength(val, encoding);
			list.splice(index != undefined ? index : list.length, 0, {t: StringType, d: val, l: len});
			offset += len + 2;
		}
		return this;
	};

	//定长字符串 val为null时，读取定长字符串（需指定长度len）
	this.getVString = function(len) {
		var vlen = 0; //实际长度
		for(var i = offset, tlen = offset + len; i < tlen; i++) if (buffer[i]>0) vlen++;
		offset += len;
		return buffer.toString(encoding, offset - len, offset - len + vlen);
	}
	this.vstring = function(len, val, index) {
		if (!len) return this;
		if (val == undefined || val == null) list.push(this.getVString(len));
		else splice(VStringType, val, len, index);
		return this;
	};

	//写入或读取一段字节数组
	this.getByteArray = function(len) {
		var arr = [];
		for (var i = offset, l = offset + len; i < l; i++) {
			if (i < buffer.length) arr.push(buffer.readUInt8(i));
			else arr.push(0);
		}
		offset += len;
		return arr;
	}
	this.byteArray = function(len, val, index) {
		if (!len) return this;
		if (val == undefined || val == null) list.push(this.getByteArray(len));
		else splice(ByteArrayType, val, len, index);
		return this;
	};

	this.getBuffer = function() {
		var len = buffer.length - offset;
		var buf = Buffer.alloc(len);
		buffer.copy(buf, 0, offset, buffer.length);
		offset += len;
		return buf;
	}
	this.buffer = function(val, index) {
		if (val == undefined || val == null) list.push(this.getBuffer());
		else splice(BufferType, val, val.length, index);
		return this;
	}

	//解包成数据数组
	this.unpack = function() { return list; };

	//打包成二进制
	this.pack = function() {
		buffer = new Buffer(offset + ByteBuffer.HeadLen);
		var index = 0;
		if (ByteBuffer.HeadLen > 0) index += writeHead();

		for (var i = 0, len = list.length; i < len; i++) {
			switch (list[i].t) {
				case ByteType: index += write('writeUInt8', i, index); break;
				case ShortType: index += write('writeInt16', i, index); break;
				case UShortType: index += write('writeUInt16', i, index); break;
				case Int32Type: index += write('writeInt32', i, index); break;
				case UInt32Type: index += write('writeUInt32', i, index); break;
				case Int64Type: index += write('writeDouble', i, index); break;
				case FloatType: index += write('writeFloat', i, index); break;
				case DoubleType: index += write('writeDouble', i, index); break;
				case StringType:
					//前2个字节表示字符串长度
					buffer['writeUInt16' + ByteBuffer.Endian](list[i].l, index);
					index += 2;
					buffer.write(list[i].d, index, encoding);
					index += list[i].l;
					break;
				case VStringType:
					var vlen = Buffer.byteLength(list[i].d, encoding);//字符串实际长度
					buffer.write(list[i].d, index, encoding);
					for (var j = index + vlen, l = index + list[i].l; j < l; j++) buffer.writeUInt8(0, j); //补齐\0
					index += list[i].l;
					break;
				case ByteArrayType:
					var indx = 0;
					for (var j = index, l = index + list[i].l; j < l; j++) {
						if (indx < list[i].d.length) buffer.writeUInt8(list[i].d[indx], j);
						else buffer.writeUInt8(0, j); //不够的话，后面补齐0x00
						indx++
					}
					index += list[i].l;
					break;
				case BufferType:
					list[i].d.copy(buffer, buffer.length - list[i].l, 0, list[i].l);
					index += list[i].l;
					break;
			}
		}
		return buffer;
	};

	//未读数据长度
	this.getAvailable = function() {
		if (!buffer) return offset;
		return buffer.length - offset;
	};

	function splice(t, d, l, index) {
		list.splice(index != undefined ? index : list.length, 0,{t: t, d: d, l: l});
		offset += l;
	}
	function read(func, len) {
		offset += len;
		return buffer[func + ByteBuffer.Endian](offset - len);
	}
	function write(func, i, index) {
		if (func === 'writeUInt8') buffer.writeUInt8(list[i].d, index);
		else buffer[func + ByteBuffer.Endian](list[i].d, index);
		return list[i].l;
	}
	function writeHead() {
		if (ByteBuffer.HeadLen === 2) buffer['writeUInt16' + ByteBuffer.Endian](offset, 0);
		if (ByteBuffer.HeadLen === 4) buffer['writeUInt32' + ByteBuffer.Endian](offset, 0);
		return ByteBuffer.HeadLen;
	}
}

ByteBuffer.littleEndian = function() { return ByteBuffer.Endian = 'LE', ByteBuffer; }
ByteBuffer.bigEndian = function() { return ByteBuffer.Endian = 'BE', ByteBuffer; }
ByteBuffer.uint32Head = function() { return ByteBuffer.HeadLen = 4, ByteBuffer; }
ByteBuffer.ushortHead = function() { return ByteBuffer.HeadLen = 2, ByteBuffer; }

module.exports = exports = ByteBuffer;