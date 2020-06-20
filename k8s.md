Kubernetes
======

centos7.7安装基础工具
```
yum install -y wget curl psmisc sysstat unzip lsof telnet epel-release git mysql
```

修改服务器名称
```
cat /etc/redhat-release
hostname #不能有下划线
hostnamectl status
hostnamectl set-hostname k8s-master
```
关闭防火墙
```
systemctl stop firewalld.service
systemctl disable firewalld.service
firewall-cmd --state
```
关闭SELINUX
```
cat /etc/selinux/config | grep SELINUX
setenforce 0
vi /etc/selinux/config
SELINUX=disabled
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```

安全组开放端口：2379-2380 10250-10252
```
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload
```

时间同步
```
timedatectl set-timezone Asia/Shanghai
ntpdate cn.pool.ntp.org
```

设置文件数限制
```
tee /etc/security/limits.conf <<-'EOF'
root soft nofile 102400
root hard nofile 102400
* soft nofile 102400
* hard nofile 102400
EOF
```

设置路由
```
cat <<EOF > /etc/sysctl.d/k8s.conf
vm.swappiness = 0
vm.overcommit_memory = 1
vm.panic_on_oom = 0
fs.inotify.max_user_watches = 89100

net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1

EOF
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

echo "modprobe br_netfilter" >> /etc/rc.local
lsmod | grep br_netfilter

vi /etc/sysctl.conf
fs.file-max = 2000000
fs.nr_open = 122880

net.ipv4.neigh.default.gc_stale_time=120
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.lo.arp_announce=2
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2

net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_syn_backlog = 262144
net.core.netdev_max_backlog =  262144
net.core.somaxconn = 262144
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
kernel.sysrq=1

sysctl --system
sysctl net.ipv4.ip_forward=1
```

关闭系统的Swap
```
swapoff -a

vi /etc/fstab
#注释掉 SWAP 的自动挂载 永久关闭swap，重启后生效
```

安装kubernetes
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetesprometheus-dfd976959-qfnkz
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet kubeadm kubectl
systemctl enable --now kubelet
systemctl restart kubelet
```

docker安装
```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum -y install docker-ce

vi /etc/docker/daemon.json
"registry-mirrors": ["https://容器镜像服务->镜像加速器获得.mirror.aliyuncs.com"]
systemctl daemon-reload
systemctl restart docker.service
systemctl status docker.service
systemctl enable docker.service

Failed at step LIMITS spawning /usr/bin/dockerd-current: Operation not permitted
vi /usr/lib/systemd/system/docker.service
vi /usr/lib/systemd/system/containerd.service
LimitNOFILE=10240
LimitNPROC=10240
LimitCORE=10240

systemctl daemon-reload
systemctl restart docker.service

docker -v
19.03.8

yum list --showduplicates | grep 'kubeadm\|kubectl\|kubelet'
systemctl status docker kubelet
systemctl restart docker kubelet
systemctl enable docker kubelet
systemctl stop docker kubelet && systemctl disable docker kubelet

```

master节点执行
```
kubeadm init --kubernetes-version=v1.18.2 --image-repository registry.aliyuncs.com/google_containers --service-cidr=10.20.0.0/16 --pod-network-cidr=10.244.0.0/16 --service-dns-domain=dcs.sg258.local --apiserver-advertise-address=10.10.0.216

配置kubectl工具：
rm $HOME/.kube -rf
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```

node节点执行
```
kubeadm join 10.10.0.216:6443 --token s98mcw.zpg0m6fkmrcgfm95 --discovery-token-ca-cert-hash sha256:0b4bde27bdf3d7f69513b9074184c900278cd6d67a597f5050f4c187fef3a8db
```

node节点使用 kubectl
```
ssh 10.10.0.217
mkdir -p ~/.kube
scp 10.10.0.216:/etc/kubernetes/admin.conf ~/.kube/config
scp 10.10.0.216:~/.ssh/id_rsa ~/.ssh/id_rsa
chown $(id -u):$(id -g) $HOME/.kube/config
```

安装flannel 网络
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-aliyun.yml
如果有多个网卡，需要在kube-flannel.yml中使用–iface参数指定集群主机内网网卡的名称，否则可能会出现dns无法解析。需要将kube-flannel.yml下载到本地，flanneld启动参数command上加–iface=eth1

VxLAN也支持host-gw的功能， 即直接通过物理网卡的网关路由转发，而不用隧道flannel叠加，从而提高了VxLAN的性能，这种flannel的功能叫directrouting
vi kube-flannel.yml
net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "vxlan",
        "Directrouting":true #新加
      }
kubectl apply -f kube-flannel.yml
```

