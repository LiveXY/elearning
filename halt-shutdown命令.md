halt
halt命令用来关闭正在运行的Linux操作系统。halt命令会先检测系统的runlevel，若runlevel为0或6，则关闭系统，否则即调用shutdown来关闭系统。
语法：
halt(选项)
选项：
-d：不要在wtmp中记录；
-f：不论目前的runlevel为何，不调用shutdown即强制关闭系统；
-i：在halt之前，关闭全部的网络界面；
-n：halt前，不用先执行sync；
-p：halt之后，执行poweroff；
-w：仅在wtmp中记录，而不实际结束系统。
实例：
halt -p //关闭系统后关闭电源。
halt -d //关闭系统，但不留下纪录。


shutdown
shutdown命令用来系统关机命令。shutdown指令可以关闭所有程序，并依用户的需要，进行重新开机或关机的动作。
语法：
shutdown(选项)(参数)
选项：
-c：当执行“shutdown -h 11:50”指令时，只要按+键就可以中断关机的指令；
-f：重新启动时不执行fsck；
-F：重新启动时执行fsck；
-h：将系统关机；
-k：只是送出信息给所有用户，但不会实际关机；
-n：不调用init程序进行关机，而由shutdown自己进行；
-r：shutdown之后重新启动； -t<秒数>：送出警告信息和删除信息之间要延迟多少秒。
参数：
[时间]：设置多久时间后执行shutdown指令；
[警告信息]：要传送给所有登入用户的信息。
实例：
指定现在立即关机：
shutdown -h now
指定5分钟后关机，同时送出警告信息给登入用户：
shutdown +5 "System will shutdown after 5 minutes"