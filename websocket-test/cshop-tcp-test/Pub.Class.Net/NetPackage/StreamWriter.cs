using System;
using System.Collections.Generic;
using System.Text;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else
namespace Pub.Class.Net {
#endif
    /// <summary>
    /// 字节流
    /// </summary>
    public class StreamWriter {
        /// <summary>
        /// 构造器
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="littleEndian"></param>
        public StreamWriter(System.IO.Stream stream, bool littleEndian = true) {
            Stream = stream;
            LittleEndian = littleEndian;
            writer = new System.IO.BinaryWriter(stream);
        }

        private System.IO.BinaryWriter writer;

        /// <summary>
        /// 长度
        /// </summary>
        public long Length { get { return Stream.Length; } }
        /// <summary>
        /// 位置
        /// </summary>
        public long Position { get { return Stream.Position; } }
        /// <summary>
        /// 小端
        /// </summary>
        public bool LittleEndian { get; set; }
        /// <summary>
        /// 流
        /// </summary>
        public System.IO.Stream Stream { get; set; }
        /// <summary>
        /// 写double
        /// </summary>
        /// <param name="value"></param>
        public void Write(double value) {
            byte[] data = BitConverter.GetBytes(value);
            if (!LittleEndian) Array.Reverse(data);
            Write(data, 0, 8);
        }
        /// <summary>
        /// 写float
        /// </summary>
        /// <param name="value"></param>
        public void Write(float value) {
            byte[] data = BitConverter.GetBytes(value);
            if (!LittleEndian) Array.Reverse(data);
            Write(data, 0, 4);
        }
        /// <summary>
        /// 写byte
        /// </summary>
        /// <param name="value"></param>
        public void Write(byte value) { writer.Write(value); }
        /// <summary>
        /// 写bool
        /// </summary>
        /// <param name="value"></param>
        public void Write(bool value) { writer.Write(value); }
        /// <summary>
        /// 写short
        /// </summary>
        /// <param name="value"></param>
        public void Write(short value) {
            if (!LittleEndian) value = EndianHelper.SwapInt16(value);
            writer.Write(value);
        }
        /// <summary>
        /// 写int
        /// </summary>
        /// <param name="value"></param>
        public void Write(int value) {
            if (!LittleEndian) value = EndianHelper.SwapInt32(value);
            writer.Write(value);
        }
        /// <summary>
        /// 写long
        /// </summary>
        /// <param name="value"></param>
        public void Write(long value) {
            if (!LittleEndian) value = EndianHelper.SwapInt64(value);
            writer.Write(value);
        }
        /// <summary>
        /// 写时间
        /// </summary>
        /// <param name="value"></param>
        public void Write(DateTime value) {
            Write(value.Ticks);
        }
        /// <summary>
        /// 写char
        /// </summary>
        /// <param name="value"></param>
        public void Write(char value) { Write((short)value); }
        /// <summary>
        /// 写ushort
        /// </summary>
        /// <param name="value"></param>
        public void Write(ushort value) {
            if (!LittleEndian) value = EndianHelper.SwapUInt16(value);
            writer.Write(value);
        }
        /// <summary>
        /// 写uint
        /// </summary>
        /// <param name="value"></param>
        public void Write(uint value) {
            if (!LittleEndian) value = EndianHelper.SwapUInt32(value);
            writer.Write(value);
        }
        /// <summary>
        /// 写ulong
        /// </summary>
        /// <param name="value"></param>
        public void Write(ulong value) {
            if (!LittleEndian) value = EndianHelper.SwapUInt64(value);
            writer.Write(value);
        }
        /// <summary>
        /// 写UTF字符串
        /// </summary>
        /// <param name="value"></param>
        public void WriteUTF(string value) {
            if (string.IsNullOrEmpty(value)) Write((ushort)0);
            byte[] data = Encoding.UTF8.GetBytes(value);
            Write((ushort)data.Length);
            Write(data, 0, data.Length);
        }
        /// <summary>
        /// 写字节
        /// </summary>
        /// <param name="data"></param>
        public void Write(byte[] data) { writer.Write(data); }
        /// <summary>
        /// 写字节
        /// </summary>
        /// <param name="data"></param>
        /// <param name="offset"></param>
        /// <param name="count"></param>
        public void Write(byte[] data, int offset, int count) { writer.Write(data, offset, count); }
        /// <summary>
        /// 写网络消息列表
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list"></param>
        public void WriteList<T>(IList<T> list) where T : IStreamMessage, new() {
            if (list == null) { Write(0); return; }
            Write((ushort)list.Count);
            foreach (T t in list) {
                t.Write(this);
            }
        }
        /// <summary>
        /// 写网络消息
        /// </summary>
        /// <param name="message"></param>
        public void Write(IStreamMessage message) {
            message.Write(this);
        }
    }
}
