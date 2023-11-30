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

# 4. 자동실행 설정 – 시스템 재부팅 시 자동실행되도록 설정
sudo systemctl enable docker kubelet

sudo kubeadm join 172.20.14.87:6443 --token pad0gy.kdo8y43bxiacp4h2 --discovery-token-ca-cert-hash sha256:46f9185a08c0d24b840b5d6deb3a87e2a9c0c0eef3385e4158052f11e69c5f55

###############################################################################################################################

# token을 잃어버린 경우 재확인
# sudo kubeadm token list

# token이 만료된 경우 재생성해 사용 (기본 24시간 후 삭제)
# sudo kubeadm token create