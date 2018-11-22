using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif
    /// <summary>
    /// 流消息接口
    /// </summary>
    public interface IStreamMessage: INetMessage {
        /// <summary>
        /// 读
        /// </summary>
        /// <param name="reader"></param>
        void Read(StreamReader reader);
        /// <summary>
        /// 写
        /// </summary>
        /// <param name="writer"></param>
        void Write(StreamWriter writer);
    }

    /// <summary>
    /// 流数据包
    /// </summary>
    public class StreamPackage: INetPackage {
        /// <summary>
        /// 指令
        /// </summary>
        public int Command { get; set; }
        /// <summary>
        /// 字节流
        /// </summary>
        public StreamReader Stream { get; set; }

        /// <summary>
        /// 返回数据包里的消息
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public T NetMessage<T>() where T : INetMessage, new() {
            IStreamMessage msg = new T() as IStreamMessage;
            msg.Read(Stream);
            return (T)msg;
        }
    }

    /// <summary>
    /// 内存流数据解包
    /// </summary>
    public class StreamPackageParse : INetPackageParse {
        private static Dictionary<Guid, byte[]> cache = new Dictionary<Guid, byte[]>();
        private static Dictionary<Guid, object> lockers = new Dictionary<Guid, object>();
        /// <summary>
        /// 将接收到的字节转成数据包
        /// </summary>
        /// <param name="e">接收数据</param>
        /// <param name="littleEndian">小端</param>
        /// <param name="maxPackageSize">最大包大小</param>
        /// <returns>数据包数 null为非法数据包</returns>
        public IList<INetPackage> Parse(AsyncSocketTokenEventArgs e, bool littleEndian = true, int maxPackageSize = 10240) {
            //lock (((ICollection)lockers).SyncRoot) { }
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
                    using (System.IO.MemoryStream stream = new System.IO.MemoryStream(data)) {
                        StreamReader reader = new StreamReader(stream, littleEndian);
                        int length = reader.ReadInt();
                        if (length > 0 && count >= length + 4) {
                            INetPackage package = new StreamPackage();

                            byte[] result = new byte[length];
                            System.IO.MemoryStream resultStream = new System.IO.MemoryStream(result);
                            stream.Position = 4;
                            stream.Read(result, 0, length);
                            package.Stream = new StreamReader(resultStream, littleEndian);
                            package.Command = package.Stream.ReadInt();

                            data = new byte[count - length - 4];
                            stream.Position = length + 4;
                            stream.Read(data, 0, count - length - 4);
                            cache[e.ConnectionID] = data;

                            packs.Add(package);
                            count = count - length - 4;
                        } else {
                            if (length < 0) cache[e.ConnectionID] = null;
                            return packs;
                        }
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
    /// 流数据包发送处理
    /// </summary>
    /// <typeparam name="T">消息</typeparam>
    public class StreamPackage<T> : StreamPackage where T : IStreamMessage, new() {
        private T data = new T();
        /// <summary>
        /// 消息内容
        /// </summary>
        public T Data { set { data = value; } get { return data; } }

        /// <summary>
        /// 消息内容转为字节数据
        /// </summary>
        /// <param name="littleEndian">小端</param>
        /// <returns></returns>
        public byte[] DataBytes(bool littleEndian = true) {
            using (System.IO.MemoryStream stream = new System.IO.MemoryStream()) {
                StreamWriter writer = new StreamWriter(stream, littleEndian);
                writer.Write(Command);
                Data.Write(writer);

                byte[] result = new byte[stream.Length + 4];
                using (System.IO.MemoryStream resultStream = new System.IO.MemoryStream(result)) {
                    writer = new StreamWriter(resultStream, littleEndian);
                    writer.Write((int)stream.Length);
                    stream.Position = 0;
                    stream.Read(result, 4, (int)stream.Length);
                    return result;
                }
            }
        }
    }
}
