#!/bin/bash

# Add GPG key for Kubernetes
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg

# Set up the Kubernetes apt repository
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

# 1. 기본 설치 (Master & Worker 공통)
# 도커 설치
sudo apt update
sudo apt install -y docker.io

# Installing kubeadm, kubelet and kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 자동실행 설정 – 시스템 재부팅 시 자동실행되도록 설정
sudo systemctl enable docker kubelet

# 2. Master 설정
# 클러스터 생성
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# kubectl (권한) 설정
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# kubectl get all —all-namespaces 한 번 쳐보기
sudo kubectl get nodes # 아직 NotReady

# 3. Cluster에 network 배포 (Calico Pod Network)
# Calico 설치
sudo curl https://docs.projectcalico.org/archive/v3.17/manifests/calico.yaml -O
sudo kubectl apply -f calico.yaml
#########################################################################################
### 특정 부분 에러나면 ###
# sudo vim calico.yaml
#---
# This manifest creates a Pod Disruption Budget for Controller to allow K8s Cluster Autoscaler to evict
#
#apiVersion: policy/v1beta1
#kind: PodDisruptionBudget
#metadata:
#  name: calico-kube-controllers
#  namespace: kube-system
#  labels:
#    k8s-app: calico-kube-controllers
#spec:
#  maxUnavailable: 1
#  selector:
#    matchLabels:
#      k8s-app: calico-kube-controllers
#---
#

# 주석 후 계속 진행
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
