#!bin/bash
set -e

# ENVS:
# GIT_DESTINATION e.g. /workspace
# GIT_REPO  e.g git@github.com:cocktavern/kubernetes.git
# KUBE_MANIFEST_PATH e.g. kubernetes/dev-raspberry
# GIT_SSH_FOLDER e.g. /git-ssh
# KUBECTL_OPTIONS e.g. "--prune --all"
# GPG_PRIVATE_KEY_PATH e.g. /volume-mount/private.key
# GPG_PASSPHRASE e.g. my-secret-01

## 1. Prepare Credentials
echo -n "------------------------------------------";
echo -n "------------------------------------------ \n";
echo -n "[ INFO ] PREPARE CREDENTIALS \n";
mkdir -p /root/.ssh
cp -a $GIT_SSH_FOLDER/. /root/.ssh
ssh-keyscan -H github.com >> /root/.ssh/known_hosts
echo -n "------------------------------------------";
echo -n "------------------------------------------ \n";

## 2. Clone repo
echo -n "------------------------------------------";
echo -n "------------------------------------------ \n";
echo -n "[ INFO ] CLONE REPO \n";
echo -n "[ INFO ] $GIT_DESTINATION \n";
mkdir -p $GIT_DESTINATION
cd $GIT_DESTINATION

APPLY_PATH=$(pwd)/${KUBE_MANIFEST_PATH}
if [ -d $APPLY_PATH ]
then
    echo -n "[ GIT ] $APPLY_PATH Already Cloned \n"
else
    echo -n "[ GIT ] $APPLY_PATH Cloning \n"
    git clone $GIT_REPO
fi

# 3. Decrypt secrets
echo -n "------------------------------------------";
echo -n "------------------------------------------ \n";
echo -n "[ GIT SECRET ] IMPORT KEY \n";
cd $APPLY_PATH
gpg --batch --yes --pinentry-mode loopback --import $GPG_PRIVATE_KEY_PATH

echo -n "[ GIT SECRET ] REVEAL SECRETS \n";
git secret reveal -p "$GPG_PASSPHRASE"
echo -n "------------------------------------------";
echo -n "------------------------------------------ \n";

## 4. Pull and apply loop
while true;
do
    echo -n "------------------------------------------";
    echo -n "------------------------------------------ \n";
    echo -n "[ INFO ] PULL AND APPLY \n";
    echo -n "[ DATE ] $(date) \n";
    echo -n "\n";
    
    echo -n "[ GIT ] Pulling latest \n";
    cd $APPLY_PATH
    pwd
    git pull
    git secret list
    git secret reveal -p "$GPG_PASSPHRASE"
    echo -n "\n";
    
    echo -n "[ K8S ] kubectl apply ${KUBECTL_OPTIONS} -k ${APPLY_PATH} \n";
    if [ ! -z "$KUBECTL_OPTIONS" ]
    then
        kubectl apply ${KUBECTL_OPTIONS} -k ${APPLY_PATH}
    else
        kubectl apply -k ${APPLY_PATH}
    fi
    echo -n "------------------------------------------";
    echo -n "------------------------------------------ \n";
    
    sleep 60;
done
