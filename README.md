Strimzi development environment Docker image
============================================

This image contains all the dependencies required to build Strimzi Kafka Operator project, and deploy it to Kubernetes server of your choice.

Building
--------

docker --tag strimzi/strimzi-dev-cli build .


Using
-----

docker run --rm -ti -name strimzi-dev-cli strimzi/strimzi-dev-cli:latest /bin/sh


