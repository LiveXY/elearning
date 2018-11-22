using System;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif
    /// <summary>
    /// 序列化和反序列化接口
    /// 
    /// 修改纪录
    ///     2011.07.11 版本：1.0 livexy 创建此类
    /// 
    /// </summary>
    public interface IBytesSerialize {
        void RegisterTypes(params Type[] types);
        /// <summary>
        /// 序列化
        /// </summary>
        /// <param name="o">对像</param>
        /// <returns>字符串</returns>
        byte[] Serialize<T>(T o);
        /// <summary>
        /// data反序列化成对像
        /// </summary>
        /// <typeparam name="T">对像类型</typeparam>
        /// <param name="data">内容</param>
        /// <returns>对像</returns>
        T Deserialize<T>(byte[] data);
    }
}
