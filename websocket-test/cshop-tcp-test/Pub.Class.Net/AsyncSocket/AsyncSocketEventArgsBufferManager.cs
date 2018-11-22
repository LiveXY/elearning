namespace Pub.Class.Net {
    using System.Collections;
    using System.Collections.Generic;
    using System.Net.Sockets;

    /// <summary>
    /// 这个类创建一个可以被划分和分配给SocketAsyncEventArgs对象每次操作可以使用的单独的打的缓冲区
    /// 这可以使缓冲区很容易地被重复使用并且防止在内从中堆积碎片。    
    /// BufferManager 类暴露的操作不是线程安全的(需要做线程安全处理)
    /// </summary>
    internal class AsyncSocketEventArgsBufferManager {
        /// <summary>
        /// 控制的缓冲池的字节总数。
        /// </summary>
        private int numBytes;

        /// <summary>
        /// Buffer 字节
        /// </summary>
        private byte[] buffer;

        /// <summary>
        /// 释放的索引池
        /// </summary>
        private Stack<int> freeIndexPool;

        /// <summary>
        /// 当前索引
        /// </summary>
        private int currentIndex;

        /// <summary>
        /// 缓冲区大小
        /// </summary>
        private int bufferSize;

        /// <summary>
        /// 初始化缓冲区管理对象
        /// </summary>
        /// <param name="totalBytes">缓冲区管理对象管理的字节总数</param>
        /// <param name="bufferSize">每个缓冲区大小</param>
        public AsyncSocketEventArgsBufferManager(int totalBytes, int bufferSize) {
            this.numBytes = totalBytes;
            this.currentIndex = 0;
            this.bufferSize = bufferSize;
            this.freeIndexPool = new Stack<int>();
        }

        /// <summary>
        /// 分配被缓冲区池使用的缓冲区空间
        /// </summary>
        public void InitBuffer() {
            // 创建一个大的大缓冲区并且划分给每一个SocketAsyncEventArgs对象
            this.buffer = new byte[this.numBytes];
        }

        /// <summary>
        /// 从缓冲区池中分配一个缓冲区给指定的SocketAsyncEventArgs对象
        /// </summary>
        /// <param name="args">SocketAsyncEventArgs.</param>
        /// <returns>如果缓冲区被成功设置返回真否则返回假</returns>
        public bool SetBuffer(SocketAsyncEventArgs args) {
            lock (((ICollection)this.freeIndexPool).SyncRoot) {
                if (this.freeIndexPool.Count > 0) {
                    int offset = this.freeIndexPool.Pop();
                    args.SetBuffer(this.buffer, offset, this.bufferSize);
                    return true;
                }
            }

            if ((this.numBytes - this.bufferSize) < this.currentIndex) {
                return false;
            } else {
                args.SetBuffer(this.buffer, this.currentIndex, this.bufferSize);
                this.currentIndex += this.bufferSize;
                return true;
            }
        }

        /// <summary>
        /// 从一个SocketAsyncEventArgs对象上删除缓冲区，这将把缓冲区释放回缓冲区池 
        /// </summary>
        /// <param name="args">SocketAsyncEventArgs.</param>
        public void FreeBuffer(SocketAsyncEventArgs args) {
            lock (((ICollection)this.freeIndexPool).SyncRoot) {
                this.freeIndexPool.Push(args.Offset);
            }

            args.SetBuffer(null, 0, 0);
        }
    }
}
