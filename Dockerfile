FROM centos:7

RUN yum update -y \
  && yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.4.3-3.1.el7.x86_64.rpm \
  && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y which java-11-openjdk-devel make git unzip ruby yum-utils device-mapper-persistent-data lvm2 openssl docker-ce \
  && alternatives --set java java-11-openjdk.x86_64 \
  && gem install asciidoctor \
  && echo "export JAVA_HOME=/etc/alternatives/java_sdk_openjdk" >> /root/.bash_profile \
  && echo "Build 2021-03-16T14:45:00" > /root/VERSION
RUN echo $'[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64\n\
enabled=1\n\
gpgcheck=1\n\
repo_gpgcheck=1\n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'\
  >> /etc/yum.repos.d/kubernetes.repo \
  && yum install -y kubectl
RUN curl -Lo yq "https://github.com/mikefarah/yq/releases/download/v4.6.1/yq_linux_amd64" \
  && mv yq /usr/local/bin/yq \
  && echo "a339079fadf5e01d69067349b67db695db1a4f5046281713e35d9b6ca790b499 /usr/local/bin/yq" | sha256sum -c - \
  && chmod +x /usr/local/bin/yq
RUN curl -Lo kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.10.0/kind-linux-amd64" \
  && mv kind /usr/local/bin/kind \
  && echo "74767776488508d847b0bb941212c1cb76ace90d9439f4dee256d8a04f1309c6 /usr/local/bin/kind" | sha256sum -c - \
  && chmod +x /usr/local/bin/kind
RUN curl -LO "https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz" \
  && echo "01b317c506f8b6ad60b11b1dc3f093276bb703281cb1ae01132752253ec706a2 helm-v3.5.2-linux-amd64.tar.gz" | sha256sum -c - \
  && tar -zxvf helm-v3.5.2-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64 helm-v3.5.2-linux-amd64.tar.gz
RUN curl -LO "https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz" \
  && echo "26ad91d751b3a9a53087aefa743f4e16a17741d3915b219cf74112bf87a438c5 apache-maven-3.6.3-bin.tar.gz" | sha256sum -c - \
  && cd /opt \
  && tar -zxvf /apache-maven-3.6.3-bin.tar.gz \
  && ln -s -t /usr/local/bin /opt/apache-maven-3.6.3/bin/{mvn,mvnDebug} \
  && cd / && rm apache-maven-3.6.3-bin.tar.gz
ENV PS1="strimzi-cli:\W\\$ " 
