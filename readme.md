目的：基于gitlab的cicd流程
环境：mac 
备注：gitlab-runner及镜像仓库部署在本地，其他在k8s

步骤
1：mac安装docker desktop开启k8s

2：部署helm
brew install kubernetes-helm
helm init

3：部署dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

//开启代理
kubectl proxy

kubectl -n kube-system get secret
kubectl -n kube-system describe secrets 从上步选择一个kubernetes.io/service-account-token类型的taken名字生成该名字的taken

用taken登陆

4：部署gitlab
helm install --name gitlab -f values.yaml stable/gitlab-ce
//让gitlab可以用域名访问
helm install --name nginx-ingress --set "rbac.create=true,controller.service.externalIPs[0]=192.168.31.87" stable/nginx-ingress
kubectl create -f ingress.yaml
/etc/hosts 追加一行my.gitlab.com

部署gitlabrunner
helm install --namespace gitlab --name gitlab-runner -f values.yaml gitlab/gitlab-runner
注意修改values.yaml中的taken值（在gitlab管理后台runner可以查到）

进入gitlab-runner的容器
gitlab-runner list
vi /Users/tony//.gitlab-runner/config.toml
[runners.docker]
volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache", "/home/john/.m2:/root/.m2"]

5：创建项目，每个项目增加变量
DOCKER_HUB_REPO 192.168.31.87:5000/k8s-ci
eureka-server
hello-world-service
hello-world-client

6：部署私有镜像仓库
docker run -d -p 5000:5000 --restart=always --name registry registry

cd /Users/tony/Documents/source/java/demo-cicd/docker-images/ali-maven-docker
docker build -t 192.168.31.87:5000/ali-maven-docker:3.5.4-jdk-8-alpine .
docker push 192.168.31.87:5000/ali-maven-docker:3.5.4-jdk-8-alpine

cd /Users/tony/Documents/source/java/demo-cicd/docker-images/kubectl
docker build -t 192.168.31.87:5000/kubectl:1.11.0 . 
docker push 192.168.31.87:5000/kubectl:1.11.0

注意修改k8s的登陆凭据（用本机的config文件替换，文件地址cd ~/.kube/）

概要流程
项目通过gitlab-runner打包成docker镜像push到私有仓库，然后从私有仓库pull通过kubectl部署到k8s。



