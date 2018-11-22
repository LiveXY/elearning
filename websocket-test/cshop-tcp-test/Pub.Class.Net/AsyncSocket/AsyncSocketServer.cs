namespace Pub.Class.Net {
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Diagnostics.CodeAnalysis;
    using System.Net;
    using System.Net.Sockets;
    using System.Security.Permissions;
    using System.Threading;
    using System.Text;
#if NET40
    using System.Collections.Concurrent;
#endif

    /// <summary>
    /// 异步Socket通讯服务器
    /// </summary>
    public class AsyncSocketServer : MarshalByRefObject, IDisposable {
        const string errorFormat = "[出现异常:\r\n{0}源:\r\n{1}\r\n消息:\r\n{2}\r\n栈:\r\n{3}\r\n行:\r\n{4}\r\n]";

#if NET40
        /// <summary>
        /// 接收数据事件对象集合线程安全
        /// </summary>
        private ConcurrentDictionary<Guid, AsyncSocketTokenEventArgs> tokens;

        /// <summary>
        /// 接收数据事件对象集合线程安全
        /// </summary>
        private ConcurrentDictionary<IPAddress, AsyncSocketTokenEventArgs> singleIPTokens;
#else
        /// <summary>
        /// 接收数据事件对象集合线程安全
        /// </summary>
        private Dictionary<Guid, AsyncSocketTokenEventArgs> tokens;

        /// <summary>
        /// 接收数据事件对象集合线程安全
        /// </summary>
        private Dictionary<IPAddress, AsyncSocketTokenEventArgs> singleIPTokens;
#endif

        /// <summary>
        /// 同时处理的连接最大数
        /// </summary>
        private int maxConnections = 10000;

        /// <summary>
        /// 用于每一个Socket I/O操作使用的缓冲区大小
        /// </summary>
        private int bufferSize = 2048;
        /// <summary>
        /// TCP/UDP
        /// </summary>
        private ProtocolType ProtocolType { get; set; }

        /// <summary>
        /// 为所有Socket操作准备的一个大的可重用的缓冲区集合        
        /// </summary>
        private AsyncSocketEventArgsBufferManager bufferManager;

        /// <summary>
        /// 用来侦听到达的连接请求的Socket
        /// </summary>
        private Socket listenSocket;

        /// <summary>
        /// 读Socket操作的AsyncSocketEventArgsPool可重用对象池 
        /// </summary>
        private AsyncSocketEventArgsPool readPool;

        /// <summary>
        /// 写Socket操作的AsyncSocketEventArgsPool可重用对象池
        /// </summary>
        private AsyncSocketEventArgsPool writePool;

        /// <summary>
        /// 服务器接收到的总字节数计数器
        /// </summary>
        private long totalBytesRead;

        /// <summary>
        /// 服务器发送的字节总数
        /// </summary>
        private long totalBytesWrite;

        /// <summary>
        /// 连接到服务器的Socket总数
        /// </summary>
        private long numConnectedSockets;

        /// <summary>
        /// 最大接受请求数信号量
        /// </summary>
        private Semaphore maxNumberAcceptedClients;

        /// <summary>
        /// 是否释放
        /// </summary>
        private bool disposed = false;

        /// <summary>
        /// 构造函数
        /// </summary>
        public AsyncSocketServer() {
            ProtocolType = ProtocolType.Tcp;
            NoDelay = true;
            this.totalBytesRead = 0;
            this.totalBytesWrite = 0;
            this.numConnectedSockets = 0;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="localEndPoint">监听IPEndPoint</param>
        /// <param name="maxConnections">最大连接数</param>
        /// <param name="bufferSize">Buffer大小</param>
        public AsyncSocketServer(IPEndPoint localEndPoint, int maxConnections = 10000, int bufferSize = 2048) {
            ProtocolType = ProtocolType.Tcp;
            NoDelay = true;
            this.totalBytesRead = 0;
            this.totalBytesWrite = 0;
            this.numConnectedSockets = 0;
            this.maxConnections = maxConnections;
            this.bufferSize = bufferSize;
            this.LocalEndPoint = localEndPoint;
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="localPort">监听端口</param>
        /// <param name="maxConnections">最大连接数</param>
        /// <param name="bufferSize">Buffer大小</param>
        public AsyncSocketServer(int localPort, int maxConnections = 10000, int bufferSize = 2048) {
            ProtocolType = ProtocolType.Tcp;
            NoDelay = true;
            this.totalBytesRead = 0;
            this.totalBytesWrite = 0;
            this.numConnectedSockets = 0;
            this.maxConnections = maxConnections;
            this.bufferSize = bufferSize;
            this.LocalEndPoint = new IPEndPoint(IPAddress.Any, localPort);
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="listen">监听端口</param>
        /// <param name="maxConnections">最大连接数</param>
        /// <param name="bufferSize">Buffer大小</param>
        public AsyncSocketServer(string listen, int maxConnections = 10000, int bufferSize = 2048) {
            ProtocolType = ProtocolType.Tcp;
            NoDelay = true;
            string[] server_ = listen.Trim('/').Split('/')[2].Split(':');
            int port = 0;
            int.TryParse(server_[1], out port);
            if (listen.StartsWith("tcp://")) ProtocolType = ProtocolType.Tcp;
            if (listen.StartsWith("udp://")) ProtocolType = ProtocolType.Udp;
            this.totalBytesRead = 0;
            this.totalBytesWrite = 0;
            this.numConnectedSockets = 0;
            this.maxConnections = maxConnections;
            this.bufferSize = bufferSize;
            this.LocalEndPoint = new IPEndPoint(server_[0].Replace("0.0.0.0", "*") == "*" ? IPAddress.Any : IPAddress.Parse(server_[0]), port);
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        ~AsyncSocketServer() {
            this.Dispose(false);
        }

        /// <summary>
        /// 客户端已经连接事件        
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> Connected;

        /// <summary>
        /// 客户端断开连接事件
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> Disconnected;

        /// <summary>
        /// 接收到数据事件
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> DataReceived;

        /// <summary>
        /// 数据发送完成
        /// </summary>
        public event EventHandler<AsyncSocketTokenEventArgs> DataSent;

        /// <summary>
        /// 客户端错误事件
        /// </summary>
        public event EventHandler<AsyncSocketErrorEventArgs> Error;

        /// <summary>
        /// 是否在监听
        /// </summary>
        public bool IsListening { get; private set; }

        /// <summary>
        /// 当前EndPoint.
        /// </summary>
        public IPEndPoint LocalEndPoint { get; private set; }

        /// <summary>
        /// 当前连接的Socket数
        /// </summary>
        public long NumConnectedSockets { get { return this.numConnectedSockets; } }

        private bool debug = false;
        /// <summary>
        /// 启用Debug
        /// </summary>
        public bool IsDebug { set { debug = value; } }

        private bool semaphore = false;
        /// <summary>
        /// 使用Semaphore
        /// </summary>
        public bool IsSemaphore { set { semaphore = value; } }
        /// <summary>
        /// 当前连接的Client数
        /// </summary>
        public int NumConnectedClients {
            get {
#if NET40
                return this.singleIPTokens.Count;
#else
                lock (((ICollection)this.singleIPTokens).SyncRoot) {
                    return this.singleIPTokens.Count;
                }
#endif
            }
        }

        /// <summary>
        /// 发送超时时间
        /// </summary>
        public int SendTimeout { get; set; }
        /// <summary>
        /// 接收超时时间
        /// </summary>
        public int ReceiveTimeout { get; set; }
        /// <summary>
        /// 不启动合包优化否
        /// </summary>
        public bool NoDelay { get; set; }

        /// <summary>
        /// 当前连接的Socket
        /// </summary>
        public IList<Guid> Sockets {
            get {
                IList<Guid> list = new List<Guid>();
#if NET40
                foreach (var key in this.tokens.Keys) list.Add(key);
#else
                lock (((ICollection)this.tokens).SyncRoot) {
                    foreach (var key in this.tokens.Keys) list.Add(key);
                }
#endif
                return list;
            }
        }
        /// <summary>
        /// 当前连接的Client
        /// </summary>
        public IList<IPAddress> Clients {
            get {
                IList<IPAddress> list = new List<IPAddress>();
#if NET40
                foreach (var key in this.singleIPTokens.Keys) list.Add(key);
#else
                lock (((ICollection)this.singleIPTokens).SyncRoot) {
                    foreach (var key in this.singleIPTokens.Keys) list.Add(key);
                }
#endif
                return list;
            }
        }

        /// <summary>
        /// 清理部分死连接
        /// </summary>
        /// <returns></returns>
        public int ClearDieSocket() {
            IList<Guid> guidList = new List<Guid>();
            foreach (Guid id in tokens.Keys) {
                if (tokens[id].Socket != null && !tokens[id].Socket.Connected) guidList.Add(id);
            }
            int count = guidList.Count;
            foreach (Guid id in guidList) {
                Disconnect(id);
            }
            return count;
        }

        /// <summary>
        /// 获取接收到的字节总数
        /// </summary>
        public long TotalBytesRead { get { return this.totalBytesRead; } }

        /// <summary>
        /// 获取发送的字节总数
        /// </summary>
        public long TotalBytesWrite { get { return this.totalBytesWrite; } }

        /// <summary>
        /// 客户端是否在线
        /// </summary>
        /// <param name="connectionId">Connection Id.</param>
        /// <returns>在线返回true，否则返回false</returns>
        public bool IsOnline(Guid connectionId) {
            if (this.CheckDisposed()) return false;

#if NET40
            return this.tokens.ContainsKey(connectionId);
#else
            lock (((ICollection)this.tokens).SyncRoot) {
                return this.tokens.ContainsKey(connectionId);
            }
#endif
        }

        /// <summary>
        /// 客户端是否在线
        /// </summary>
        /// <param name="connectionIP">Connection IP.</param>
        /// <returns>在线返回true，否则返回false</returns>
        public bool IsOnline(IPAddress connectionIP) {
            if (this.CheckDisposed()) return false;

#if NET40
            return this.singleIPTokens.ContainsKey(connectionIP);
#else
            lock (((ICollection)this.singleIPTokens).SyncRoot) {
                return this.singleIPTokens.ContainsKey(connectionIP);
            }
#endif
        }

        /// <summary>
        /// 启动异步Socket服务器
        /// </summary>
        /// <param name="useIOCP">是否使用IOCP</param>
        public void Start(bool useIOCP = true) {
            this.Start(this.LocalEndPoint, useIOCP);
        }

        /// <summary>
        /// 启动异步Socket服务器
        /// </summary>
        /// <param name="localPort">端口</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        public void Start(int localPort, bool useIOCP = true) {
            this.LocalEndPoint = new IPEndPoint(IPAddress.Any, localPort);
            this.Start(this.LocalEndPoint, useIOCP);
        }

        /// <summary>
        /// 启动异步Socket服务器
        /// </summary>
        /// <param name="localEndPoint">IPEndPoint</param>
        /// <param name="useIOCP">是否使用IOCP</param>
        public void Start(IPEndPoint localEndPoint, bool useIOCP = true) {
            if (this.CheckDisposed()) return;

            if (!this.IsListening) {
                this.InitializePool();

                try {
                    if (null != this.listenSocket) {
                        this.listenSocket.Close();
                        this.listenSocket = null;
                    }
                    this.listenSocket = new Socket(localEndPoint.AddressFamily, SocketType.Stream, ProtocolType);
                    if (localEndPoint.AddressFamily == AddressFamily.InterNetworkV6) {
						//#if NET40
						//this.listenSocket.SetSocketOption(SocketOptionLevel.IPv6, SocketOptionName.IPv6Only, false);
						//#endif
                        this.listenSocket.Bind(new IPEndPoint(IPAddress.IPv6Any, localEndPoint.Port));
                    } else {
                        this.listenSocket.Bind(localEndPoint);
                    }
                    this.listenSocket.Listen(128);
                    this.listenSocket.UseOnlyOverlappedIO = useIOCP;
                    this.listenSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
                    this.listenSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.DontLinger, true);
                    this.listenSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.NoDelay, NoDelay);
                    this.listenSocket.NoDelay = NoDelay;
                    this.listenSocket.SendTimeout = SendTimeout;
                    this.listenSocket.ReceiveTimeout = ReceiveTimeout;
                } catch (ObjectDisposedException) {
                    this.IsListening = false;
                    return;
                } catch (SocketException e) {
                    this.IsListening = false;
                    this.OnError(null, new AsyncSocketErrorEventArgs("Socket服务启动失败！", e, AsyncSocketErrorCode.ServerStartException));
                    return;
                } catch (Exception e) {
                    this.IsListening = false;
                    if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Start", e.Source, e.Message, e.StackTrace, e.ToString()));
                    return;
                }

                this.IsListening = true;
                this.StartAccept(null);
                if (debug) Debug.Write("Socket服务启动成功！");
            }
        }
        /// <summary>
        /// 发送广播
        /// </summary>
        /// <param name="buffer">数据</param>
        public void Broadcast(byte[] buffer) {
            foreach (Guid id in tokens.Keys) Send(id, buffer);
        }
        /// <summary>
        /// 发送广播
        /// </summary>
        /// <param name="message">数据</param>
        /// <param name="encoding">编码</param>
        public void Broadcast(string message, Encoding encoding = null) { 
            foreach (Guid id in tokens.Keys) Send(id, message, encoding);
        }
        /// <summary>
        /// 发送数据给客户端
        /// </summary>
        /// <param name="connectionId">客户端</param>
        /// <param name="buffer">数据</param>
        public void Send(Guid connectionId, byte[] buffer) {
            if (this.CheckDisposed()) return;

            AsyncSocketTokenEventArgs token;

#if NET40
            if (!this.tokens.TryGetValue(connectionId, out token)) {
                this.OnError(null, new AsyncSocketErrorEventArgs(string.Format("客户端: {0} 已关闭或未连接Send！", connectionId), null, AsyncSocketErrorCode.SocketNoExist));
                return;
            }
#else
            lock (((ICollection)this.tokens).SyncRoot) {
                if (!this.tokens.TryGetValue(connectionId, out token)) {
                    this.OnError(null, new AsyncSocketErrorEventArgs(string.Format("客户端: {0} 已关闭或未连接Send！", connectionId), null, AsyncSocketErrorCode.SocketNoExist));
                    return;
                }
            }
#endif

            SocketAsyncEventArgs writeEventArgs;
            writeEventArgs = this.writePool.Pop();
            if (writeEventArgs == null) return;
            writeEventArgs.UserToken = token;

            if (buffer.Length <= this.bufferSize) {
                Buffer.BlockCopy(buffer, 0, writeEventArgs.Buffer, writeEventArgs.Offset, buffer.Length);
                writeEventArgs.SetBuffer(writeEventArgs.Offset, buffer.Length);
            } else {
                this.bufferManager.FreeBuffer(writeEventArgs);
                writeEventArgs.SetBuffer(buffer, 0, buffer.Length);
            }

            try {
                bool willRaiseEvent = token.Socket.SendAsync(writeEventArgs);
                if (!willRaiseEvent) {
                    this.ProcessSend(writeEventArgs);
                }
            } catch (ObjectDisposedException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Send", e.Source, e.Message, e.StackTrace, e.ToString()));
                this.RaiseDisconnectedEvent(token);
            } catch (SocketException socketException) {
                if (socketException.ErrorCode == (int)SocketError.ConnectionReset) {
                    this.RaiseDisconnectedEvent(token);
                } else {
                    this.OnError(token, new AsyncSocketErrorEventArgs("发送异步数据时发生异常！", socketException, AsyncSocketErrorCode.ServerSendBackException));
                }
            } catch (Exception e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Send", e.Source, e.Message, e.StackTrace, e.ToString()));
            }
        }

        /// <summary>
        /// 发送数据给客户端
        /// </summary>
        /// <param name="connectionIP">客户端IP</param>
        /// <param name="buffer">发送数据</param>
        public void Send(IPAddress connectionIP, byte[] buffer) {
            if (this.CheckDisposed()) return;

            AsyncSocketTokenEventArgs token;

#if NET40
            if (!this.singleIPTokens.TryGetValue(connectionIP, out token)) {
                this.OnError(null, new AsyncSocketErrorEventArgs(string.Format("客户端: {0} 已关闭或未连接Send！", connectionIP), null, AsyncSocketErrorCode.SocketNoExist));
                return;
            }
#else
            lock (((ICollection)this.singleIPTokens).SyncRoot) {
                if (!this.singleIPTokens.TryGetValue(connectionIP, out token)) {
                    this.OnError(null, new AsyncSocketErrorEventArgs(string.Format("客户端: {0} 已关闭或未连接Send！", connectionIP), null, AsyncSocketErrorCode.SocketNoExist));
                    return;
                }
            }
#endif

            SocketAsyncEventArgs writeEventArgs;
            writeEventArgs = this.writePool.Pop();
            if (writeEventArgs == null) return;
            writeEventArgs.UserToken = token;

            if (buffer.Length <= this.bufferSize) {
                Buffer.BlockCopy(buffer, 0, writeEventArgs.Buffer, writeEventArgs.Offset, buffer.Length);
                writeEventArgs.SetBuffer(writeEventArgs.Offset, buffer.Length);
            } else {
                this.bufferManager.FreeBuffer(writeEventArgs);
                writeEventArgs.SetBuffer(buffer, 0, buffer.Length);
            }

            try {
                bool willRaiseEvent = token.Socket.SendAsync(writeEventArgs);
                if (!willRaiseEvent) {
                    this.ProcessSend(writeEventArgs);
                }
            } catch (ObjectDisposedException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Send", e.Source, e.Message, e.StackTrace, e.ToString()));
                this.RaiseDisconnectedEvent(token);
            } catch (SocketException socketException) {
                if (socketException.ErrorCode == (int)SocketError.ConnectionReset) {
                    this.RaiseDisconnectedEvent(token);
                } else {
                    this.OnError(token, new AsyncSocketErrorEventArgs("发送异步数据时发生异常！", socketException, AsyncSocketErrorCode.ServerSendBackException));
                }
            } catch (Exception e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Send", e.Source, e.Message, e.StackTrace, e.ToString()));
            }
        }

        /// <summary>
        /// 发送数据给客户端
        /// </summary>
        /// <param name="connectionId">客户端</param>
        /// <param name="message">数据</param>
        /// <param name="encoding">编码</param>
        public void Send(Guid connectionId, string message, Encoding encoding = null) {
            byte[] data = (encoding == null ? Encoding.UTF8 : encoding).GetBytes(message);
            this.Send(connectionId, data);
        }

        /// <summary>
        /// 发送数据给客户端
        /// </summary>
        /// <param name="connectionIP">客户端</param>
        /// <param name="message">数据</param>
        /// <param name="encoding">编码</param>
        public void Send(IPAddress connectionIP, string message, Encoding encoding = null) {
            byte[] data = (encoding == null ? Encoding.UTF8 : encoding).GetBytes(message);
            this.Send(connectionIP, data);
        }

        /// <summary>
        /// 断开客户端连接
        /// </summary>
        /// <param name="connectionId">客户端ID</param>
        public void Disconnect(Guid connectionId) {
            if (this.CheckDisposed()) return;

            AsyncSocketTokenEventArgs token;

#if NET40
            if (!this.tokens.TryGetValue(connectionId, out token)) {
                this.OnError(null, new AsyncSocketErrorEventArgs(string.Format("客户端: {0} 已关闭或未连接Disconnect！", connectionId), null, AsyncSocketErrorCode.SocketNoExist));
                return;
            }
#else
            lock (((ICollection)this.tokens).SyncRoot) {
                if (!this.tokens.TryGetValue(connectionId, out token)) {
                    this.OnError(null, new AsyncSocketErrorEventArgs(string.Format("客户端: {0} 已关闭或未连接Disconnect！", connectionId), null, AsyncSocketErrorCode.SocketNoExist));
                    return;
                }
            }
#endif

            this.RaiseDisconnectedEvent(token);
        }

        /// <summary>
        /// 停止服务
        /// </summary>
        public void Stop() {
            if (this.CheckDisposed()) return;

            if (this.IsListening) {
                try {
                    this.listenSocket.Close();
                } catch (Exception e) {
                    if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Stop", e.Source, e.Message, e.StackTrace, e.ToString()));
                } finally {
#if NET40
                    foreach (AsyncSocketTokenEventArgs token in this.tokens.Values) {
                        try {
                            this.CloseClientSocket(token);

                            if (null != token) {
                                this.RaiseEvent(this.Disconnected, token);
                            }
                        } catch (Exception e) {
                            if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Stop", e.Source, e.Message, e.StackTrace, e.ToString()));
                        }
                    }

                    this.tokens.Clear();
                    this.singleIPTokens.Clear();
#else
                    lock (((ICollection)this.tokens).SyncRoot) {
                        foreach (AsyncSocketTokenEventArgs token in this.tokens.Values) {
                            try {
                                this.CloseClientSocket(token);

                                if (null != token) {
                                    this.RaiseEvent(this.Disconnected, token);
                                }
                            } catch (Exception e) {
                                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.Stop", e.Source, e.Message, e.StackTrace, e.ToString()));
                            }
                        }
                        this.tokens.Clear();
                    }

                    lock (((ICollection)this.singleIPTokens).SyncRoot) {
                        this.singleIPTokens.Clear();
                    }
#endif
                }

                this.IsListening = false;
            }
        }

        /// <summary>
        /// 释放
        /// </summary>
        public void Dispose() {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// 释放
        /// </summary>
        public void Close() {
            this.Dispose();
        }

        /// <summary>
        /// 释放
        /// </summary>
        /// <param name="disposing">true to release both managed and unmanaged resources; false to release only unmanaged resources.</param>
        protected virtual void Dispose(bool disposing) {
            if (this.disposed) {
                return;
            }

            if (disposing) {
                if (this.listenSocket != null) {
                    this.listenSocket.Close();
                    this.listenSocket = null;
                }
                if (this.readPool != null) {
                    this.readPool.Clear();
                    this.readPool = null;
                }
                if (this.writePool != null) {
                    this.writePool.Clear();
                    this.writePool = null;
                }
                if (semaphore) this.maxNumberAcceptedClients.Close();
            }

            this.disposed = true;
        }

        /// <summary>
        /// 出错
        /// </summary>
        /// <param name="sender">Event sender.</param>
        /// <param name="e">Instance of AsyncSocketErrorEventArgs.</param>
        private void OnError(object sender, AsyncSocketErrorEventArgs e) {
            EventHandler<AsyncSocketErrorEventArgs> temp = Interlocked.CompareExchange(ref this.Error, null, null);
            if (temp != null) temp(sender, e);
        }

        /// <summary>
        /// 唤起事件
        /// </summary>
        /// <param name="eventHandler">Instance of EventHandler.</param>
        /// <param name="eventArgs">Instance of AsyncSocketTokenEventArgs.</param>
        private void RaiseEvent(EventHandler<AsyncSocketTokenEventArgs> eventHandler, AsyncSocketTokenEventArgs eventArgs) {
            EventHandler<AsyncSocketTokenEventArgs> temp = Interlocked.CompareExchange(ref eventHandler, null, null);
            if (temp != null) temp(this, eventArgs);
        }

        /// <summary>
        /// 用预分配的可重用缓冲区和上下文对象初始化服务器.
        /// </summary>
        [SuppressMessage("Microsoft.Reliability", "CA2000:Dispose objects before losing scope", Justification = "Reviewed.")]
        private void InitializePool() {
            this.bufferManager = new AsyncSocketEventArgsBufferManager(this.bufferSize * this.maxConnections * 2, this.bufferSize);
            this.readPool = new AsyncSocketEventArgsPool();
            this.writePool = new AsyncSocketEventArgsPool();
#if NET40
            this.tokens = new ConcurrentDictionary<Guid,AsyncSocketTokenEventArgs>();
            this.singleIPTokens = new ConcurrentDictionary<IPAddress, AsyncSocketTokenEventArgs>();
#else
            this.tokens = new Dictionary<Guid, AsyncSocketTokenEventArgs>();
            this.singleIPTokens = new Dictionary<IPAddress, AsyncSocketTokenEventArgs>();
#endif
            if (semaphore) this.maxNumberAcceptedClients = new Semaphore(this.maxConnections, this.maxConnections);
            this.bufferManager.InitBuffer();
            SocketAsyncEventArgs readWriteEventArg;
            AsyncSocketTokenEventArgs token;

            // read Pool
            for (int i = 0; i < this.maxConnections; i++) {
                token = new AsyncSocketTokenEventArgs();
                token.ReadEventArgs.Completed += new EventHandler<SocketAsyncEventArgs>(this.IO_Completed);
                this.bufferManager.SetBuffer(token.ReadEventArgs);
                token.SetBuffer(token.ReadEventArgs.Buffer, token.ReadEventArgs.Offset);
                this.readPool.Push(token.ReadEventArgs);
            }

            // write Pool
            for (int i = 0; i < this.maxConnections; i++) {
                readWriteEventArg = new SocketAsyncEventArgs();
                readWriteEventArg.Completed += new EventHandler<SocketAsyncEventArgs>(this.IO_Completed);
                readWriteEventArg.UserToken = null;
                this.bufferManager.SetBuffer(readWriteEventArg);
                this.writePool.Push(readWriteEventArg);
            }
        }

        /// <summary>
        /// 开始接受连接请求
        /// </summary>
        /// <param name="acceptEventArg">SocketAsyncEventArgs.</param>
        [SuppressMessage("Microsoft.Reliability", "CA2000:Dispose objects before losing scope", Justification = "Reviewed.")]
        [EnvironmentPermissionAttribute(SecurityAction.Demand, Unrestricted = true)]
        private void StartAccept(SocketAsyncEventArgs acceptEventArg) {
            if (acceptEventArg == null) {
                acceptEventArg = new SocketAsyncEventArgs();
                acceptEventArg.Completed += new EventHandler<SocketAsyncEventArgs>(this.AcceptEventArg_Completed);
            } else {
                acceptEventArg.AcceptSocket = null;
            }

            try {
                if (semaphore) {
                    if (!this.maxNumberAcceptedClients.SafeWaitHandle.IsClosed) {
                        this.maxNumberAcceptedClients.WaitOne();

                        bool willRaiseEvent = this.listenSocket.AcceptAsync(acceptEventArg);
                        if (!willRaiseEvent) {
                            this.ProcessAccept(acceptEventArg);
                        }
                    }
                } else {
                    bool willRaiseEvent = this.listenSocket.AcceptAsync(acceptEventArg);
                    if (!willRaiseEvent) {
                        this.ProcessAccept(acceptEventArg);
                    }
                }
            } catch (ObjectDisposedException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.StartAccept", e.Source, e.Message, e.StackTrace, e.ToString()));
            } catch (SocketException e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.StartAccept", e.Source, e.Message, e.StackTrace, e.ToString()));
                this.OnError(null, new AsyncSocketErrorEventArgs("服务器接受客户端请求发生异常！", e, AsyncSocketErrorCode.ServerAcceptException));
            } catch (Exception e) {
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.StartAccept", e.Source, e.Message, e.StackTrace, e.ToString()));
            }
        }

        /// <summary>
        /// 这个方法是关联异步接受操作的回调方法并且当接收操作完成时被调用 
        /// </summary>
        /// <param name="sender">Event sender.</param>
        /// <param name="e">Instance of SocketAsyncEventArgs.</param>
        private void AcceptEventArg_Completed(object sender, SocketAsyncEventArgs e) {
            this.ProcessAccept(e);
        }

        /// <summary>
        /// 接受请求
        /// </summary>
        /// <param name="e">SocketAsyncEventArgs.</param>
        private void ProcessAccept(SocketAsyncEventArgs e) {
            if (e.SocketError != SocketError.Success) {
                if (semaphore && !this.maxNumberAcceptedClients.SafeWaitHandle.IsClosed) {
                    try {
                        this.maxNumberAcceptedClients.Release();
                    } catch { }
                }
                this.StartAccept(e);
                return;
            }
            AsyncSocketTokenEventArgs token;
            Interlocked.Increment(ref this.numConnectedSockets);
            if (debug) Debug.Write(string.Format("有 {0} 个客户端已连接服务器！", this.numConnectedSockets.ToString()));
            SocketAsyncEventArgs readEventArg;
            readEventArg = this.readPool.Pop();
            if (numConnectedSockets > maxConnections || readEventArg == null) { 
                if (debug) Debug.Write(string.Format("达到最大连接数：{0}/{1}！", this.numConnectedSockets.ToString(), this.maxConnections.ToString()));
                CloseClientSocket(e.AcceptSocket);
                return;
            }
            token = (AsyncSocketTokenEventArgs)readEventArg.UserToken;
            token.Socket = e.AcceptSocket;
            token.ConnectionID = Guid.NewGuid();

            if (token != null && token.EndPoint != null) {
#if NET40
                this.tokens[token.ConnectionID] = token;
                if (!this.singleIPTokens.ContainsKey(token.EndPoint.Address)) {
                    this.singleIPTokens.TryAdd(token.EndPoint.Address, token);
                }
#else
                lock (((ICollection)this.tokens).SyncRoot) {
                    this.tokens[token.ConnectionID] = token;
                }

                lock (((ICollection)this.singleIPTokens).SyncRoot) {
                    if (!this.singleIPTokens.ContainsKey(token.EndPoint.Address)) {
                        this.singleIPTokens.Add(token.EndPoint.Address, token);
                    }
                }
#endif

                this.RaiseEvent(this.Connected, token);

                try {
                    if (token.Socket.Connected) {
                        bool willRaiseEvent = token.Socket.ReceiveAsync(readEventArg);
                        if (!willRaiseEvent) {
                            this.ProcessReceive(readEventArg);
                        }
                    }
                } catch (ObjectDisposedException) {
                    this.RaiseDisconnectedEvent(token);
                } catch (SocketException socketException) {
                    if (socketException.ErrorCode == (int)SocketError.ConnectionReset) {
                        this.RaiseDisconnectedEvent(token);
                    } else {
                        this.OnError(token, new AsyncSocketErrorEventArgs("异步接收数据发生异常！", socketException));
                    }
                } catch (Exception ex) {
                    if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.ProcessAccept", ex.Source, ex.Message, ex.StackTrace, ex.ToString()));
                    this.OnError(token, new AsyncSocketErrorEventArgs(ex.Message, ex, AsyncSocketErrorCode.ThrowSocketException));
                } finally {
                    this.StartAccept(e);
                }
            }
        }

        /// <summary>
        /// 这个方法在一个Socket读或者发送操作完成时被调用
        /// </summary>
        /// <param name="sender">Event sender.</param>
        /// <param name="e">SocketAsyncEventArgs.</param>
        private void IO_Completed(object sender, SocketAsyncEventArgs e) {
            switch (e.LastOperation) {
                case SocketAsyncOperation.Receive:
                    this.ProcessReceive(e);
                    break;
                case SocketAsyncOperation.Send:
                    this.ProcessSend(e);
                    break;
                default:
                    throw new ArgumentException("最后一次在Socket上的操作不是接收或者发送操作！");
            }
        }

        /// <summary>
        /// 这个方法在异步接收操作完成时调用.
        /// 如果远程主机关闭连接Socket将关闭
        /// </summary>
        /// <param name="e">Instance of SocketAsyncEventArgs.</param>
        private void ProcessReceive(SocketAsyncEventArgs e) {
            AsyncSocketTokenEventArgs token = (AsyncSocketTokenEventArgs)e.UserToken;

            if (e.BytesTransferred > 0 && e.SocketError == SocketError.Success) {
                Interlocked.Add(ref this.totalBytesRead, e.BytesTransferred);
                if (debug) Debug.Write(string.Format("服务器总接收字节: {0}", this.totalBytesRead.ToString()));

                token.SetReceivedBytesSize(e.BytesTransferred);
                this.RaiseEvent(this.DataReceived, token);

                try {
                    if (token.Socket.Connected) {
                        bool willRaiseEvent = token.Socket.ReceiveAsync(e);
                        if (!willRaiseEvent) {
                            this.ProcessReceive(e);
                        }
                    }
                } catch (ObjectDisposedException) {
                    this.RaiseDisconnectedEvent(token);
                } catch (SocketException socketException) {
                    if (socketException.ErrorCode == (int)SocketError.ConnectionReset) {
                        this.RaiseDisconnectedEvent(token);
                    } else {
                        this.OnError(token, new AsyncSocketErrorEventArgs("异步接收数据发生异常！", socketException));
                    }
                } catch (Exception ex) {
                    if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.ProcessReceive", ex.Source, ex.Message, ex.StackTrace, ex.ToString()));
                }
            } else {
                this.RaiseDisconnectedEvent(token);
            }
        }

        /// <summary>
        /// 这个方法当一个异步发送操作完成时被调用.  
        /// </summary>
        /// <param name="e">Instance of SocketAsyncEventArgs.</param>
        private void ProcessSend(SocketAsyncEventArgs e) {
            AsyncSocketTokenEventArgs token = (AsyncSocketTokenEventArgs)e.UserToken;
            Interlocked.Add(ref this.totalBytesWrite, e.BytesTransferred);

            if (e.Count > this.bufferSize) {
                this.bufferManager.SetBuffer(e);
            }

            this.writePool.Push(e);
            e.UserToken = null;

            if (e.SocketError == SocketError.Success) {
                if (debug) Debug.Write(string.Format("服务器总发送字节: {0}", e.BytesTransferred.ToString()));
                this.RaiseEvent(this.DataSent, token);
            } else {
                this.RaiseDisconnectedEvent(token);
            }
        }

        /// <summary>
        /// 引发断开连接事件
        /// </summary>
        /// <param name="token">Instance of AsyncSocketTokenEventArgs.</param>
        private void RaiseDisconnectedEvent(AsyncSocketTokenEventArgs token) {
            if (null != token) {
#if NET40
                if (token.EndPoint != null) {
                    AsyncSocketTokenEventArgs t;
                    this.singleIPTokens.TryRemove(token.EndPoint.Address, out t);
                }

                AsyncSocketTokenEventArgs tt;
                if (this.tokens.TryRemove(token.ConnectionID, out tt)) {
                    this.CloseClientSocket(token);

                    if (null != token) {
                        this.RaiseEvent(this.Disconnected, token);
                    }
                }
#else
                if (token.EndPoint != null) {
                    lock (((ICollection)this.singleIPTokens).SyncRoot) {
                        this.singleIPTokens.Remove(token.EndPoint.Address);
                    }
                }

                lock (((ICollection)this.tokens).SyncRoot) {
                    if (this.tokens.Remove(token.ConnectionID)) {
                        this.CloseClientSocket(token);

                        if (null != token) {
                            this.RaiseEvent(this.Disconnected, token);
                        }
                    }
                }
#endif
            }
        }

        /// <summary>
        /// 引发断开连接事件
        /// </summary>
        /// <param name="token">Instance of AsyncSocketTokenEventArgs.</param>
        [EnvironmentPermissionAttribute(SecurityAction.Demand, Unrestricted = true)]
        private void CloseClientSocket(AsyncSocketTokenEventArgs token) {
            try {
                if (token.Socket.Connected) {
                    token.Socket.Shutdown(SocketShutdown.Both);
                    token.Socket.Close();
                }
            } catch (ObjectDisposedException) {
                if (debug) Debug.Write("ObjectDisposedException");
            } catch (SocketException) {
                token.Socket.Close();
            } catch (Exception e) {
                token.Socket.Close();
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.CloseClientSocket", e.Source, e.Message, e.StackTrace, e.ToString()));
            } finally {
                Interlocked.Decrement(ref this.numConnectedSockets);

                if (semaphore && !this.maxNumberAcceptedClients.SafeWaitHandle.IsClosed) {
                    try {
                        this.maxNumberAcceptedClients.Release();
                    } catch { }
                }

                if (debug) Debug.Write(string.Format("有 {0} 个客户端已连接服务器！", this.numConnectedSockets.ToString()));
                this.readPool.Push(token.ReadEventArgs);
            }
        }
        /// <summary>
        /// 关闭SOCKET
        /// </summary>
        /// <param name="socket"></param>
        private void CloseClientSocket(Socket socket) {
            try {
                if (socket.Connected) {
                    socket.Shutdown(SocketShutdown.Both);
                    socket.Close();
                }
            } catch (ObjectDisposedException) {
                if (debug) Debug.Write("ObjectDisposedException");
            } catch (SocketException) {
                socket.Close();
            } catch (Exception e) {
                socket.Close();
                if (debug) Debug.Write(string.Format(errorFormat, "AsyncSocketServer.CloseClientSocket", e.Source, e.Message, e.StackTrace, e.ToString()));
            } finally {
                Interlocked.Decrement(ref this.numConnectedSockets);

                if (semaphore && !this.maxNumberAcceptedClients.SafeWaitHandle.IsClosed) {
                    try {
                        this.maxNumberAcceptedClients.Release();
                    } catch { }
                }

                if (debug) Debug.Write(string.Format("有 {0} 个客户端已连接服务器！", this.numConnectedSockets.ToString()));
            }
        }

        /// <summary>
        /// 检查是否释放
        /// </summary>
        private bool CheckDisposed() {
            return this.disposed;
        }
    }
}
