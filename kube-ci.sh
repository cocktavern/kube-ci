#!bin/bash

# ENVS:
    # GIT_DESTINATION
    # GIT_REPO
    # KUBE_MANIFEST_PATH

mkdir -p $GIT_DESTINATION
cd $GIT_DESTINATION

ssh-keyscan -H github.com >> /root/.ssh/known_hosts
git clone $GIT_REPO


APPLY_PATH=$(pwd)/${GIT_DESTINATION}
while true;
do
echo -n "Applying ${APPLY_PATH}";
date;

kubectl apply -k ${APPLY_PATH}

sleep 60;
done