配置
```
vi /etc/sysconfig/kubelet
KUBE_PROXY_MODE=ipvs

kubectl edit cm kube-proxy -n kube-system
mode: "ipvs"

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
chmod u+x /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
kubectl get pod -n kube-system | grep kube-proxy |awk '{system("kubectl delete pod "$1" -n kube-system")}'
kubectl get pod -n kube-system |grep kube-proxy
kubectl logs -n kube-system kube-proxy-dj5zg --tail=20
Failed to list IPVS destinations, error: parseIP
cat /boot/grub2/grub.cfg | grep menuentry
当前3.10 升级 到4.4 http://www.mydlq.club/article/78/
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
yum list available --disablerepo=* --enablerepo=elrepo-kernel
yum install -y kernel-lt-4.4.220-1.el7.elrepo --enablerepo=elrepo-kernel
cat /boot/grub2/grub.cfg | grep menuentry
grub2-set-default "CentOS Linux (4.4.220-1.el7.elrepo.x86_64) 7 (Core)"
grub2-editenv list
reboot
uname -r
ipvsadm -Ln
for p in $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name); \
  do kubectl logs --namespace=kube-system $p; done
kubectl get service -n kube-system | grep kube-dns
kubectl get endpoints kube-dns -n kube-system
```

安装Calico 网络
```
1.安装前检查主机名不能有大写字母，只能由小写字母 - . 组成。
2.安装前必须确保各节点主机名不重复 ，calico node name 由节点主机名决定，如果重复，那么重复节点在etcd中只存储一份配置，BGP 邻居也不会建立。
3.安装之前必须确保kube-master和kube-node节点已经成功部署。
只需要在任意装有kubectl客户端的节点运行 kubectl apply -f安装即可。
4.等待15s后(视网络拉取calico相关镜像速度--这里使用kubeadm.sh提前拉取)，
calico 网络插件安装完成，删除之前kube-node安装时默认cni网络配置。
5.本K8S集群运行在同网段kvm虚机上，虚机间没有网络ACL限制，因此可以设置CALICO_IPV4POOL_IPIP=off
如果你的主机位于不同网段，或者运行在公有云上需要打开这个选项CALICO_IPV4POOL_IPIP=always
配置FELIX_DEFAULTENDPOINTTOHOSTACTION=ACCEPT 默认允许Pod到Node的网络流量。

安装指定版本
kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

curl https://docs.projectcalico.org/manifests/calico.yaml -O
curl https://docs.projectcalico.org/manifests/calico-typha.yaml -o calico.yaml
kubectl apply -f calico.yaml
我们建议每200个节点至少一个副本，并且不超过20个副本。在生产中，我们建议至少使用三个副本，以减少滚动升级和故障的影响。副本数应始终小于节点数，否则滚动升级将停止。此外，只有在Typha实例少于节点的情况下，Typha才有助于扩展。

curl https://docs.projectcalico.org/manifests/calico-etcd.yaml -o calico.yaml
cat /etc/kubernetes/manifests/etcd.yaml
kubectl get configmap -n kube-system
kubectl get configmap calico-config -o json -n kube-system
kubectl edit configmap calico-config -n kube-system
将的值设置为etcd_endpoint setcd服务器的IP地址和端口
https://www.jianshu.com/p/106eb0a09765

cd /usr/local/bin/
curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.13.3/calicoctl
chmod +x calicoctl
calicoctl get node
calicoctl get ippool
calicoctl node status
route -n
netstat -anp | grep ESTABLISH | grep bird
calicoctl get bgpconfig
calicoctl get bgppeer

calicoctl get ippool -o wide
calicoctl get wep --all-namespaces
calicoctl delete pool default-ipv4-ippool
calicoctl delete pool 10.1.1.0/24

kubectl create -f ./test/busybox.yaml
kubectl exec -it busybox sh
kubectl run linux-alpine --image=alpine --replicas=2 sleep 360
kubectl get pods
kubectl exec -it linux-alpine-56749b4d9-5vtld sh
https://www.jianshu.com/p/dbf4a343f56c
```

