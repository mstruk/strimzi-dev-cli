FROM fedora

RUN dnf update -y \
  && dnf install -y 'dnf-command(config-manager)' \
  && dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo \
  && dnf install -y docker-ce docker-ce-cli which make git unzip ruby yum-utils device-mapper-persistent-data lvm2 openssl java-17-devel maven helm shellcheck \
  && gem install asciidoctor \
  && echo "export JAVA_HOME=/etc/alternatives/java_sdk" >> /etc/profile \
  && echo "echo \"You may want to run 'dnf update -y' to update the system packages\"" >> /etc/profile \
  && echo "Build 2023-07-29T20:30:00" > /root/VERSION
RUN echo $'[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64\n\
enabled=1\n\
gpgcheck=1\n\
repo_gpgcheck=1\n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'\
  >> /etc/yum.repos.d/kubernetes.repo \
  && dnf install -y kubectl
RUN curl -Lo yq "https://github.com/mikefarah/yq/releases/download/v4.34.2/yq_linux_amd64" \
  && mv yq /usr/local/bin/yq \
  && echo "1952f93323e871700325a70610d2b33bafae5fe68e6eb4aec0621214f39a4c1e /usr/local/bin/yq" | sha256sum -c - \
  && chmod +x /usr/local/bin/yq
RUN curl -Lo kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-amd64" \
  && mv kind /usr/local/bin/kind \
  && echo "513a7213d6d3332dd9ef27c24dab35e5ef10a04fa27274fe1c14d8a246493ded /usr/local/bin/kind" | sha256sum -c - \
  && chmod +x /usr/local/bin/kind
ENV PS1="strimzi-cli:\W\\$ "