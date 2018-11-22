using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Runtime.Serialization;
using Pub.Class;
using System.Threading;

#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif

    /// <summary>
    /// 服务端接收消息事件接口
    /// </summary>
    public interface ISocketServerEvent {
        /// <summary>
        /// 消息处理
        /// </summary>
        /// <param name="package">包</param>
        /// <param name="ConnectionID">客户端ID</param>
        /// <param name="server">服务端</param>
        void Process(INetPackage package, Guid ConnectionID, AsyncSocketServer server);
    }

    /// <summary>
    /// 监听服务端消息接收
    /// </summary>
    public class AsyncSocketServerReceive {
        private static Dictionary<int, ISocketServerEvent> serverEvents = new Dictionary<int, ISocketServerEvent>();

        /// <summary>
        /// 注册消息业务处理事件
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public static void RegisterEvent<T>(int cmd) where T : ISocketServerEvent, new() {
            T t = new T();
            if (!serverEvents.ContainsKey(cmd)) {
                serverEvents.Add(cmd, t);
            }
        }
        /// <summary>
        /// 注销消息业务处理事件
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public static void RemoveEvent<T>(int cmd) where T : ISocketServerEvent, new() {
            if (serverEvents.ContainsKey(cmd)) {
                serverEvents.Remove(cmd);
            }
        }
        /// <summary>
        /// 注销所有消息业务处理事件
        /// </summary>
        public static void RemoveAllEvent() {
            serverEvents.Clear();
        }
        /// <summary>
        /// 清理未解包的数据包
        /// </summary>
        /// <typeparam name="TPackageParse"></typeparam>
        /// <param name="guid"></param>
        public static void RemoveListener<TPackageParse>(Guid guid) where TPackageParse : INetPackageParse, new() {
            Singleton<TPackageParse>.Instance().Remove(guid);
        }

        /// <summary>
        /// 小端
        /// </summary>
        public static bool LittleEndian = true;
        /// <summary>
        /// 出错消息
        /// </summary>
        public static Action<string> ErrorMsg = null;
        /// <summary>
        /// 最大包大小
        /// </summary>
        public static int MaxPackageSize = 10240;

        /// <summary>
        /// 开始监听
        /// </summary>
        /// <param name="e">接收数据</param>
        /// <param name="server">服务端</param>
        public static void Listener<TPackageParse>(AsyncSocketTokenEventArgs e, AsyncSocketServer server) where TPackageParse : INetPackageParse, new() {
            try {
                IList<INetPackage> packages = Singleton<TPackageParse>.Instance().Parse(e, AsyncSocketServerReceive.LittleEndian, AsyncSocketServerReceive.MaxPackageSize);
                if (packages == null) {
                    server.Disconnect(e.ConnectionID);
                    if (AsyncSocketServerReceive.ErrorMsg != null) AsyncSocketServerReceive.ErrorMsg.BeginInvoke("超出最大包大小：" + AsyncSocketServerReceive.MaxPackageSize.ToString() + "，连接被强行断开！", null, null);
                } else {
                    foreach (INetPackage package in packages) {
                        if (package != null) {
                            if (serverEvents.ContainsKey(package.Command)) {
                                serverEvents[package.Command].Process(package, e.ConnectionID, server);
                            } else if (AsyncSocketServerReceive.ErrorMsg != null) AsyncSocketServerReceive.ErrorMsg.BeginInvoke(package.Command.ToString() + "指令不存在！", null, null);
                        }
                    }
                }
            } catch (Exception ex) {
                if (AsyncSocketServerReceive.ErrorMsg != null) AsyncSocketServerReceive.ErrorMsg.BeginInvoke(ex.Message, null, null);
            }
        }
    }
}
