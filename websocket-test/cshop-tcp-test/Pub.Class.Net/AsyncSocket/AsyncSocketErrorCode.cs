#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif
    /// <summary>
    /// 出错代码枚举
    /// </summary>
    public enum AsyncSocketErrorCode {
        /// <summary>
        /// 服务器启动异常
        /// </summary>
        ServerStartException,

        /// <summary>
        /// 服务器停止异常
        /// </summary>
        ServerStopException,

        /// <summary>
        /// 服务器连接异常
        /// </summary>
        ServerConnectException,

        /// <summary>
        /// 服务器断开异常
        /// </summary>
        ServerDisconnectException,

        /// <summary>
        /// 服务器接受异常
        /// </summary>
        ServerAcceptException,

        /// <summary>
        /// 服务器返回异常
        /// </summary>
        ServerSendBackException,

        /// <summary>
        /// 服务器接收异常
        /// </summary>
        ServerReceiveException,

        /// <summary>
        /// 客户端启动异常
        /// </summary>
        ClientStartException,

        /// <summary>
        /// 客户端停止异常
        /// </summary>
        ClientStopException,

        /// <summary>
        /// 客户端连接异常
        /// </summary>
        ClientConnectException,

        /// <summary>
        /// 客户端断开异常
        /// </summary>
        ClientDisconnectException,

        /// <summary>
        /// 客户端接受异常
        /// </summary>
        ClientAcceptException,

        /// <summary>
        /// 客户端发送异常
        /// </summary>
        ClientSendException,

        /// <summary>
        /// 客户端接收异常
        /// </summary>
        ClientReceiveException,

        /// <summary>
        /// Socket不存在
        /// </summary>
        SocketNoExist,

        /// <summary>
        /// Socket异常
        /// </summary>
        ThrowSocketException,
    }
}
