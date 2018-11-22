using System;
using Pub.Class.Net;
using System.Threading;
using System.Collections.Generic;

namespace tcptest {
    class MainClass {
        private static AsyncSocketServer server;

        private static void ServerMsg(string msg) {
            Console.WriteLine(string.Format("[{0}] - {1}", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), msg));
        }

        private static void server_Connected(object sender, AsyncSocketTokenEventArgs e) {
            ServerMsg(e.ConnectionID.ToString() + " 连接成功！");
        }
        private static void server_Disconnected(object sender, AsyncSocketTokenEventArgs e) {
            ServerMsg(e.ConnectionID.ToString() + " 断开连接！");
            AsyncSocketServerReceive.RemoveListener<StreamPackageParse>(e.ConnectionID); //服务端断开连接时，清理包缓存数据
        }
        private static void server_Error(object sender, AsyncSocketErrorEventArgs e) {
            ServerMsg(e.ErrorCode.ToString() + e.Message);
        }
        private static void server_DataReceived(object sender, AsyncSocketTokenEventArgs e) {
            AsyncSocketServerReceive.Listener<StreamPackageParse>(e, server); //服务端接收监听
        }

        private static void sendLoginSuccess(AsyncSocketServer server, Guid ConnectionID) {
            StreamPackage<ResultMessage> result = new StreamPackage<ResultMessage>();
            result.Command = Command.Login;
            result.Data.Ret = 0;
            server.Send(ConnectionID, result.DataBytes());
        }
        private static void broadcastMessage(int uid) {
            StreamPackage<LabaMessage> labaPost = new StreamPackage<LabaMessage>();
            labaPost.Command = Command.BigData;
            labaPost.Data.Data = uid.ToString() + "上线了！";
            server.Broadcast(labaPost.DataBytes());

            ServerMsg(labaPost.Data.Data);
        }
        private static void sendFriendsMessage(AsyncSocketServer server, Guid ConnectionID) {
            StreamPackage<UsersMessage> usersMessage = new StreamPackage<UsersMessage>();
            usersMessage.Command = Command.Friends;
            usersMessage.Data.List = new List<UserMessage>() { 
                new UserMessage() { UID = 1, NickName = "11", Avatar = "111" }, 
                new UserMessage() { UID = 2, NickName = "22", Avatar = "222" },
                new UserMessage() { UID = 3, NickName = "33", Avatar = "333" }
            };
            server.Send(ConnectionID, usersMessage.DataBytes());
        }

        public class LoginEvent : ISocketServerEvent {
            public void Process(INetPackage package, Guid ConnectionID, AsyncSocketServer server) {
                LoginMessage login = package.NetMessage<LoginMessage>();
                ServerMsg("请求登录:" + login.UID + "，并回复客户端登录成功");

                sendLoginSuccess(server, ConnectionID);

                broadcastMessage(login.UID);
            }
        }
        public class FriendsEvent : ISocketServerEvent {
            public void Process(INetPackage package, Guid ConnectionID, AsyncSocketServer server) {
                FriendsMessage result = package.NetMessage<FriendsMessage>();
                ServerMsg(result.UID + "获取好友数据！");
                sendFriendsMessage(server, ConnectionID);
            }
        }
        public class LabaEvent : ISocketServerEvent {
            public void Process(INetPackage package, Guid ConnectionID, AsyncSocketServer server) {
                LabaMessage labaResult = package.NetMessage<LabaMessage>();
                ServerMsg(labaResult.Data);
            }
        }

        public static void Main(string[] args) {
            AsyncSocketServerReceive.LittleEndian = true;
            AsyncSocketServerReceive.MaxPackageSize = 1024*1024;
            AsyncSocketServerReceive.ErrorMsg = ServerMsg;
            AsyncSocketServerReceive.RegisterEvent<LoginEvent>(Command.Login);
            AsyncSocketServerReceive.RegisterEvent<FriendsEvent>(Command.Friends);
            AsyncSocketServerReceive.RegisterEvent<LabaEvent>(Command.BigData);

            server = new AsyncSocketServer("tcp://*:3000", 100, 4096);
            server.Connected += new EventHandler<AsyncSocketTokenEventArgs>(server_Connected); //连接成功
            server.Disconnected += new EventHandler<AsyncSocketTokenEventArgs>(server_Disconnected); //断开连接
            server.DataReceived += new EventHandler<AsyncSocketTokenEventArgs>(server_DataReceived); //接收到数据
            server.Error += new EventHandler<AsyncSocketErrorEventArgs>(server_Error); //出错
            server.Start(); //开始监听
            ServerMsg("监听端口3000");

            Thread.Sleep(10000000);
        }
    }
}
