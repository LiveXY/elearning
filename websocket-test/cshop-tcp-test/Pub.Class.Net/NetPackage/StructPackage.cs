using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Runtime.InteropServices;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif

    /// <summary>
    /// 结构体数据包
    /// </summary>
    public class StructPackage : INetPackage {
        /// <summary>
        /// 指令
        /// </summary>
        public int Command { get; set; }
        /// <summary>
        /// 数据包
        /// </summary>
        public StreamReader Stream { get; set; }

        /// <summary>
        /// 返回数据包里的消息
        /// </summary>
        /// <typeparam name="T">结构体</typeparam>
        /// <returns></returns>
        public T NetMessage<T>() where T : INetMessage, new() {
            return EndianHelper.BytesToStruct<T>(Stream.ReadBytes((int)Stream.Length));
        }
    }

    public class StructPackageParse : INetPackageParse { 
        private static Dictionary<Guid, byte[]> cache = new Dictionary<Guid, byte[]>();
        private static Dictionary<Guid, object> lockers = new Dictionary<Guid, object>();
        /// <summary>
        /// 将接收到的字节转成数据包
        /// </summary>
        /// <param name="packs">数据包列表</param>
        /// <param name="e">接收数据</param>
        /// <param name="littleEndian">小端</param>
        /// <param name="maxPackageSize">最大包大小</param>
        /// <returns>数据包数 -1为非法数据包</returns>
        public IList<INetPackage> Parse(AsyncSocketTokenEventArgs e, bool littleEndian = true, int maxPackageSize = 10240) {
            //lock (((ICollection)lockers).SyncRoot) {}
            if (!lockers.ContainsKey(e.ConnectionID)) lockers[e.ConnectionID] = new object();

            lock (lockers[e.ConnectionID]) {
                if (cache.ContainsKey(e.ConnectionID))
                    cache[e.ConnectionID] = EndianHelper.UnionBytes(cache[e.ConnectionID], e.ReceivedBytes);
                else
                    cache[e.ConnectionID] = EndianHelper.UnionBytes(null, e.ReceivedBytes);

                byte[] data = cache[e.ConnectionID];
                int count = data.Length;
                if (count <= 4) return new List<INetPackage>();
                if (count > maxPackageSize) return null;

                IList<INetPackage> packs = new List<INetPackage>();
                while (count > 4) {
                    byte[] lenBytes = new byte[4];
                    Buffer.BlockCopy(data, 0, lenBytes, 0, 4);

                    StructPackageLength lenPack = EndianHelper.BytesToStruct<StructPackageLength>(lenBytes);
                    int length = lenPack.Size;
                    if (length > 0 && count >= length + 14) {
                        byte[] bytes = new byte[10240 + 10 + 4];
                        Buffer.BlockCopy(data, 0, bytes, 0, length + 14);
                        StructPackageData packData = EndianHelper.BytesToStruct<StructPackageData>(bytes);

                        byte[] resultBytes = new byte[packData.Size];
                        Buffer.BlockCopy(packData.Bytes, 0, resultBytes, 0, packData.Size);
                        System.IO.MemoryStream resultStream = new System.IO.MemoryStream(resultBytes);

                        StructPackage pack = new StructPackage();
                        pack.Command = packData.Command;
                        pack.Stream = new StreamReader(resultStream, littleEndian);
                        packs.Add(pack);

                        byte[] data2 = new byte[count - length - 14];
                        Buffer.BlockCopy(data, length + 14, data2, 0, count - length - 14);
                        count = count - length - 14;
                        data = data2;
                        cache[e.ConnectionID] = data;
                    } else {
                        if (length < 0) cache[e.ConnectionID] = null;
                        return packs;
                    }
                }
                return packs;
            }
        }
        /// <summary>
        /// 断开连接里清理数据
        /// </summary>
        /// <param name="guid"></param>
        public void Remove(Guid guid) {
            if (lockers.ContainsKey(guid)) lockers.Remove(guid);
            if (cache.ContainsKey(guid)) cache.Remove(guid);
        }
    
    }

    /// <summary>
    /// 结构体包内容
    /// </summary>
    [StructLayoutAttribute(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    struct StructPackageData {
        /// <summary>
        /// 包长
        /// </summary>
        public int Size;
        /// <summary>
        /// 指令
        /// </summary>
        public int Command;
        /// <summary>
        /// 数据内容
        /// </summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10240)]
        public byte[] Bytes;
    }

    /// <summary>
    /// 结构体包长
    /// </summary>
    [StructLayoutAttribute(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
    struct StructPackageLength {
        /// <summary>
        /// 包长
        /// </summary>
        public int Size;
    }

    /// <summary>
    /// 结构体数据包发送处理
    /// </summary>
    /// <typeparam name="T">结构体</typeparam>
    public class StructPackage<T> where T : struct {
        public int Command;

        /// <summary>
        /// 结构体数据
        /// </summary>
        public T Data;

        /// <summary>
        /// 结构体转为字节数据
        /// </summary>
        /// <returns></returns>
        public byte[] DataBytes() {
            StructPackageData packData;
            byte[] bytes = StructToBytes(Data);
            packData.Size = bytes.Length;
            packData.Command = Command;
            packData.Bytes = new byte[10240];
            Buffer.BlockCopy(bytes, 0, packData.Bytes, 0, bytes.Length);

            bytes = StructToBytes(packData);

            byte[] byte2 = new byte[packData.Size + 4 + 10];
            Buffer.BlockCopy(bytes, 0, byte2, 0, packData.Size + 4 + 10);

            return byte2;
        }
        /// <summary>
        /// 将对像转字节数组
        /// </summary>
        /// <param name="obj">对像</param>
        /// <returns></returns>
        public byte[] StructToBytes(object obj) {
            //得到结构体大小
            int size = Marshal.SizeOf(obj);
            //创建byte数组
            byte[] bytes = new byte[size];
            //分配结构体大小的内存空间
            IntPtr structPtr = Marshal.AllocHGlobal(size);
            //将结构体考到分配好的内存空间
            Marshal.StructureToPtr(obj, structPtr, false);
            //从内存空间考到数组
            Marshal.Copy(structPtr, bytes, 0, size);
            //释放空间
            Marshal.FreeHGlobal(structPtr);
            //返回数组
            return bytes;
        }
    }
}
