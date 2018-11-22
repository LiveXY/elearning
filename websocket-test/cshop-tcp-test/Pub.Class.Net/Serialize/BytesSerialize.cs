using System;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else
namespace Pub.Class.Net {
#endif
    /// <summary>
    /// 序列化和反序列化
    /// 
    /// 修改纪录
    ///     2013.02.12 版本：1.0 livexy 创建此类
    /// 
    /// </summary>
    public class BytesSerialize {
        private static IBytesSerialize bytesSerialize = null;
        private static readonly object lockHelper = new object();
        /// <summary>
        /// 使用外部插件
        /// </summary>
        public static void Use<T>() where T : IBytesSerialize, new() {
            lock (lockHelper) {
                bytesSerialize = new T();
            }
        }
        ///<summary>
        /// 序列化
        ///</summary>
        public static byte[] ToBytes<T>(T o) {
            try {
                if (bytesSerialize == null) Use<BinaryFormatterSerialize>();
                return bytesSerialize.Serialize(o);
            } catch (Exception ex) {
                throw ex;
            }
        }
        ///<summary>
        /// 反序列化
        ///</summary>
        public static T FromBytes<T>(byte[] data) {
            try {
                if (bytesSerialize == null) Use<BinaryFormatterSerialize>();
                return bytesSerialize.Deserialize<T>(data);
            } catch (Exception ex) {
                throw ex;
            }
        }
        /// <summary>
        /// 注册类型
        /// </summary>
        /// <param name="types"></param>
        public static void RegisterTypes(params Type[] types) {
            try {
                if (bytesSerialize == null) Use<BinaryFormatterSerialize>();
                bytesSerialize.RegisterTypes(types);
            } catch (Exception ex) {
                throw ex;
            }
        }
    }
}
