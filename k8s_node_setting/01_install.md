# Kubernetes 클러스터 설정
---  
## yaml 설정 코드
[yaml 설정 코드](https://docs.projectcalico.org/v3.11/manifests/calico.yaml)  

---  
## Master Node 설정 (master_setup.sh)
---  

```
#!/bin/bash

# Kubernetes GPG 키 추가
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg

# Kubernetes apt 저장소 설정
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

# 기본 설치 (Master & Worker 공통)
# Docker 설치
sudo apt update
sudo apt install -y docker.io

# kubeadm, kubelet, kubectl 설치
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 자동실행 설정 – 시스템 재부팅 시 자동실행되도록 설정
sudo systemctl enable docker kubelet

# Master 설정
# 클러스터 생성
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# kubectl (권한) 설정
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# kubectl get all —all-namespaces 한 번 쳐보기
sudo kubectl get nodes # 아직 NotReady

# Cluster에 network 배포 (Calico Pod Network)
# Calico 설치
sudo curl https://docs.projectcalico.org/archive/v3.17/manifests/calico.yaml -O
sudo kubectl apply -f calico.yaml
```  
---  
###### 주의: 특정 부분에 에러가 발생하면 calico.yaml 파일을 수정하고 주석을 해제하세요.
---  

```
# 주석 해제 후 계속 진행
sudo kubectl get pods -n kube-system
sudo kubectl get daemonset -n kube-system
sudo kubectl get deployment -n kube-system
sudo kubectl get serviceaccount -n kube-system
sudo kubectl get clusterrole -n kube-system
sudo kubectl get clusterrolebinding -n kube-system
sudo kubectl get configmap -n kube-system
sudo kubectl get customresourcedefinitions.apiextensions.k8s.io

# 설치 확인
sudo kubectl get pods -n kube-system

# 클러스터 노드 확인 (마스터 노드 동작 확인) > STATUS=Ready인지 확인
sudo kubectl get nodes -o wide
```  

---  
## Worker Node 설정 (worker_setup.sh)

```
#!/bin/bash

# Kubernetes GPG 키 추가
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg

# Kubernetes apt 저장소 설정
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

# 기본 설치 (Master & Worker 공통)
# Docker 설치
sudo apt update
sudo apt install -y docker.io

# kubeadm, kubelet, kubectl 설치
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 자동실행 설정 – 시스템 재부팅 시 자동실행되도록 설정
sudo systemctl enable docker kubelet

# Worker Node 등록
sudo kubeadm join 172.20.14.87:6443 --token pad0gy.kdo8y43bxiacp4h2 --discovery-token-ca-cert-hash sha256:46f9185a08c0d24b840b5d6deb3a87e2a9c0c0eef3385e4158052f11e69c5f55

# Token 확인 (잃어버린 경우)
# sudo kubeadm token list

# Token 갱신 (기본 24시간 후 삭제)
# sudo kubeadm token create
```  
---
---  

## Master Node 확인 명령어 (master_commands.sh)
```
# Cluster 정보 확인
kubectl cluster-info dump | grep -m 1 "cluster-cidr"

# Calico 상태 확인
sudo calicoctl node status

# 노드 및 Taints 확인
sudo kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints

# Kubernetes Cluster 정보
sudo kubectl cluster-info

# 노드 확인
sudo kubectl get nodes

# 모든 리소스 확인
sudo kubectl get all --all-namespaces

# kubeadm-config ConfigMap 정보 확인
sudo kubectl -n kube-system get cm kubeadm-config -o yaml
```  
이 명령어는 Master Node에서 실행됩니다.


## 클러스터 구성
#### Kubernetes 클러스터 구성
                Master Node: master-node
                IP: 172.20.14.87
                Role: control-plane
                Worker Nodes:
                worker-node-1
                worker-node-2
  
#### Cluster Network 구성
                Pod Network: 192.168.0.0/16
                Service Network: 10.96.0.0/12

#### Cluster 상태 확인
## 모든 노드가 Ready 상태인지 확인
                kubectl get nodes

#### Calico 상태 확인
                sudo calicoctl node status

#### Kubeconfig 및 API 서버 확인
                kubectl cluster-info

#### 모든 리소스 및 상태 확인
                kubectl get all --all-namespaces

#### kubeadm-config ConfigMap 정보 확인
                sudo kubectl -n kube-system get cm kubeadm-config -o yaml

#### 참고:
                kubectl: Kubernetes 클러스터와 상호 작용하기 위한 명령행 도구
                calicoctl: Calico 네트워크 플러그인과 상호 작용하기 위한 명령행 도구
                kubeadm, kubelet, kubectl: Kubernetes 설치 및 관리를 위한 도구
