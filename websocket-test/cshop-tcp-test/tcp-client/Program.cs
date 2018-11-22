using System;
using Pub.Class.Net;
using System.Threading;
using System.Collections.Generic;

namespace tcptest {
    class MainClass {
        private static AsyncSocketClient client;

        private static void ClientMsg(string msg) {
            Console.WriteLine(string.Format("[{0}] - {1}", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), msg));
        }

        private static void client_Connected(object sender, AsyncSocketTokenEventArgs e) {
            ClientMsg("连接服务器成功，向服务器发送登录消息！");

            sendLoginMessage();
        }
        private static void client_Disconnected(object sender, AsyncSocketTokenEventArgs e) {
            AsyncSocketClientReceive.RemoveListener<StreamPackageParse>(e.ConnectionID); //客户端断开连接时，清理包缓存数据
        }
        private static void client_Error(object sender, AsyncSocketErrorEventArgs e) {
            ClientMsg(e.ErrorCode.ToString() + e.Message);
        }
        private static void client_DataReceived(object sender, AsyncSocketTokenEventArgs e) {
            AsyncSocketClientReceive.Listener<StreamPackageParse>(e, client); //客户端接收监听 使用StreamPackageParse
        }

        private static void sendLoginMessage() {
            StreamPackage<LoginMessage> loginPost = new StreamPackage<LoginMessage>();
            loginPost.Command = Command.Login;
            loginPost.Data.UID = Tools.RndInt(10000, 99999);
            client.Send(loginPost.DataBytes());
        }
        private static void sendBigMessage() {
            for (var i = 0; i < 10; i++) {
                StreamPackage<LabaMessage> bigPost = new StreamPackage<LabaMessage>();
                bigPost.Command = Command.BigData;
                bigPost.Data.Data = "第" + i.ToString() + "个大数据：" + Tools.RndString(Tools.RndInt(100, 10000));
                client.Send(bigPost.DataBytes());

                ClientMsg(bigPost.Data.Data);
            }
        }
        private static void sendFriendsMessage() {
            StreamPackage<FriendsMessage> friendPost = new StreamPackage<FriendsMessage>();
            friendPost.Command = Command.Friends;
            friendPost.Data.UID = Tools.RndInt(10000, 99999);
            client.Send(friendPost.DataBytes());
        }

        public class LoginEvent : ISocketClientEvent {
            public void Process(INetPackage package, IAsyncSocketClient client) {
                ResultMessage loginResult = package.NetMessage<ResultMessage>();
                ClientMsg(loginResult.Ret == 0 ? "登录服务器成功！" : "登录服务器失败！");

                sendBigMessage();
                sendFriendsMessage();
            }
        }
        public class FriendsEvent : ISocketClientEvent {
            public void Process(INetPackage package, IAsyncSocketClient client) {
                UsersMessage friendsResult = package.NetMessage<UsersMessage>();
                for (var i = 0; i < friendsResult.List.Count; i++) {
                    UserMessage info = friendsResult.List[i];
                    ClientMsg(info.UID.ToString() + "->" + info.NickName + "->" + info.Avatar);
                }
            }
        }
        public class LabaEvent : ISocketClientEvent {
            public void Process(INetPackage package, IAsyncSocketClient client) {
                LabaMessage labaResult = package.NetMessage<LabaMessage>();
                ClientMsg(labaResult.Data);
            }
        }

        public static void Main(string[] args) {
            AsyncSocketClientReceive.LittleEndian = true;
            AsyncSocketClientReceive.MaxPackageSize = 1024 * 1024;
            AsyncSocketClientReceive.ErrorMsg = ClientMsg;
            AsyncSocketClientReceive.RegisterEvent<LoginEvent>(Command.Login);
            AsyncSocketClientReceive.RegisterEvent<FriendsEvent>(Command.Friends);
            AsyncSocketClientReceive.RegisterEvent<LabaEvent>(Command.Laba);
            AsyncSocketClientReceive.RegisterEvent<LabaEvent>(Command.BigData);

            client = new AsyncSocketClient(4096);
            client.Connected += new EventHandler<AsyncSocketTokenEventArgs>(client_Connected); //连接成功
            client.Disconnected += new EventHandler<AsyncSocketTokenEventArgs>(client_Disconnected); //断开连接
            client.DataReceived += new EventHandler<AsyncSocketTokenEventArgs>(client_DataReceived); //接收到数据
            client.Error += new EventHandler<AsyncSocketErrorEventArgs>(client_Error); //出错
            client.Connect("tcp://127.0.0.1:3000"); //连接服务器

            Thread.Sleep(10000000);
        }
    }
}
