FROM centos:7

RUN yum update -y \
  && yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.4.3-3.1.el7.x86_64.rpm \
  && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y which make git unzip ruby yum-utils device-mapper-persistent-data lvm2 openssl docker-ce \
  && gem install asciidoctor \
  && echo "echo \"You may want to run \'yum update -y\' to update the system packages\"" >> /root/.bash_profile \
  && echo "Build 2023-07-27T15:25:00" > /root/VERSION
RUN curl -LO https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz \
  && echo "aa5fc7d388fe544e5d85902e68399d5299e931f9b280d358a3cbee218d6017b0 OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz" | sha256sum -c - \
  && tar -xvf OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz \
  && rm -f OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz \
  && mv jdk-17.* /opt/jdk-17 \
  && echo "export JAVA_HOME=/opt/jdk-17" >> /root/.bash_profile \
  && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /root/.bash_profile \
  && alternatives --install /usr/bin/java java /opt/jdk-17/bin/java 1
RUN echo $'[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64\n\
enabled=1\n\
gpgcheck=1\n\
repo_gpgcheck=1\n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'\
  >> /etc/yum.repos.d/kubernetes.repo \
  && yum install -y kubectl
RUN curl -Lo yq "https://github.com/mikefarah/yq/releases/download/v4.34.2/yq_linux_amd64" \
  && mv yq /usr/local/bin/yq \
  && echo "1952f93323e871700325a70610d2b33bafae5fe68e6eb4aec0621214f39a4c1e /usr/local/bin/yq" | sha256sum -c - \
  && chmod +x /usr/local/bin/yq
RUN curl -Lo kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-amd64" \
  && mv kind /usr/local/bin/kind \
  && echo "513a7213d6d3332dd9ef27c24dab35e5ef10a04fa27274fe1c14d8a246493ded /usr/local/bin/kind" | sha256sum -c - \
  && chmod +x /usr/local/bin/kind
RUN curl -LO "https://get.helm.sh/helm-v3.12.2-linux-amd64.tar.gz" \
  && echo "2b6efaa009891d3703869f4be80ab86faa33fa83d9d5ff2f6492a8aebe97b219 helm-v3.12.2-linux-amd64.tar.gz" | sha256sum -c - \
  && tar -zxvf helm-v3.12.2-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64 helm-v3.12.2-linux-amd64.tar.gz
RUN curl -LO "https://downloads.apache.org/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.tar.gz" \
  && echo "e1e13ac0c42f3b64d900c57ffc652ecef682b8255d7d354efbbb4f62519da4f1 apache-maven-3.9.3-bin.tar.gz" | sha256sum -c - \
  && cd /opt \
  && tar -zxvf /apache-maven-3.9.3-bin.tar.gz \
  && ln -s -t /usr/local/bin /opt/apache-maven-3.9.3/bin/{mvn,mvnDebug} \
  && cd / && rm -f apache-maven-3.9.3-bin.tar.gz
RUN curl -LO "https://github.com/koalaman/shellcheck/releases/download/v0.9.0/shellcheck-v0.9.0.linux.x86_64.tar.xz" \
  && tar xvf shellcheck-v0.9.0.linux.x86_64.tar.xz \
  && mv shellcheck-v0.9.0/shellcheck /usr/local/bin/shellcheck \
  && echo "7087178d54de6652b404c306233264463cb9e7a9afeb259bb663cc4dbfd64149 /usr/local/bin/shellcheck" | sha256sum -c - \
  && rm -rf shellcheck-v0.9.0 shellcheck-v0.9.0.linux.x86_64.tar.xz
ENV PS1="strimzi-cli:\W\\$ " 
