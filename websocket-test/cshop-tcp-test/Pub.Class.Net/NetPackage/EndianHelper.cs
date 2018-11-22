using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif

    /// <summary>
    /// 大端转小端
    /// </summary>
    public class EndianHelper {
        public static short SwapInt16(short v) { return (short)(((v & 0xff) << 8) | ((v >> 8) & 0xff)); }
        public static ushort SwapUInt16(ushort v) { return (ushort)(((v & 0xff) << 8) | ((v >> 8) & 0xff)); }
        public static int SwapInt32(int v) { return (int)(((SwapInt16((short)v) & 0xffff) << 0x10) | (SwapInt16((short)(v >> 0x10)) & 0xffff)); }
        public static uint SwapUInt32(uint v) { return (uint)(((SwapUInt16((ushort)v) & 0xffff) << 0x10) | (SwapUInt16((ushort)(v >> 0x10)) & 0xffff)); }
        public static long SwapInt64(long v) { return (long)(((SwapInt32((int)v) & 0xffffffffL) << 0x20) | (SwapInt32((int)(v >> 0x20)) & 0xffffffffL)); }
        public static ulong SwapUInt64(ulong v) { return (ulong)(((SwapUInt32((uint)v) & 0xffffffffL) << 0x20) | (SwapUInt32((uint)(v >> 0x20)) & 0xffffffffL)); }
        /// <summary>
        /// 合并包内容
        /// </summary>
        /// <param name="bytes1">数据1</param>
        /// <param name="bytes2">数据2</param>
        /// <returns></returns>
        public static byte[] UnionBytes(byte[] bytes1, byte[] bytes2) {
            int len1 = bytes1 == null ? 0 : bytes1.Length;
            int len2 = bytes2 == null ? 0 : bytes2.Length;
            byte[] data = new byte[len1 + len2];
            if (len1 > 0) Buffer.BlockCopy(bytes1, 0, data, 0, len1);
            if (len2 > 0) Buffer.BlockCopy(bytes2, 0, data, len1, len2);
            return data;
        }
        /// <summary>
        /// 字节数组转结构体
        /// </summary>
        /// <typeparam name="T">结构体</typeparam>
        /// <param name="bytes">字节数组</param>
        /// <returns></returns>
        public static T BytesToStruct<T>(byte[] bytes) {
            Type type = typeof(T);
            int size = Marshal.SizeOf(type);
            IntPtr buffer = Marshal.AllocHGlobal(size);
            Marshal.Copy(bytes, 0, buffer, size);
            object obj = Marshal.PtrToStructure(buffer, type);
            Marshal.FreeHGlobal(buffer);
            return (T)obj;
        }
    }
    /// <summary>
    /// Singleton 泛型单实例类
    /// 
    /// 修改纪录
    ///     2008.06.12 版本：1.0 livexy 创建此类
    /// 
    /// <example>
    /// <code>
    /// public class UC_Member : Singleton&lt;UC_Member> { }
    /// </code>
    /// </example>
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public sealed class Singleton<T> where T : new() {
        private static T instance = new T();
        private static readonly object lockHelper = new object();
        /// <summary>
        /// 获取实例
        /// </summary>
        public static T Instance() {
            if (instance == null) {
                lock (lockHelper) {
                    if (instance == null) instance = new T();
                }
            }

            return instance;
        }
        /// <summary>
        /// 设置实例
        /// </summary>
        /// <param name="value"></param>
        public void Instance(T value) {
            instance = value;
        }
    }
}
