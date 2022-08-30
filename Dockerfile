FROM ubuntu

ARG DOCKER_PLATFORM

WORKDIR /root/

ADD . /root/

RUN apt-get update && \
    apt-get install -y git curl wget gnupg gnupg2 gnupg1 git-secret

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${DOCKER_PLATFORM}/kubectl"

RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/kubectl

CMD [ "sh", "/root/kube-ci.sh" ]