重置
```
kubeadm reset

NODE节点 networkPlugin cni failed to set up pod
kubeadm reset
systemctl stop kubelet docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down
ifconfig docker0 down
ip link delete cni0
ip link delete flannel.1
systemctl start docker kubelet
```

更新新版本
```
yum list updates | grep 'kubelet'
yum install -y kubelet-1.18.2-0

检查群集是否可以升级
kubeadm upgrade plan
kubeadm upgrade apply v1.18.2
kubeadm upgrade --force #可从故障状态恢复
```

常用
```
kubeadm config images list #查看镜像

kubectl get nodes
kubectl get nodes -o wide
kubectl get cs #集群状态
kubectl get pods --all-namespaces
kubectl get deployments
kubectl get rs
kubectl get pods --show-labels
kubectl get pod --all-namespaces -o wide --show-labels
kubectl cluster-info #查看集群信息
kubectl get all --all-namespaces -o wide
kubectl get endpoints --all-namespaces -o wide
kubectl get endpoints -n sg -o wide
kubectl get ingress -n sg -o wide

kubectl get namespace
kubectl create namespace sg #创建test名称空间

kubectl describe pod xxx
kubectl describe rs xxx
kubectl describe deploy xxx
kubectl describe service xxx

#删除节点
kubectl delete node k8s-node1

#删除pod deploy service
kubectl delete -n sg pod rmsxjg-nginx
kubectl delete -n sg deploy/rmsxjg-nginx-deployment
kubectl delete -n sg svc/rmsxjg-nginx-service
kubectl delete -n sg statefulset rmsxjg-nginx-deployment
kubectl delete -n sg endpoints rmsxjg-nginx-deployment

kubectl drain k8s-master-01 --ignore-daemonsets #标记为不可调度
kubectl uncordon k8s-master-01 #标记为可调度

kubeadm init 启动一个 Kubernetes 主节点
kubeadm join 启动一个 Kubernetes 工作节点并且将其加入到集群
kubeadm upgrade 更新一个 Kubernetes 集群到新版本
kubeadm config 如果使用 v1.7.x 或者更低版本的 kubeadm 初始化集群，您需要对集群做一些配置以便使用 kubeadm upgrade 命令
kubeadm token 管理 kubeadm join 使用的令牌
kubeadm reset 还原 kubeadm init 或者 kubeadm join 对主机所做的任何更改

kubectl run busybox --image=busybox --command -- ping baidu.com
kubectl get pod memcached -n sg -o yaml

kubeadm token list
```

安装NGINX
```
kubectl run nginx --image=nginx --port=80
kubectl exec -it nginx -- nginx -v
kubectl exec -it nginx -- sh
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort --name=nginx-service
kubectl expose deploy nginx --port=80 --target-port=80 --name=http-svc
kubectl get pod,svc
扩容：
kubectl scale deployment nginx-deployment --replicas 10
如果集群支持 horizontal pod autoscaling 的话，还可以为Deployment设置自动扩展：
kubectl autoscale deployment nginx-deployment --min=10 --max=15 --cpu-percent=80
更新镜像也比较简单:
kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
回滚：
kubectl rollout undo deployment/nginx-deployment
编辑
kubectl edit deployment/nginx-deployment
查看状态
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment --revision=2
kubectl rollout undo deployment/nginx-deployment --to-revision=2
kubectl describe deployments
kubectl rollout pause deployment/nginx-deployment
kubectl set resources deployment nginx -c=nginx --limits=cpu=200m,memory=512Mi
kubectl rollout resume deploy nginx
将deployment的nginx容器cpu限制为200m，将内存设置为512M
kubectl set resources deployment nginx -c=nginx --limits=cpu=200m,memory=512Mi

kubectl run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool] [--overrides=inline-json] [--command] -- [COMMAND] [args...]
http://docs.kubernetes.org.cn/468.html
kubectl run nginx --replicas=2 --labels="run=load-balancer-example" --image=nginx:1.9 --port=80

kubectl get pod --all-namespaces -o wide|grep nginx
发布一个服务
kubectl expose deployment nginx --type=NodePort --name=nginx-service
kubectl expose deployment nginx --port=88 --type=NodePort --target-port=80 --name=nginx-service

kubectl exec nginx-app-f75d46bd9-q6c76 ps aux
kubectl describe pod nginx-app-f75d46bd9-q6c76
kubectl logs nginx-app-f75d46bd9-q6c76 --tail=20

kubectl delete pod nginx
kubectl delete deploy/nginx
kubectl delete svc/nginx-service
```

