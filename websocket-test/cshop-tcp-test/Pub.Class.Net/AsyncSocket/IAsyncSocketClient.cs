#if NETCLIENT
namespace Pub.Class.NetClient {
#else
namespace Pub.Class.Net {
#endif
    using System;
    using System.Net;
    using System.Net.Sockets;
    using System.IO;
using System.Text;

    /// <summary>
    /// 客户端接口
    /// </summary>
    public interface IAsyncSocketClient : IDisposable {
        /// <summary>
        /// 连接成功事件
        /// </summary>
        event EventHandler<AsyncSocketTokenEventArgs> Connected;
        /// <summary>
        /// 断开连接事件
        /// </summary>
        event EventHandler<AsyncSocketTokenEventArgs> Disconnected;
        /// <summary>
        /// 接收到数据事件
        /// </summary>
        event EventHandler<AsyncSocketTokenEventArgs> DataReceived;
        /// <summary>
        /// 发送事件
        /// </summary>
        event EventHandler<AsyncSocketTokenEventArgs> DataSent;
        /// <summary>
        /// 出错事件
        /// </summary>
        event EventHandler<AsyncSocketErrorEventArgs> Error;

        /// <summary>
        /// 是否连接
        /// </summary>
        bool IsConnected { get; }

        /// <summary>
        /// 连接远程服务器
        /// </summary>
        /// <param name="remoteEndPoint">远程服务器</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        void Connect(IPEndPoint remoteEndPoint, bool useIOCP = true);
        /// <summary>
        /// 连接远程服务器
        /// </summary>
        /// <param name="ip">远程服务器IP</param>
        /// <param name="port">远程服务器端口</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        void Connect(string ip, int port, bool useIOCP = true);
        /// <summary>
        /// 连接远程服务器
        /// </summary>
        /// <param name="server">远程服务器 tcp://127.0.0.1:8080</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        void Connect(string server, bool useIOCP = true);
        /// <summary>
        /// 重新连接
        /// </summary>
        void ResetConnect();

        /// <summary>
        /// 异步发送二进制数据
        /// </summary>
        /// <param name="data">发送的数据</param>
        void Send(byte[] data);
        /// <summary>
        /// 发送字符串
        /// </summary>
        /// <param name="message">字符串</param>
        /// <param name="encoding">编码</param>
        void Send(string message, Encoding encoding = null);
        /// <summary>
        /// 同步发送二进制数据
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        bool SyncSend(byte[] data);
        /// <summary>
        /// 同步发送字符串
        /// </summary>
        /// <param name="message">字符串</param>
        /// <param name="encoding">编码</param>
        bool SyncSend(string message, Encoding encoding = null);

        /// <summary>
        /// 断开连接
        /// </summary>
        void Disconnect();
        /// <summary>
        /// 释放数据
        /// </summary>
        void Close();
    }
}
