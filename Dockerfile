FROM centos:7

RUN yum update -y \
  yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm \
  && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y java-1.8.0-openjdk maven make ruby yum-utils device-mapper-persistent-data lvm2 openssl docker-ce \
  && gem install asciidoctor \
  && curl -L -O https://github.com/mikefarah/yq/releases/download/3.1.1/yq_linux_amd64 \
  && mv yq_linux_amd64 /usr/local/bin/yq \
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
