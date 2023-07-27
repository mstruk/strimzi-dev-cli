Strimzi development environment Docker image
============================================

This image contains all the dependencies required to build Strimzi Kafka Operator project, and deploy it to Kubernetes server of your choice.
The image only supports linux/amd64 architecture. If you are on a different architecture emulated mode may work for you by adding a docker option `--platform linux/amd64`.

Building
--------

docker build . --tag strimzi/strimzi-dev-cli


Using
-----

docker run -ti -name strimzi-dev-cli strimzi/strimzi-dev-cli:latest /bin/sh


