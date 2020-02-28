FROM centos:7

RUN yum update -y \
  && yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm \
  && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y java-1.8.0-openjdk maven make git unzip ruby yum-utils device-mapper-persistent-data lvm2 openssl docker-ce \
  && gem install asciidoctor
RUN echo $'[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64\n\
enabled=1\n\
gpgcheck=1\n\
repo_gpgcheck=1\n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'\
  >> /etc/yum.repos.d/kubernetes.repo \
  && yum install -y kubectl
RUN curl -Lo yq "https://github.com/mikefarah/yq/releases/download/3.2.0/yq_linux_amd64" \
  && mv yq /usr/local/bin/yq \
  && echo "c65bd70715727e3348a8993ea578aff93971e2c6ece25e9f06a7c3e56664f6ff /usr/local/bin/yq" | sha256sum -c - \
  && chmod +x /usr/local/bin/yq
RUN curl -Lo kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-linux-amd64" \
  && mv kind /usr/local/bin/kind \
  && echo "0e07d5a9d5b8bf410a1ad8a7c8c9c2ea2a4b19eda50f1c629f1afadb7c80fae7 /usr/local/bin/kind" | sha256sum -c - \
  && chmod +x /usr/local/bin/kind
RUN curl -LO "https://get.helm.sh/helm-v3.1.1-linux-amd64.tar.gz" \
  && echo "cdd7ad304e2615c583dde0ffb0cb38fc1336cd7ce8ff3b5f237434dcadb28c98  helm-v3.1.1-linux-amd64.tar.gz" | sha256sum -c - \
  && tar -zxvf helm-v3.1.1-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64 helm-v3.1.1-linux-amd64.tar.gz