安装NODEJS
```
kubectl run k8snode --image=tumaimes/node_web:0.1 --port=8080 --generator=run-pod/v1
kubectl expose rc k8snode --type=LoadBalancer --name kubia-http
kubectl scale rc k8snode --replicas=2
```

安装memcached
```
kubectl run memcached --image=memcached --port=11211 -n sg
kubectl exec -it memcached -- ls -lh
kubectl expose pod memcached --type=NodePort --name=memcached-service
kubectl describe pods memcached
kubectl logs pods memcached --tail=20
kubectl delete pod memcached
kubectl delete svc/memcached-service
telnet 10.244.0.7 11211
```

安装redis
```
kubectl run redis --image=redis --port=6379
kubectl exec -it redis -- ls -lh
kubectl delete pod redis
```

安装mysql
```
kubectl run mysql --image=mysql:5.7 --port=3306 --env="MYSQL_ROOT_PASSWORD=123456" -n sg
kubectl exec -it mysql -- ls -lh
kubectl describe pods mysql
kubectl logs mysql --tail=20
mysql -h10.244.0.12 -uroot -p123456
kubectl delete pod mysql
kubectl get all -n sg -o wide --show-labels
```

部署Dashboard
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl get pod --all-namespaces -o wide
kubectl get pods -n kubernetes-dashboard -o wide
kubectl get services -n kubernetes-dashboard
kubectl get deployment kubernetes-dashboard -n kubernetes-dashboard
修改配置
kubectl -n kubernetes-dashboard edit service kubernetes-dashboard
修改type:ClusterIP 改为type:NodePort nodePort: 31024
kubectl -n kubernetes-dashboard get service kubernetes-dashboard
查看端口
kubectl get svc -n kubernetes-dashboard

kubectl apply -f ./k8s/dashboard/adminuser.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

安装Heapster为集群添加使用统计和监控功能，为Dashboard添加仪表盘。
mkdir -p ./k8s/dashboard/heapster
cd ./k8s/dashboard/heapster
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl create -f ./heapster/
```

移除 node 节点
```
#只在 master 节点执行
kubectl drain node-1 --delete-local-data --force --ignore-daemonsets
kubectl delete node node-1
#只在 node-1 节点执行
kubeadm reset
```

单机集群需要执行 使Master节点参与工作负载
```
kubectl get pods --all-namespaces -o wide
kubectl describe pods memcached
nodes are available: 1 node(s) had taint {node-role.kubernetes.io/master: }, that the pod didn't tolerate.
kubectl taint nodes k8s-master node-role.kubernetes.io/master=:NoSchedule
kubectl taint nodes k8s-master node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl taint nodes k8s-01 node-role.kubernetes.io/master=:NoSchedule
kubectl taint nodes k8s-02 node-role.kubernetes.io/master=:PreferNoSchedule
kubectl taint nodes k8s-03 node-role.kubernetes.io/master=:PreferNoSchedule

