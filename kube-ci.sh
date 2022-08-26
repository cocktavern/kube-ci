#!bin/bash
set -euxo pipefail

# ENVS:
# GIT_DESTINATION
# GIT_REPO
# KUBE_MANIFEST_PATH
# GIT_SSH_FOLDER

## 1. Prepare Credentials
mkdir -p /root/.ssh
cp -R $GIT_SSH_FOLDER /root/.ssh
ssh-keyscan -H github.com >> /root/.ssh/known_hosts

## 2. Clone repo
mkdir -p $GIT_DESTINATION
cd $GIT_DESTINATION
git clone $GIT_REPO


## 3. Pull and apply loop
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
