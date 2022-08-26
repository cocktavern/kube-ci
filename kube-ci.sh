#!bin/bash

# ENVS:
    # GIT_DESTINATION
    # GIT_REPO
    # KUBE_MANIFEST_PATH

cd $GIT_DESTINATION
APPLY_PATH=$(pwd)/${GIT_DESTINATION}

git clone $GIT_REPO

while true;
do
echo -n "Applying ${APPLY_PATH}";
date;

kubectl apply -k ${APPLY_PATH}

sleep 60;
done