kubectl taint node k8s-master node-role.kubernetes.io/master=""
```

启动CURL镜像
```
kubectl run curl --image=radial/busyboxplus:curl -i --tty
> nslookup kubernetes.default
> exit
```

部署AspNetCore
```
https://www.cnblogs.com/RainingNight/p/10230496.html
https://github.com/RainingNight/AspNetCoreDocker
```

kubeadm init的参数：
```
--apiserver-advertise-address string
API Server将要广播的监听地址。如指定为 `0.0.0.0` 将使用缺省的网卡地址。
--apiserver-bind-port int32 缺省值: 6443
API Server绑定的端口
--apiserver-cert-extra-sans stringSlice
可选的额外提供的证书主题别名（SANs）用于指定API Server的服务器证书。可以是IP地址也可以是DNS名称。
--cert-dir string 缺省值: "/etc/kubernetes/pki"
证书的存储路径。
--config string
kubeadm配置文件的路径。警告：配置文件的功能是实验性的。
--cri-socket string 缺省值: "/var/run/dockershim.sock"
指明要连接的CRI socket文件
--dry-run
不会应用任何改变；只会输出将要执行的操作。
--feature-gates string
键值对的集合，用来控制各种功能的开关。可选项有:
Auditing=true|false (当前为ALPHA状态 - 缺省值=false)
CoreDNS=true|false (缺省值=true)
DynamicKubeletConfig=true|false (当前为BETA状态 - 缺省值=false)
-h, --help
获取init命令的帮助信息
--ignore-preflight-errors stringSlice
忽视检查项错误列表，列表中的每一个检查项如发生错误将被展示输出为警告，而非错误。 例如: 'IsPrivilegedUser,Swap'. 如填写为 'all' 则将忽视所有的检查项错误。
--kubernetes-version string 缺省值: "stable-1"
为control plane选择一个特定的Kubernetes版本。
--node-name string
指定节点的名称。
--pod-network-cidr string
指明pod网络可以使用的IP地址段。 如果设置了这个参数，control plane将会为每一个节点自动分配CIDRs。
--service-cidr string 缺省值: "10.96.0.0/12"
为service的虚拟IP地址另外指定IP地址段
--service-dns-domain string 缺省值: "cluster.local"
为services另外指定域名, 例如： "myorg.internal".
--skip-token-print
不打印出由 `kubeadm init` 命令生成的默认令牌。
--token string
这个令牌用于建立主从节点间的双向受信链接。格式为 [a-z0-9]{6}\.[a-z0-9]{16} - 示例： abcdef.0123456789abcdef
--token-ttl duration 缺省值: 24h0m0s
令牌被自动删除前的可用时长 (示例： 1s, 2m, 3h). 如果设置为 '0', 令牌将永不过期。
```

问题
```
Unable to connect to the server: x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
rm -rf $HOME/.kube
```

重要概念
```
1.cluster
cluster是 计算、存储和网络资源的集合，k8s利用这些资源运行各种基于容器的应用。
2.master
master是cluster的大脑，他的主要职责是调度，即决定将应用放在那里运行。master运行linux操作系统，可以是物理机或者虚拟机。为了实现高可用，可以运行多个master。
3.node
node的职责是运行容器应用。node由master管理，node负责监控并汇报容器的状态，同时根据master的要求管理容器的生命周期。node运行在linux的操作系统上，可以是物理机或者是虚拟机。
4.pod
pod是k8s的最小工作单元。每个pod包含一个或者多个容器。pod中的容器会作为一个整体被master调度到一个node上运行。
5.controller
k8s通常不会直接创建pod,而是通过controller来管理pod的。controller中定义了pod的部署特性，比如有几个剧本，在什么样的node上运行等。为了满足不同的业务场景，k8s提供了多种controller，包括deployment、replicaset、daemonset、statefulset、job等。
6.deployment
是最常用的controller。deployment可以管理pod的多个副本，并确保pod按照期望的状态运行。
7.replicaset
实现了pod的多副本管理。使用deployment时会自动创建replicaset，也就是说deployment是通过replicaset来管理pod的多个副本的，我们通常不需要直接使用replicaset。
8.daemonset
用于每个node最多只运行一个pod副本的场景。正如其名称所示的，daemonset通常用于运行daemon。
9.statefuleset
能够保证pod的每个副本在整个生命周期中名称是不变的，而其他controller不提供这个功能。当某个pod发生故障需要删除并重新启动时，pod的名称会发生变化，同时statefulset会保证副本按照固定的顺序启动、更新或者删除。、
10.job
用于运行结束就删除的应用，而其他controller中的pod通常是长期持续运行的。
11.service
deployment可以部署多个副本，每个pod 都有自己的IP，外界如何访问这些副本那？
答案是service
k8s的 service定义了外界访问一组特定pod的方式。service有自己的IP和端口，service为pod提供了负载均衡。
k8s运行容器pod与访问容器这两项任务分别由controller和service执行。
12.namespace
可以将一个物理的cluster逻辑上划分成多个虚拟cluster，每个cluster就是一个namespace。不同的namespace里的资源是完全隔离的。
13.labels
Labels是用于区分Pod、Service、Replication Controller的key/value键值对，仅使用在Pod、Service、 Replication Controller之间的关系识别，但对这些单元本身进行操作时得使用name标签。
14.Proxy   
Proxy不但解决了同一主宿机相同服务端口冲突的问题，还提供了Service转发服务端口对外提供服务的能力，Proxy后端使用了随机、轮循负载均衡算法。
15.ingress
16.endpoint
```

其它PHP扩展安装
```
docker-php-ext-install -j$(nproc) bcmath calendar exif gettext sockets dba mysqli pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm

