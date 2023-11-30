---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@worker-node-2:~/.kube$ kubectl get all --all-namespaces
NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
kube-system   pod/calico-kube-controllers-85c94cb9d-jls86   1/1     Running   0          54m
kube-system   pod/calico-node-ctk7d                         0/1     Running   0          55m
kube-system   pod/calico-node-qz5p5                         0/1     Running   0          55m
kube-system   pod/calico-node-v4b5x                         0/1     Running   0          55m
kube-system   pod/coredns-5dd5756b68-hmc2x                  1/1     Running   0          155m
kube-system   pod/coredns-5dd5756b68-thdzm                  1/1     Running   0          155m
kube-system   pod/etcd-master-node                          1/1     Running   0          155m
kube-system   pod/kube-apiserver-master-node                1/1     Running   0          155m
kube-system   pod/kube-controller-manager-master-node       1/1     Running   0          155m
kube-system   pod/kube-proxy-2trvh                          1/1     Running   0          155m
kube-system   pod/kube-proxy-lj55v                          1/1     Running   0          100m
kube-system   pod/kube-proxy-z64r5                          1/1     Running   0          109m
kube-system   pod/kube-scheduler-master-node                1/1     Running   0          155m

NAMESPACE     NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  155m
kube-system   service/kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   155m

NAMESPACE     NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/calico-node   3         3         0       3            0           kubernetes.io/os=linux   65m
kube-system   daemonset.apps/kube-proxy    3         3         3       3            3           kubernetes.io/os=linux   155m

NAMESPACE     NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/calico-kube-controllers   1/1     1            1           65m
kube-system   deployment.apps/coredns                   2/2     2            2           155m

NAMESPACE     NAME                                                DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/calico-kube-controllers-85c94cb9d   1         1         1       54m
kube-system   replicaset.apps/calico-kube-controllers-cb558bf6    0         0         0       65m
kube-system   replicaset.apps/coredns-5dd5756b68                  2         2         2       155m
ubuntu@worker-node-2:~/.kube$ kubectl -n kube-system get cm kubeadm-config -o yaml
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

ubuntu@worker-node-2:~/.kube$ sudo kubectl get pods --all-namespaces -o wide
E1130 07:49:03.472032   49855 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:03.472205   49855 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:03.473436   49855 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:03.474654   49855 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:03.475849   49855 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
The connection to the server localhost:8080 was refused - did you specify the right host or port?
ubuntu@worker-node-2:~/.kube$ kubectl get pods --all-namespaces -o wide
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE    IP               NODE            NOMINATED NODE   READINESS GATES
kube-system   calico-kube-controllers-85c94cb9d-jls86   1/1     Running   0          54m    192.168.212.65   worker-node-1   <none>           <none>
kube-system   calico-node-ctk7d                         0/1     Running   0          55m    172.20.15.237    worker-node-1   <none>           <none>
kube-system   calico-node-qz5p5                         0/1     Running   0          55m    172.20.15.170    worker-node-2   <none>           <none>
kube-system   calico-node-v4b5x                         0/1     Running   0          55m    172.20.14.87     master-node     <none>           <none>
kube-system   coredns-5dd5756b68-hmc2x                  1/1     Running   0          155m   192.168.77.129   master-node     <none>           <none>
kube-system   coredns-5dd5756b68-thdzm                  1/1     Running   0          155m   192.168.77.130   master-node     <none>           <none>
kube-system   etcd-master-node                          1/1     Running   0          156m   172.20.14.87     master-node     <none>           <none>
kube-system   kube-apiserver-master-node                1/1     Running   0          156m   172.20.14.87     master-node     <none>           <none>
kube-system   kube-controller-manager-master-node       1/1     Running   0          156m   172.20.14.87     master-node     <none>           <none>
kube-system   kube-proxy-2trvh                          1/1     Running   0          155m   172.20.14.87     master-node     <none>           <none>
kube-system   kube-proxy-lj55v                          1/1     Running   0          100m   172.20.15.170    worker-node-2   <none>           <none>
kube-system   kube-proxy-z64r5                          1/1     Running   0          109m   172.20.15.237    worker-node-1   <none>           <none>
kube-system   kube-scheduler-master-node                1/1     Running   0          156m   172.20.14.87     master-node     <none>           <none>

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@worker-node-2:~/.kube$ kubectl cluster-info dump | grep -m 1 "cluster-cidr"
                            "--cluster-cidr=192.168.0.0/16",

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@worker-node-2:~/.kube$ sudo kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
E1130 07:49:28.595852   50011 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:28.596037   50011 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:28.597340   50011 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:28.598543   50011 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E1130 07:49:28.599767   50011 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
The connection to the server localhost:8080 was refused - did you specify the right host or port?

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@worker-node-2:~/.kube$ kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
NAME            TAINTS
master-node     <none>
worker-node-1   <none>
worker-node-2   <none>

---------------------------------------------------------------------------------------------------------------------------------------

ubuntu@worker-node-2:~/.kube$ kubectl cluster-info
Kubernetes control plane is running at https://172.20.14.87:6443
CoreDNS is running at https://172.20.14.87:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
