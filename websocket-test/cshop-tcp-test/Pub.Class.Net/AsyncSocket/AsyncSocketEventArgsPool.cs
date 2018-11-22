#if NETCLIENT
namespace Pub.Class.NetClient {
#else
namespace Pub.Class.Net {
#endif
    using System.Collections;
    using System.Collections.Generic;
    using System.Net.Sockets;

    /// <summary>
    /// SocketAsyncEventArgs池.
    /// </summary>
    internal class AsyncSocketEventArgsPool {
        /// <summary>
        /// SocketAsyncEventArgs对象池
        /// </summary>
        private Queue<SocketAsyncEventArgs> pool;

        /// <summary>
        /// 实例初始化数据
        /// </summary>
        public AsyncSocketEventArgsPool() {
            this.pool = new Queue<SocketAsyncEventArgs>();
        }

        /// <summary>
        /// 获取SocketAsyncEventArgs对像数
        /// </summary>
        public int Count {
            get {
                lock (((ICollection)this.pool).SyncRoot) {
                    return this.pool.Count;
                }
            }
        }

        /// <summary>
        /// 在池中添加一个SocketAsyncEventArgs
        /// </summary>
        /// <param name="item">SocketAsyncEventArgs</param>
        public void Push(SocketAsyncEventArgs item) {
            lock (((ICollection)this.pool).SyncRoot) {
                this.pool.Enqueue(item);
            }
        }

        /// <summary>
        /// 在池中删除一个SocketAsyncEventArgs
        /// </summary>
        /// <returns>SocketAsyncEventArgs</returns>
        public SocketAsyncEventArgs Pop() {
            lock (((ICollection)this.pool).SyncRoot) {
                if (this.pool.Count == 0) return null;
                return this.pool.Dequeue();
            }
        }

        /// <summary>
        /// 清理Pool
        /// </summary>
        public void Clear() { 
            lock (((ICollection)this.pool).SyncRoot) {
                this.pool.Clear();
            }
        }
    }
}
