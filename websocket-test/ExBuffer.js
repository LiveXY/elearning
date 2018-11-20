'use strict';

var ExBuffer = function (bufferLength) {
	var self = this;
	var headLen = 2;
	var endian = 'B';
	var inBuffer = new Buffer(bufferLength || 8192);
	var readOffset = 0;
	var putOffset = 0;
	var dlen = 0;
	var slice = Array.prototype.slice;
	var readMethod = 'readUInt16BE';

	//指定包长是uint32型(默认是ushort型)
	this.uint32Head = function() { return headLen = 4, readMethod = 'readUInt' + (8*headLen) + '' + endian + 'E', this; };

	//指定包长是ushort型(默认是ushort型)
	this.ushortHead = function() { return headLen = 2, readMethod = 'readUInt' + (8*headLen) + '' + endian + 'E', this; };

	//指定字节序 为Little Endian (默认：Big Endian)
	this.littleEndian = function() { return endian = 'L', readMethod = 'readUInt' + (8*headLen) + '' + endian + 'E', this; };

	//指定字节序 为Big Endian (默认：Big Endian)
	this.bigEndian = function() { return endian = 'B', readMethod = 'readUInt' + (8*headLen) + '' + endian + 'E', this; };

	this.once = function(e, cb) {
		if (!this.listeners_once) this.listeners_once = {};
		this.listeners_once[e] = this.listeners_once[e] || [];
		if (this.listeners_once[e].indexOf(cb) == -1) this.listeners_once[e].push(cb);
	};

	this.on = function(e, cb) {
		if (!this.listeners)this.listeners = {};
		this.listeners[e] = this.listeners[e] || [];
		if (this.listeners[e].indexOf(cb) == -1) this.listeners[e].push(cb);
	};

	this.off = function(e, cb) {
		var index = -1;
		if (this.listeners && this.listeners[e] && (index = this.listeners[e].indexOf(cb)) != -1)
			this.listeners[e].splice(index);
	};

	this.emit = function(e) {
		var other_parameters = slice.call(arguments, 1);
		if (this.listeners) {
			var list = this.listeners[e];
			if (list) for (var i = 0, l = list.length; i < l; ++i) list[i].apply(this,other_parameters);
		}
		if(this.listeners_once) {
			var list = this.listeners_once[e];
			delete this.listeners_once[e];
			if (list) for (var i = 0, l = list.length; i < l; ++i) list[i].apply(this,other_parameters);
		}
	};

	//送入一段Buffer
	this.put = function(buffer, offset, len) {
		if (offset == undefined) offset = 0;
		if (len == undefined) len = buffer.length - offset;
		//buf.copy(targetBuffer, [targetStart], [sourceStart], [sourceEnd])
		//当前缓冲区已经不能满足次数数据了,这里我们保证尾部至少有一个位置永远空余，避免读写指针重叠
		if (len + getLen() > inBuffer.length - 1) {
			var ex = Math.ceil((len + getLen())/(1024));//每次扩展1kb
			var tmp = new Buffer(ex * 1024);
			var exlen = tmp.length - inBuffer.length;
			inBuffer.copy(tmp);
			//fix bug : superzheng
			if (putOffset < readOffset) {
				if (putOffset <= exlen) {
					tmp.copy(tmp, inBuffer.length, 0, putOffset);
					putOffset += inBuffer.length;
				} else {
					//fix bug : superzheng
					tmp.copy(tmp, inBuffer.length, 0, exlen);
					tmp.copy(tmp, 0, exlen, putOffset);
					putOffset -= exlen;
				}
			}
			inBuffer = tmp;
		}
		if (getLen() == 0) putOffset = readOffset = 0;
		//判断是否会冲破inBuffer尾部
		if ((putOffset + len) > inBuffer.length) {
			//分两次存 一部分存在数据后面 一部分存在数据前面
			var len1 = inBuffer.length - putOffset;
			if (len1 > 0) {
				buffer.copy(inBuffer, putOffset, offset, offset + len1);
				offset += len1;
			}
			var len2 = len - len1;
			buffer.copy(inBuffer, 0, offset, offset + len2);
			putOffset = len2;
		} else {
			buffer.copy(inBuffer, putOffset, offset, offset + len);
			putOffset += len;
		}
		var count = 0;
		while (true) {
			count++;
			if (count > 1000) break; //1000次还没读完??
			if (dlen == 0) {
				if (getLen() < headLen) break; //连包头都读不了
				if (inBuffer.length - readOffset >= headLen) {
					dlen = inBuffer[readMethod](readOffset);
					readOffset += headLen;
				} else {
					var hbuf = new Buffer(headLen);
					var rlen = 0;
					for (var i = 0, l = (inBuffer.length - readOffset); i < l; i++) {
						hbuf[i] = inBuffer[readOffset++];
						rlen++;
					}
					readOffset = 0;
					for (var i = 0, l = (headLen - rlen); i < l; i++) hbuf[rlen+i] = inBuffer[readOffset++];
					dlen = hbuf[readMethod](0);
				}
			}
			if (getLen() >= dlen) {
				var dbuff = new Buffer(dlen);
				if (readOffset + dlen > inBuffer.length) {
					var len1 = inBuffer.length - readOffset;
					if (len1 > 0) inBuffer.copy(dbuff, 0, readOffset, readOffset + len1);
					readOffset = 0;
					var len2 = dlen - len1;
					inBuffer.copy(dbuff, len1, readOffset, readOffset += len2);
				} else {
					inBuffer.copy(dbuff, 0, readOffset, readOffset += dlen);
				}
				try {
					dlen = 0;
					self.emit("data", dbuff);
					if (readOffset === putOffset) break;
				} catch(e) {
					self.emit("error", e);
				}
			} else break;
		}
	};

	function getLen() {
		if (putOffset >= readOffset) return putOffset - readOffset;
		return inBuffer.length - readOffset + putOffset;
	}
};

module.exports = exports = ExBuffer;
