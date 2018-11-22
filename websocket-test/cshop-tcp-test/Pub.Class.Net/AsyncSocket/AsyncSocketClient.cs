#if NETCLIENT
namespace Pub.Class.NetClient {
#else
namespace Pub.Class.Net {
#endif
    using System;
    using System.Diagnostics;
    using System.Net;
    using System.Net.Sockets;
    using System.Text;
    using System.Threading;
    using System.Runtime.InteropServices;

    /// <summary>
    /// 客户端
    /// </summary>
    public class AsyncSocketClient : IAsyncSocketClient {
        const string errorFormat = "[出现异常:\r\n{0} 源:\r\n{1}\r\n消息:\r\n{2}\r\n栈:\r\n{3}\r\n行:\r\n{4}\r\n]";

        /// <summary>
        /// Buffer大小
        /// </summary>
        private int bufferSize = 2048;

        /// <summary>
        /// 客户端Socket
        /// </summary>
        private Socket clientSocket = null;

        /// <summary>
        /// 接收数据事件
        /// </summary>
        private AsyncSocketTokenEventArgs token;

        /// <summary>
        /// Buffer
        /// </summary>
        private byte[] dataBuffer;

        /// <summary>
        /// 是否连接
        /// </summary>
        public bool IsConnected { get; private set; }

        private bool debug = false;
        /// <summary>
        /// 启用Debug
        /// </summary>
        public bool IsDebug { set { debug = value; } }

        /// <summary>
        /// 是否释放
        /// </summary>
        private bool disposed = false;

        /// <summary>
        /// TCP/UDP
        /// </summary>
        private ProtocolType ProtocolType { get; set; }

        /// <summary>
        /// 初始化数据
        /// </summary>
        public AsyncSocketClient() {
            ProtocolType = ProtocolType.Tcp;
            SetKeepAliveValues();
            NoDelay = true;
            this.dataBuffer = new byte[this.bufferSize];
        }

        /// <summary>
        /// 初始化数据
        /// </summary>
        /// <param name="bufferSize">Buffer size of 发送的数据</param>
        public AsyncSocketClient(int bufferSize = 2048) {
            ProtocolType = ProtocolType.Tcp;
            SetKeepAliveValues();
            NoDelay = true;
            this.bufferSize = bufferSize;
            this.dataBuffer = new byte[this.bufferSize];
        }

        /// <summary>
        /// 释放
        /// </summary>
        ~AsyncSocketClient() {
            this.Dispose(false);
        }

        /// <summary>
        /// 连接成功事件
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> Connected;

        /// <summary>
        /// 断开连接事件
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> Disconnected;

        /// <summary>
        /// 接收到数据事件
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> DataReceived;

        /// <summary>
        /// 发送事件
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> DataSent;

        /// <summary>
        /// 出错事件
        /// </summary>
        public event EventHandler<AsyncSocketErrorEventArgs> Error;

        private uint first = 10000, interval = 5000;
        /// <summary>
        /// 心跳包频率
        /// </summary>
        /// <param name="first"></param>
        /// <param name="interval"></param>
        public void SetKeepAliveValues(uint first = 10000, uint interval = 5000) {
            KeepAlive = true;
            this.first = first;
            this.interval = interval;
        }

        /// <summary>
        /// 不启动合包优化否
        /// </summary>
        public bool NoDelay { get; set; }
        /// <summary>
        /// 发送超时时间
        /// </summary>
        public int SendTimeout { get; set; }
        /// <summary>
        /// 接收超时时间
        /// </summary>
        public int ReceiveTimeout { get; set; }
        /// <summary>
        /// 是否启用心跳包
        /// </summary>
        public bool KeepAlive { get; set; }

        private IPEndPoint remoteEndPoint;
        private bool useIOCP = true;

        public void ResetConnect() { Connect(remoteEndPoint, useIOCP); }

