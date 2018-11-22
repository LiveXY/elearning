using System;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif
    /// <summary>
    /// 使用BinaryFormatter序列化和反序列化
    /// 
    /// 修改纪录
    ///     2011.07.11 版本：1.0 livexy 创建此类
    /// 
    /// <code>
    /// <example>
    /// User u1 = new User() { UserID = 1000, Name = "熊华春" };
    /// var serialize = new BinarySerializeString();
    /// string s = serialize.Serialize(u1);
    /// serialize.Deserialize&lt;User>(s);
    /// </example>
    /// </code>
    /// </summary>
    public class BinaryFormatterSerialize : IBytesSerialize {
        public void RegisterTypes(params Type[] types) { }
        /// <summary>
        /// BinaryFormatter序列化
        /// </summary>
        /// <param name="o">对像</param>
        /// <returns>字节数组</returns>
        public byte[] Serialize<T>(T o) {
            BinaryFormatter formatter = new BinaryFormatter();
            using (MemoryStream ms = new MemoryStream()) {
                formatter.Serialize(ms, o);
                return ms.ToArray();
            }
        }
        /// <summary>
        /// BinaryFormatter反序列化
        /// </summary>
        /// <typeparam name="T">对像类型</typeparam>
        /// <param name="data">字节数组</param>
        /// <returns>对像</returns>
        public T Deserialize<T>(byte[] data) {
            BinaryFormatter formatter = new BinaryFormatter();
            using (MemoryStream ms = new MemoryStream(data)) return (T)formatter.Deserialize(ms);
        }
    }
}
