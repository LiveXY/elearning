#if NETCLIENT
namespace Pub.Class.NetClient {
#else 
namespace Pub.Class.Net {
#endif
    using System;

    /// <summary>
    /// 异步Socket错误事件
    /// </summary>
    public class AsyncSocketErrorEventArgs : EventArgs {
        /// <summary>
        /// 实例初始化
        /// </summary>
        public AsyncSocketErrorEventArgs() : this(string.Empty, null) { }

        /// <summary>
        /// 实例初始化
        /// </summary>
        /// <param name="message">Error Message.</param>
        /// <param name="exception">Exception object.</param>
        /// <param name="errorCode">Instance of AsyncSocketErrorCode.</param>
        public AsyncSocketErrorEventArgs(string message, Exception exception, AsyncSocketErrorCode errorCode = AsyncSocketErrorCode.ThrowSocketException) {
            this.Message = message;
            this.Exception = exception;
            this.ErrorCode = errorCode;
        }

        /// <summary>
        /// 错误消息
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// 错误异常
        /// </summary>
        public Exception Exception { get; set; }

        /// <summary>
        /// 错误代码
        /// </summary>
        public AsyncSocketErrorCode ErrorCode { get; set; }
    }
}