bz2 扩展的安装, 读写 bzip2（.bz2）压缩文件
apt-get update && \
apt-get install -y --no-install-recommends libbz2-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) bz2

enchant 扩展的安装, 拼写检查库
apt-get update && \
apt-get install -y --no-install-recommends libenchant-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) enchant

gd 扩展的安装. 图像处理
apt-get update && \
apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
docker-php-ext-install -j$(nproc) gd

gmp 扩展的安装, GMP
apt-get update && \
apt-get install -y --no-install-recommends libgmp-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) gmp

soap wddx xmlrpc tidy xsl 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libxml2-dev libtidy-dev libxslt1-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) soap wddx xmlrpc tidy xsl

zip 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libzip-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) zip

snmp 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libsnmp-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) snmp

pgsql, pdo_pgsql 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libpq-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) pgsql pdo_pgsql

pspell 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libpspell-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) pspell

recode 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends librecode-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) recode

pdo_firebird 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends firebird-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) pdo_firebird

pdo_dblib 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends freetds-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-configure pdo_dblib --with-libdir=lib/x86_64-linux-gnu && \
docker-php-ext-install -j$(nproc) pdo_dblib

ldap 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libldap2-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
docker-php-ext-install -j$(nproc) ldap

imap 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libc-client-dev libkrb5-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
docker-php-ext-install -j$(nproc) imap

interbase 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends firebird-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) interbase

intl 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libicu-dev && \
rm -r /var/lib/apt/lists/* && \
docker-php-ext-install -j$(nproc) intl

mcrypt 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends libmcrypt-dev && \
rm -r /var/lib/apt/lists/* && \
pecl install mcrypt-1.0.1 && \
docker-php-ext-enable mcrypt

imagick 扩展的安装
export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" && \
apt-get update && \
apt-get install -y --no-install-recommends libmagickwand-dev && \
rm -rf /var/lib/apt/lists/* && \
pecl install imagick-3.4.3 && \
docker-php-ext-enable imagick

memcached 扩展的安装
apt-get update && \
apt-get install -y --no-install-recommends zlib1g-dev libmemcached-dev && \
rm -r /var/lib/apt/lists/* && \
pecl install memcached && \
docker-php-ext-enable memcached

redis 扩展的安装
pecl install redis-4.0.1 && docker-php-ext-enable redis

opcache 扩展的安装
docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache
```

NODE节点一直显示 NoReady
journalctl -f -u kubelet

kind: Pod/Deployment
spec:
  hostNetwork: true #因此端口只在容器运行的vm上监听

kind: Service
spec:
  type: NodePort #svc上的nodeport会监听在所有的NODE节点上,如果不指定由apiserver指定--service-node-port-range '30000-32767'
  externalIPs:
  	- 192.168.2.12 #在某台指定的node上监听,而非像nodeport所有节点监听

  type: LoadBalancer
  loadBalancerIP: 外网IP地址

route #查看路由表
route -n #查看路由表

Flannel -> Calico
修改 --pod-network-cidr=10.244.0.0/16 为：--pod-network-cidr=192.168.0.0/16
kubectl -n kube-system edit cm kubeadm-config
vim /etc/kubernetes/manifests/kube-scheduler.yaml
将 10.244.0.0/16 改为 192.168.0.0/16
检查配置是否生效
kubectl cluster-info dump | grep -m 1 cluster-cidr
sudo cat /etc/kubernetes/manifests/kube-controller-manager.yaml | grep -i cluster-cidr
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
kubectl get node k8s-node1 -o yaml | grep podCIDR
kubectl patch node k8s-node1 -p '{"spec":{"podCIDR":"10.244.0.0/16"}}'
kubectl patch svc http-svc -p '{"spec":{"type": "LoadBalancer"}}'
kubectl patch svc http-svc -p '{"spec":{"type": "NodePort"}}'
kubectl get configmap -n kube-system
kubectl get configmap kube-flannel-cfg -o json -n kube-system
kubectl edit configmap kube-flannel-cfg -n kube-system
kubectl get configmap -n kube-system kube-flannel-cfg -o json -n kube-system
https://www.cnblogs.com/fawaikuangtu123/p/11296382.html


buster10(2020) stretch9(2017) jessie8(2015) wheezy7(2013) squeeze6 都是 Debian 发行版本的代称
带 slim 的就是瘦身版 Debian 和 glibc
