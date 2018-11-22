using System;
using System.Collections.Generic;
using System.Text;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif
    /// <summary>
    /// 网络包接口
    /// </summary>
    public interface INetPackage {
        int Command { get; set; }
        StreamReader Stream { get; set; }
        T NetMessage<T>() where T: INetMessage, new();
    }

    /// <summary>
    /// 网络消息接口
    /// </summary>
    public interface INetMessage {

    }

    /// <summary>
    /// 网络数据解包接口
    /// </summary>
    public interface INetPackageParse {
        IList<INetPackage> Parse(AsyncSocketTokenEventArgs e, bool littleEndian, int maxPackageSize);
        void Remove(Guid guid);
    }
}