        /// <summary>
        /// 连接远程服务器
        /// </summary>
        /// <param name="remoteEndPoint">远程服务器</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        public void Connect(IPEndPoint remoteEndPoint, bool useIOCP = true) {
            if (IsConnected) return;
            this.remoteEndPoint = remoteEndPoint;
            this.useIOCP = useIOCP;
            this.CheckDisposed();

            if (this.clientSocket != null) {
                if (IsConnected) {
                    this.clientSocket.Shutdown(SocketShutdown.Both);
                    this.clientSocket.Close();
                }
                this.clientSocket = null;
            }

            this.clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType);
            this.clientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
            this.clientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.DontLinger, true);
#if !MONO
            if (KeepAlive) {
                this.clientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, true);

                byte[] array = new byte[Marshal.SizeOf(first) * 3];
                BitConverter.GetBytes((uint)1).CopyTo(array, 0);
                BitConverter.GetBytes(first).CopyTo(array, Marshal.SizeOf(first));
                BitConverter.GetBytes(interval).CopyTo(array, (int)(Marshal.SizeOf(first) * 2));
                this.clientSocket.IOControl(IOControlCode.KeepAliveValues, array, null);
            }
#endif
            this.clientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.NoDelay, NoDelay);
            this.clientSocket.NoDelay = NoDelay;
            this.clientSocket.SendTimeout = SendTimeout;
            this.clientSocket.ReceiveTimeout = ReceiveTimeout;
            try {
                this.clientSocket.UseOnlyOverlappedIO = useIOCP;
                this.token = new AsyncSocketTokenEventArgs(this.clientSocket);
                this.token.ConnectionID = Guid.NewGuid();
                this.token.SetBuffer(this.token.ReadEventArgs.Buffer, this.token.ReadEventArgs.Offset);

                this.clientSocket.BeginConnect(remoteEndPoint, new AsyncCallback(this.ProcessConnect), this.clientSocket);

                if (debug) Debug.Write("客户端连接成功...");
            } catch (ObjectDisposedException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.Connect", e.Source, e.Message, e.StackTrace, e.ToString()));
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, new AsyncSocketTokenEventArgs(this.clientSocket));
            } catch (SocketException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.Connect", e.Source, e.Message, e.StackTrace, e.ToString()));
                if (e.ErrorCode == (int)SocketError.ConnectionReset || e.ErrorCode == (int)SocketError.ConnectionRefused || e.ErrorCode == (int)SocketError.TimedOut || e.ErrorCode < -1) {
                    IsConnected = false;
                    this.RaiseEvent(this.Disconnected, this.token);
                }

                this.OnError(this.token.Socket, new AsyncSocketErrorEventArgs(e.Message, e, AsyncSocketErrorCode.ClientConnectException));
            } catch (Exception e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.Connect", e.Source, e.Message, e.StackTrace, e.ToString()));
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token);
                this.OnError(this.token.Socket, new AsyncSocketErrorEventArgs(e.Message, e, AsyncSocketErrorCode.ClientConnectException));
            }
        }

        /// <summary>
        /// 连接远程服务器
        /// </summary>
        /// <param name="ip">远程服务器IP</param>
        /// <param name="port">远程服务器端口</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        public void Connect(string ip, int port, bool useIOCP = true) {
            IPEndPoint remoteEndPoint = new IPEndPoint(IPAddress.Parse(ip), port);
            this.Connect(remoteEndPoint, useIOCP);
        }

        /// <summary>
        /// 连接远程服务器
        /// </summary>
        /// <param name="server">远程服务器 tcp://127.0.0.1:8080</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        public void Connect(string server, bool useIOCP = true) {
            string[] server_ = server.Trim('/').Split('/')[2].Split(':');
            int port = 0;
            int.TryParse(server_[1], out port);
            if (server.StartsWith("tcp://")) ProtocolType = ProtocolType.Tcp;
            if (server.StartsWith("udp://")) ProtocolType = ProtocolType.Udp;
            IPEndPoint remoteEndPoint = new IPEndPoint(IPAddress.Parse(server_[0]), port);
            this.Connect(remoteEndPoint, useIOCP);
        }

        /// <summary>
        /// 异步发送二进制数据
        /// </summary>
        /// <param name="data">发送的数据</param>
        public void BeginSend(byte[] data) {
            this.CheckDisposed();
            if (!IsConnected) return;
            try {
                this.clientSocket.BeginSend(data, 0, data.Length, SocketFlags.None, new AsyncCallback(this.ProcessSendFinished), this.clientSocket);
                this.token.SetBuffer(data, 0);
                this.token.SetReceivedBytesSize(data.Length);
                this.RaiseEvent(this.DataSent, this.token);
                if (debug) Debug.Write(string.Format("客户端发出字节: {0}", data.Length));
            } catch (ObjectDisposedException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.BeginSend", e.Source, e.Message, e.StackTrace, e.ToString()));
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, new AsyncSocketTokenEventArgs(this.clientSocket));
            } catch (SocketException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.BeginSend", e.Source, e.Message, e.StackTrace, e.ToString()));
                if (e.ErrorCode == (int)SocketError.ConnectionReset || e.ErrorCode == (int)SocketError.ConnectionRefused || e.ErrorCode == (int)SocketError.TimedOut || e.ErrorCode < -1) {
                    IsConnected = false;
                    this.RaiseEvent(this.Disconnected, this.token);
                }

                this.OnError(this.token.Socket, new AsyncSocketErrorEventArgs(e.Message, e, AsyncSocketErrorCode.ClientSendException));
            }
        }
        /// <summary>
        /// 异步发送完成
        /// </summary>
        /// <param name="asyncResult">IAsyncResult.</param>
        private void ProcessSendFinished(IAsyncResult asyncResult) {
            try {
                ((Socket)asyncResult.AsyncState).EndSend(asyncResult);
            } catch (ObjectDisposedException) {
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token);
            } catch (SocketException e) {
                this.HandleSocketException(e);
            } catch (Exception e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.ProcessSendFinished", e.Source, e.Message, e.StackTrace, e.ToString()));
            }
        }

        /// <summary>
        /// 异步发送二进制数据
        /// </summary>
        /// <param name="data">发送的数据</param>
        public void Send(byte[] data) { BeginSend(data); }
        /// <summary>
        /// 发送字符串
        /// </summary>
        /// <param name="message">字符串</param>
        /// <param name="encoding">编码</param>
        public void Send(string message, Encoding encoding = null) { BeginSend(message, encoding); }

        /// <summary>
        /// 同步发送二进制数据
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SyncSend(byte[] data) {
            this.CheckDisposed();
            try {
                int count = data.Length;
                int index = 0;
                int scount;
                while (count > 0) {
                    scount = this.clientSocket.Send(data, index, count, SocketFlags.None);
                    count -= scount;
                    index += scount;
                }
                this.token.SetBuffer(data, 0);
                this.token.SetReceivedBytesSize(data.Length);
                this.RaiseEvent(this.DataSent, this.token);
                return true;
            } catch (ObjectDisposedException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.SyncSend", e.Source, e.Message, e.StackTrace, e.ToString()));
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, new AsyncSocketTokenEventArgs(this.clientSocket));
            } catch (SocketException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.SyncSend", e.Source, e.Message, e.StackTrace, e.ToString()));
                if (e.ErrorCode == (int)SocketError.ConnectionReset || e.ErrorCode == (int)SocketError.ConnectionRefused || e.ErrorCode == (int)SocketError.TimedOut || e.ErrorCode < -1) {
                    IsConnected = false;
                    this.RaiseEvent(this.Disconnected, this.token);
                }

                this.OnError(this.token.Socket, new AsyncSocketErrorEventArgs(e.Message, e, AsyncSocketErrorCode.ClientSendException));
            }
            return false;
        }
        /// <summary>
        /// 同步发送字符串
        /// </summary>
        /// <param name="message">字符串</param>
        /// <param name="encoding">编码</param>
        public bool SyncSend(string message, Encoding encoding = null) {
            byte[] data = (encoding == null ? Encoding.UTF8 : encoding).GetBytes(message);
            return SyncSend(data);
        }

        /// <summary>
        /// 发送字符串数据
        /// </summary>
        /// <param name="message">发送的数据</param>
        /// <param name="encoding">编码</param>
        public void BeginSend(string message, Encoding encoding = null) {
            byte[] data = (encoding == null ? Encoding.UTF8 : encoding).GetBytes(message);
            this.BeginSend(data);
        }

        /// <summary>
        /// 只发送一次二进制数据 发送后端开连接
        /// </summary>
        /// <param name="remoteEndPoint">远程服务器</param>
        /// <param name="data">发送的数据</param>
        public void BeginSendOnce(IPEndPoint remoteEndPoint, byte[] data) {
            this.Connect(remoteEndPoint);
            this.BeginSend(data);
            this.Disconnect();
        }

        /// <summary>
        /// 只发送一次字符串数据 发送后端开连接
        /// </summary>
        /// <param name="remoteEndPoint">远程服务器</param>
        /// <param name="message">发送的数据</param>
        /// <param name="encoding">编码</param>
        public void BeginSendOnce(IPEndPoint remoteEndPoint, string message, Encoding encoding = null) {
            this.Connect(remoteEndPoint);
            this.BeginSend(message, encoding);
            this.Disconnect();
        }

        /// <summary>
        /// 只发送一次二进制数据 发送后端开连接
        /// </summary>
        /// <param name="ip">远程服务器IP</param>
        /// <param name="port">远程服务器端口</param>
        /// <param name="data">发送的数据</param>
        public void BeginSendOnce(string ip, int port, byte[] data) {
            this.Connect(ip, port);
            this.BeginSend(data);
            this.Disconnect();
        }

        /// <summary>
        /// Send strings once.
        /// </summary>
        /// <param name="ip">远程服务器IP</param>
        /// <param name="port">远程服务器端口</param>
        /// <param name="message">发送的数据</param>
        /// <param name="encoding">编码</param>
        public void BeginSendOnce(string ip, int port, string message, Encoding encoding = null) {
            this.Connect(ip, port);
            this.BeginSend(message, encoding);
            this.Disconnect();
        }

        /// <summary>
        /// 断开连接
        /// </summary>
        public void Disconnect() {
            this.CheckDisposed();

            try {
                lock (this) {
                    this.clientSocket.Shutdown(SocketShutdown.Both);
                    this.clientSocket.Close();
                }
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token);
            } catch (Exception e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.Disconnect", e.Source, e.Message, e.StackTrace, e.ToString()));
                this.OnError(this.token.Socket, new AsyncSocketErrorEventArgs(e.Message, e, AsyncSocketErrorCode.ClientDisconnectException));
            }
        }

        /// <summary>
        /// 释放数据
        /// </summary>
        public void Dispose() {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// 释放数据
        /// </summary>
        public void Close() {
            this.Dispose();
        }

        /// <summary>
        /// 释放数据
        /// protected virtual for non-sealed class; private for sealed class.
        /// </summary>
        /// <param name="disposing">true to release both managed and unmanaged resources; false to release only unmanaged resources.</param>
        protected virtual void Dispose(bool disposing) {
            if (this.disposed) {
                return;
            }

            if (disposing) {
                if (this.clientSocket != null) {
                    this.clientSocket.Shutdown(SocketShutdown.Both);
                    this.clientSocket.Close();
                    this.clientSocket = null;
                }
            }

            this.disposed = true;
        }

        /// <summary>
        /// 出现错误
        /// </summary>
        /// <param name="sender">sender.</param>
        /// <param name="e">AsyncSocketErrorEventArgs.</param>
        private void OnError(object sender, AsyncSocketErrorEventArgs e) {
            EventHandler<AsyncSocketErrorEventArgs> temp = Interlocked.CompareExchange(ref this.Error, null, null);

            if (temp != null) {
                temp(sender, e);
            }
        }

        /// <summary>
        /// 唤起事件
        /// </summary>
        /// <param name="eventHandler">EventHandler.</param>
        /// <param name="eventArgs">AsyncSocketTokenEventArgs.</param>
        private void RaiseEvent(EventHandler<AsyncSocketTokenEventArgs> eventHandler, AsyncSocketTokenEventArgs eventArgs) {
            // Copy a reference to the delegate field now into a temporary field for thread safety
            EventHandler<AsyncSocketTokenEventArgs> temp = Interlocked.CompareExchange(ref eventHandler, null, null);

            if (temp != null) {
                temp(this, eventArgs);
            }
        }

        /// <summary>
        /// 异步连接
        /// </summary>
        /// <param name="asyncResult">IAsyncResult.</param>
        private void ProcessConnect(IAsyncResult asyncResult) {
            Socket asyncState = (Socket)asyncResult.AsyncState;
            try {
                IsConnected = true;
                asyncState.EndConnect(asyncResult);
                this.RaiseEvent(this.Connected, this.token);
                this.ProcessWaitForData(asyncState);
            } catch (ObjectDisposedException) {
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, new AsyncSocketTokenEventArgs(this.clientSocket));
            } catch (SocketException e) {
                this.HandleSocketException(e);
            }
        }

        /// <summary>
        /// 异步等待接收数据
        /// </summary>
        /// <param name="socket">Socket.</param>
        private void ProcessWaitForData(Socket socket) {
            if (!socket.Connected) {
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token); return;
            }
            try {
                if (socket != null) {
                    socket.BeginReceive(this.dataBuffer, 0, this.bufferSize, SocketFlags.None, new AsyncCallback(this.ProcessIncomingData), socket);
                }
            } catch (ObjectDisposedException) {
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token);
            } catch (SocketException e) {
                this.HandleSocketException(e);
            }
        }
        /// <summary>
        /// 异步接收数据
        /// </summary>
        /// <param name="asyncResult">IAsyncResult.</param>
        private void ProcessIncomingData(IAsyncResult asyncResult) {
            Socket asyncState = (Socket)asyncResult.AsyncState;
            if (!asyncState.Connected) {
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token); return;
            }
            try {
                int length = asyncState.EndReceive(asyncResult);
                if (0 == length) {
                    IsConnected = false;
                    this.RaiseEvent(this.Disconnected, this.token);
                } else {
                    this.token.SetBuffer(this.dataBuffer, 0);
                    this.token.SetReceivedBytesSize(length);
                    this.RaiseEvent(this.DataReceived, this.token);

                    this.ProcessWaitForData(asyncState);
                }
            } catch (ObjectDisposedException) {
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token);
            } catch (SocketException e) {
                if (e.ErrorCode == (int)SocketError.ConnectionReset || e.ErrorCode == (int)SocketError.ConnectionRefused || e.ErrorCode == (int)SocketError.TimedOut || e.ErrorCode < -1) {
                    IsConnected = false;
                    this.RaiseEvent(this.Disconnected, this.token);
                }

                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.ProcessIncomingData", e.Source, e.Message, e.StackTrace, e.ToString()));
                this.OnError(this.token.Socket, new AsyncSocketErrorEventArgs(e.Message, e, AsyncSocketErrorCode.ClientReceiveException));
            }
        }

        /// <summary>
        /// Socket异常
        /// </summary>
        /// <param name="e">Instance of SocketException.</param>
        private void HandleSocketException(SocketException e) {
            if (e.ErrorCode == (int)SocketError.ConnectionReset || e.ErrorCode == (int)SocketError.ConnectionRefused || e.ErrorCode == (int)SocketError.TimedOut || e.ErrorCode < -1) {
                IsConnected = false;
                this.RaiseEvent(this.Disconnected, this.token);
            }

            if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketClient.HandleSocketException", e.Source, e.Message, e.StackTrace, e.ToString()));
            this.OnError(this.token.Socket, new AsyncSocketErrorEventArgs(e.Message, e));
        }

        /// <summary>
        /// 验证是否释放
        /// </summary>
        private void CheckDisposed() {
            if (this.disposed) {
                throw new ObjectDisposedException("AsyncSocketClient");
            }
        }
    }
}
