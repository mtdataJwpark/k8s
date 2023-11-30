# 기에서는 nodeSelector를 제거하여 어떤 노드에서든 실행될 수 있도록 설정.
# 또한 replicas 값을 2로 변경하여 두 개의 복제본을 만들어 각각의 워커 노드(worker-node-2에서도 동일하게)에서 실행될 수 있도록 했습니다.


# Source: calico/templates/calico-kube-controllers.yaml
# See https://github.com/projectcalico/kube-controllers
apiVersion: apps/v1
kind: Deployment
metadata:
  name: calico-kube-controllers
  namespace: kube-system
  labels:
    k8s-app: calico-kube-controllers
spec:
  # The controllers can have multiple active instances.
  replicas: 2 # <<---------- 여기 수정
  selector:
    matchLabels:
      k8s-app: calico-kube-controllers
  strategy:
    type: Recreate
  template:
    metadata:
      name: calico-kube-controllers
      namespace: kube-system
      labels:
        k8s-app: calico-kube-controllers
    spec:
      # Removed nodeSelector to allow running on any node.
      # nodeSelector:                           # <<---------- 여기 수정
      #   kubernetes.io/os: linux               # <<---------- 여기 수정
      tolerations:
        # Mark the pod as a critical add-on for rescheduling.
        - key: CriticalAddonsOnly
          operator: Exists
        - key: node-role.kubernetes.io/master
          effect: NoSchedule
      serviceAccountName: calico-kube-controllers
      priorityClassName: system-cluster-critical
      containers:
        - name: calico-kube-controllers
          image: docker.io/calico/kube-controllers:v3.17.6
          env:
            # Choose which controllers to run.
            - name: ENABLED_CONTROLLERS
              value: node
            - name: DATASTORE_TYPE
              value: kubernetes
          readinessProbe:
            exec:
              command:
              - /usr/bin/check-status
              - -r
