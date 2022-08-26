#!bin/bash

# ENVS:
# GIT_DESTINATION
# GIT_REPO
# KUBE_MANIFEST_PATH

mkdir -p $GIT_DESTINATION
cd $GIT_DESTINATION

ssh-keyscan -H github.com >> /root/.ssh/known_hosts
git clone $GIT_REPO


APPLY_PATH=$(pwd)/${KUBE_MANIFEST_PATH}
while true;
do
    echo -n "[ DATE ] $(date) \n";

    echo -n "[ GITHUB ] Pulling latest \n";
    git pull
    echo -n "\n";
    echo -n "\n";

    echo -n "[ K8s ] kubectl apply -k ${APPLY_PATH} \n";
    kubectl apply -k ${APPLY_PATH}
    echo -n "\n";
    echo -n "\n";

    sleep 60;
done
