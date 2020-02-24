FROM centos:7

RUN yum update -y \
  yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm \
  && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y java-1.8.0-openjdk maven make git unzip ruby yum-utils device-mapper-persistent-data lvm2 openssl docker-ce \
  && gem install asciidoctor \
  && curl -Lo yq "https://github.com/mikefarah/yq/releases/download/3.1.1/yq_linux_amd64" \
  && mv yq /usr/local/bin/yq \
  && chmod +x /usr/local/bin/yq
RUN echo $'[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64\n\
enabled=1\n\
gpgcheck=1\n\
repo_gpgcheck=1\n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'\
  >> /etc/yum.repos.d/kubernetes.repo \
  && yum install -y kubectl
RUN curl -Lo kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-linux-amd64" \
  && chmod +x kind \
  && mv kind /usr/local/bin/kind
RUN curl -LO "https://get.helm.sh/helm-v3.1.1-linux-amd64.tar.gz" \
  && tar -zxvf helm-v3.1.1-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64 helm-v3.1.1-linux-amd64.tar.gz

