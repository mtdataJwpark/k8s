---------------------------------------------------------------------------------------------------------------------------------------
ubuntu@master-node:~$ kubectl cluster-info dump | grep -m 1 "cluster-cidr"
                            "--cluster-cidr=192.168.0.0/16",

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@master-node:~$ sudo calicoctl node status
Calico process is running.

IPv4 BGP status
+---------------+-------------------+-------+----------+---------+
| PEER ADDRESS  |     PEER TYPE     | STATE |  SINCE   |  INFO   |
+---------------+-------------------+-------+----------+---------+
| 172.20.15.237 | node-to-node mesh | start | 06:54:06 | Passive |
| 172.20.15.170 | node-to-node mesh | start | 06:54:06 | Passive |
+---------------+-------------------+-------+----------+---------+

IPv6 BGP status
No IPv6 peers found.

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@master-node:~$ sudo kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
NAME            TAINTS
master-node     <none>
worker-node-1   <none>
worker-node-2   <none>

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@master-node:~$ sudo kubectl cluster-info
Kubernetes control plane is running at https://172.20.14.87:6443
CoreDNS is running at https://172.20.14.87:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@master-node:~$ kubectl get nodes
NAME            STATUS   ROLES           AGE   VERSION
master-node     Ready    control-plane   68m   v1.28.2
worker-node-1   Ready    <none>          22m   v1.28.2
worker-node-2   Ready    <none>          13m   v1.28.2

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@master-node:~$ kubectl get all --all-namespaces
NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
kube-system   pod/calico-kube-controllers-85c94cb9d-jls86   1/1     Running   0          31m
kube-system   pod/calico-node-ctk7d                         0/1     Running   0          31m
kube-system   pod/calico-node-qz5p5                         0/1     Running   0          31m
kube-system   pod/calico-node-v4b5x                         0/1     Running   0          31m
kube-system   pod/coredns-5dd5756b68-hmc2x                  1/1     Running   0          132m
kube-system   pod/coredns-5dd5756b68-thdzm                  1/1     Running   0          132m
kube-system   pod/etcd-master-node                          1/1     Running   0          132m
kube-system   pod/kube-apiserver-master-node                1/1     Running   0          132m
kube-system   pod/kube-controller-manager-master-node       1/1     Running   0          132m
kube-system   pod/kube-proxy-2trvh                          1/1     Running   0          132m
kube-system   pod/kube-proxy-lj55v                          1/1     Running   0          77m
kube-system   pod/kube-proxy-z64r5                          1/1     Running   0          85m
kube-system   pod/kube-scheduler-master-node                1/1     Running   0          132m

NAMESPACE     NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  132m
kube-system   service/kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   132m

NAMESPACE     NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/calico-node   3         3         0       3            0           kubernetes.io/os=linux   42m
kube-system   daemonset.apps/kube-proxy    3         3         3       3            3           kubernetes.io/os=linux   132m

NAMESPACE     NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/calico-kube-controllers   1/1     1            1           42m
kube-system   deployment.apps/coredns                   2/2     2            2           132m

NAMESPACE     NAME                                                DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/calico-kube-controllers-85c94cb9d   1         1         1       31m
kube-system   replicaset.apps/calico-kube-controllers-cb558bf6    0         0         0       42m
kube-system   replicaset.apps/coredns-5dd5756b68                  2         2         2       132m

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@master-node:~$  kubectl -n kube-system get cm kubeadm-config -o yaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      extraArgs:
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta3
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controllerManager: {}
    dns: {}
    etcd:
      local:
        dataDir: /var/lib/etcd
    imageRepository: registry.k8s.io
    kind: ClusterConfiguration
    kubernetesVersion: v1.28.4
    networking:
      dnsDomain: cluster.local
      podSubnet: 192.168.0.0/16
      serviceSubnet: 10.96.0.0/12
    scheduler: {}
kind: ConfigMap
metadata:
  creationTimestamp: "2023-11-30T05:13:02Z"
  name: kubeadm-config
  namespace: kube-system
  resourceVersion: "233"
  uid: 283fc628-891c-474b-8ed2-b29012f757d3

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@master-node:~$ sudo kubectl get pods --all-namespaces -o wide
NAMESPACE     NAME                                     READY   STATUS              RESTARTS      AGE   IP              NODE            NOMINATED NODE   READINESS GATES
kube-system   calico-kube-controllers-cb558bf6-2b9mq   0/1     Terminating         0             78m   <none>          worker-node-1   <none>           <none>
kube-system   calico-kube-controllers-cb558bf6-sbx6r   0/1     ContainerCreating   0             76s   <none>          worker-node-2   <none>           <none>
kube-system   calico-node-c2vp5                        0/1     CrashLoopBackOff    3 (21s ago)   76s   172.20.15.170   worker-node-2   <none>           <none>
kube-system   calico-node-csdt5                        0/1     CrashLoopBackOff    3 (30s ago)   76s   172.20.15.237   worker-node-1   <none>           <none>
kube-system   calico-node-h2hll                        0/1     CrashLoopBackOff    3 (33s ago)   76s   172.20.14.87    master-node     <none>           <none>
kube-system   coredns-5dd5756b68-hmc2x                 0/1     ContainerCreating   0             78m   <none>          master-node     <none>           <none>
kube-system   coredns-5dd5756b68-thdzm                 0/1     ContainerCreating   0             78m   <none>          master-node     <none>           <none>
kube-system   etcd-master-node                         1/1     Running             0             78m   172.20.14.87    master-node     <none>           <none>
kube-system   kube-apiserver-master-node               1/1     Running             0             78m   172.20.14.87    master-node     <none>           <none>
kube-system   kube-controller-manager-master-node      1/1     Running             0             78m   172.20.14.87    master-node     <none>           <none>
kube-system   kube-proxy-2trvh                         1/1     Running             0             78m   172.20.14.87    master-node     <none>           <none>
kube-system   kube-proxy-lj55v                         1/1     Running             0             23m   172.20.15.170   worker-node-2   <none>           <none>
kube-system   kube-proxy-z64r5                         1/1     Running             0             32m   172.20.15.237   worker-node-1   <none>           <none>
kube-system   kube-scheduler-master-node               1/1     Running             0             78m   172.20.14.87    master-node     <none>           <none>
