using System;
using Pub.Class.Net;
using System.Text;
using System.Collections.Generic;

namespace tcptest {
    public class Command {
        public static int Login = 10000;
        public static int Laba = 10001;
        public static int BigData = 10002;
        public static int Friends = 10003;
    }
    public class LoginMessage : IStreamMessage {
        public int UID = 0;
        public void Read(StreamReader reader) { UID = reader.ReadInt(); }
        public void Write(StreamWriter writer) { writer.Write(UID); }
    }
    public class FriendsMessage : LoginMessage { }
    public class ResultMessage : IStreamMessage {
        public int Ret = 0;
        public void Read(StreamReader reader) { Ret = reader.ReadInt(); }
        public void Write(StreamWriter writer) { writer.Write(Ret); }
    }
    public class LabaMessage : IStreamMessage {
        public string Data = "";
        public void Read(StreamReader reader) { Data = reader.ReadUTF(); }
        public void Write(StreamWriter writer) { writer.WriteUTF(Data); }
    }
    public class UserMessage : IStreamMessage {
        public int UID = 0;
        public string NickName = "";
        public string Avatar = "";
        public void Read(StreamReader reader) { UID = reader.ReadInt(); NickName = reader.ReadUTF(); Avatar = reader.ReadUTF(); }
        public void Write(StreamWriter writer) { writer.Write(UID); writer.WriteUTF(NickName); writer.WriteUTF(Avatar); }
    }
    public class UsersMessage: IStreamMessage {
        public IList<UserMessage> List { get; set; }
        public void Read(StreamReader reader) { List = reader.ReadList<UserMessage>(); }
        public void Write(StreamWriter writer) { writer.WriteList<UserMessage>(List); }
    }
    public class Tools {
        public static int RndInt(int num1, int num2) {
            Random rnd = new Random(Guid.NewGuid().GetHashCode());
            return rnd.Next(num1, num2);
        }
        public static string RndString(int len) {
            char[] arrChar = new char[]{
                'a','b','d','c','e','f','g','h','i','j','k','l','m','n','p','r','q','s','t','u','v','w','z','y','x',
                '_',
                'A','B','C','D','E','F','G','H','I','J','K','L','M','N','Q','P','R','T','S','V','U','W','X','Y','Z'};
            StringBuilder num = new StringBuilder();
            Random rnd = new Random(Guid.NewGuid().GetHashCode());
            for (int i = 0; i < len; i++) {
                num.Append(arrChar[rnd.Next(0, arrChar.Length)].ToString());
            }
            return num.ToString();
        }
    }
}
