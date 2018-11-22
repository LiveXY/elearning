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
    public class BinaryStream {
        /// <summary>
        /// 构造器
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="littleEndian"></param>
        public BinaryStream(System.IO.Stream stream, bool littleEndian = true) {
            Stream = stream;
            LittleEndian = littleEndian;
            reader = new System.IO.BinaryReader(stream);
            writer = new System.IO.BinaryWriter(stream);
        }

        private System.IO.BinaryReader reader;
        private System.IO.BinaryWriter writer;

        private byte[] tempData = new byte[8];

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
        /// 读1字节
        /// </summary>
        /// <returns></returns>
        public byte Read() { return reader.ReadByte(); }
        /// <summary>
        /// 读bool
        /// </summary>
        /// <returns></returns>
        public bool ReadBool() { return reader.ReadBoolean(); }
        /// <summary>
        /// 读short
        /// </summary>
        /// <returns></returns>
        public short ReadShort() {
            short value = reader.ReadInt16();
            if (!LittleEndian) value = EndianHelper.SwapInt16(value);
            return value;
        }
        /// <summary>
        /// 读int
        /// </summary>
        /// <returns></returns>
        public int ReadInt() {
            int value = reader.ReadInt32();
            if (!LittleEndian) value = EndianHelper.SwapInt32(value);
            return value;
        }
        /// <summary>
        /// 读long
        /// </summary>
        /// <returns></returns>
        public long ReadLong() {
            long value = reader.ReadInt64();
            if (!LittleEndian) value = EndianHelper.SwapInt64(value);
            return value;
        }
        /// <summary>
        /// 读ushort
        /// </summary>
        /// <returns></returns>
        public ushort ReadUShort() {
            ushort value = reader.ReadUInt16();
            if (!LittleEndian) value = EndianHelper.SwapUInt16(value);
            return value;

        }
        /// <summary>
        /// 读uint
        /// </summary>
        /// <returns></returns>
        public uint ReadUInt() {
            uint value = reader.ReadUInt32();
            if (!LittleEndian) value = EndianHelper.SwapUInt32(value);
            return value;
        }
        /// <summary>
        /// 读ulong
        /// </summary>
        /// <returns></returns>
        public ulong ReadULong() {
            ulong value = reader.ReadUInt64();
            if (!LittleEndian) value = EndianHelper.SwapUInt64(value);
            return value;
        }
        /// <summary>
        /// 读char
        /// </summary>
        /// <returns></returns>
        public char ReadChar() { return (char)this.ReadShort(); }
        /// <summary>
        /// 读float
        /// </summary>
        /// <returns></returns>
        public unsafe float ReadFloat() {
            //int num;
            //num = this.ReadInt();
            //return *(float*)(&num);
            reader.Read(tempData, 0, 4);
            if (!LittleEndian) Array.Reverse(tempData, 0, 4);
            return BitConverter.ToSingle(tempData, 0);
        }
        /// <summary>
        /// 读double
        /// </summary>
        /// <returns></returns>
        public unsafe double ReadDouble() {
            //long num;
            //num = this.ReadLong();
            //return *(double*)(&num);
            reader.Read(tempData, 0, 8);
            if (!LittleEndian) Array.Reverse(tempData, 0, 8);
            return BitConverter.ToDouble(tempData, 0);
        }
        /// <summary>
        /// 读UTF字符串
        /// </summary>
        /// <returns></returns>
        public string ReadUTF() {
            ushort value = ReadUShort();
            if (value > 0) {
                byte[] result = ReadBytes(value);
                return Encoding.UTF8.GetString(result, 0, result.Length);
            }
            return null;
        }
        /// <summary>
        /// 读指定长度字节
        /// </summary>
        /// <param name="count"></param>
        /// <returns></returns>
        public byte[] ReadBytes(int count) {
            byte[] result = reader.ReadBytes(count);
            return result;
        }
        /// <summary>
        /// 读时间
        /// </summary>
        /// <returns></returns>
        public DateTime ReadDateTime() {
            return new DateTime(ReadLong());
        }
        /// <summary>
        /// 读网络消息列表
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public IList<T> ReadList<T>() where T : IStreamMessage, new() {
            int count = ReadInt();
            IList<T> list = new List<T>();
            for (int i = 0; i < count; i++) list.Add(Read<T>());
            return list;
        }
        /// <summary>
        /// 读网络消息
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public T Read<T>() where T : IStreamMessage, new() {
            T t = new T();
            t.Read(this);
            return t;
        }
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
            Write(list.Count);
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
