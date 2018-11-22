#if NETCLIENT
namespace Pub.Class.NetClient {
#else
namespace Pub.Class.Net {
#endif
    using System;
    using System.Net;
    using System.Net.Sockets;
    using System.IO;

    /// <summary>
    /// 分配SocketAsyncEventArgs.UserToken属性
    /// </summary>
    public class AsyncSocketTokenEventArgs : EventArgs {
        /// <summary>
        /// Socket
        /// </summary>
        private Socket socket;

        /// <summary>
        /// 实例初始化
        /// </summary>
        public AsyncSocketTokenEventArgs() : this(null) { }

        /// <summary>
        /// 实例初始化
        /// </summary>
        /// <param name="socket">Socket</param>
        public AsyncSocketTokenEventArgs(Socket socket) {
            this.ReadEventArgs = new SocketAsyncEventArgs();
            this.ReadEventArgs.UserToken = this;
            if (null != socket) {
                this.socket = socket;
            }
        }

        /// <summary>
        /// SocketAsyncEventArgs属性
        /// </summary>
        public SocketAsyncEventArgs ReadEventArgs { get; set; }

        /// <summary>
        /// 接收字节大小
        /// </summary>
        public int ReceivedBytesSize { get; private set; }

        /// <summary>
        /// offset of buffer.
        /// </summary>
        public int Offset { get; private set; }

        /// <summary>
        /// 接收Buffer
        /// </summary>
        public byte[] ReceivedBuffer { get; private set; }

        /// <summary>
        /// 原始数据
        /// </summary>
        public byte[] ReceivedBytes {
            get {
                byte[] data = new byte[this.ReceivedBytesSize];
                Buffer.BlockCopy(this.ReceivedBuffer, this.Offset, data, 0, this.ReceivedBytesSize);
                return data;
            }
        }

        /// <summary>
        /// 获取或设置套接口的环境
        /// </summary>
        public Socket Socket {
            get {
                return this.socket;
            }

            set {
                if (value != null) {
                    this.socket = value;
                    this.EndPoint = (IPEndPoint)this.socket.RemoteEndPoint;
                }
            }
        }

        /// <summary>
        /// 客户端ID
        /// </summary>
        public Guid ConnectionID { get; set; }

        /// <summary>
        /// 客户端连接EndPoint
        /// </summary>
        public IPEndPoint EndPoint { get; private set; }

        /// <summary>
        /// 设置接收字节大小
        /// </summary>
        /// <param name="bytesReceived">字节大小</param>
        public void SetReceivedBytesSize(int bytesReceived) {
            this.ReceivedBytesSize = bytesReceived;
        }

        /// <summary>
        /// 设置Buffer
        /// </summary>
        /// <param name="buffer">Buffer字节</param>
        /// <param name="offset">Offset</param>
        public void SetBuffer(byte[] buffer, int offset) {
            this.ReceivedBuffer = buffer;
            this.Offset = offset;
            this.ReceivedBytesSize = 0;
        }
    }
}
