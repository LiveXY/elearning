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
    /// 客户端接收消息事件接口
    /// </summary>
    public interface ISocketClientEvent {
        /// <summary>
        /// 消息处理
        /// </summary>
        /// <param name="package">包</param>
        /// <param name="client">客户端</param>
        void Process(INetPackage package, IAsyncSocketClient client);
    }

    /// <summary>
    /// 监听客户端消息接收
    /// </summary>
    public class AsyncSocketClientReceive {
        private static Dictionary<int, ISocketClientEvent> clientEvents = new Dictionary<int, ISocketClientEvent>();
        /// <summary>
        /// 注册消息业务处理事件
        /// </summary>
        /// <typeparam name="T">网络消息</typeparam>
        public static void RegisterEvent<T>(int cmd) where T : ISocketClientEvent, new() {
            T t = new T();
            if (!clientEvents.ContainsKey(cmd)) {
                clientEvents.Add(cmd, t);
            }
        }
        /// <summary>
        /// 注销消息业务处理事件
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public static void RemoveEvent<T>(int cmd) where T : ISocketClientEvent, new() {
            if (clientEvents.ContainsKey(cmd)) {
                clientEvents.Remove(cmd);
            }
        }
        /// <summary>
        /// 注销所有消息业务处理事件
        /// </summary>
        public static void RemoveAllEvent() {
            clientEvents.Clear();
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
        /// <param name="client">客户端</param>
        public static void Listener<TPackageParse>(AsyncSocketTokenEventArgs e, IAsyncSocketClient client = null) where TPackageParse : INetPackageParse, new() {
            try {
                IList<INetPackage> packages = Singleton<TPackageParse>.Instance().Parse(e, AsyncSocketClientReceive.LittleEndian, AsyncSocketClientReceive.MaxPackageSize);
                if (packages == null) {
                    client.Disconnect();
                    if (AsyncSocketClientReceive.ErrorMsg != null) AsyncSocketClientReceive.ErrorMsg.BeginInvoke("超出最大包大小：" + AsyncSocketClientReceive.MaxPackageSize.ToString() + "，连接被强行断开！", null, null);
                } else {
                    foreach (INetPackage package in packages) {
                        if (package != null) {
                            if (clientEvents.ContainsKey(package.Command)) {
                                clientEvents[package.Command].Process(package, client);
                            } else if (AsyncSocketClientReceive.ErrorMsg != null) AsyncSocketClientReceive.ErrorMsg.BeginInvoke(package.Command.ToString() + "指令不存在！", null, null);
                        }
                    }
                }
            } catch (Exception ex) {
                if (AsyncSocketClientReceive.ErrorMsg != null) AsyncSocketClientReceive.ErrorMsg.BeginInvoke(ex.Message, null, null);
            }
        }
    }
}
