export GIT_REPO=git@github.com:cocktavern/kubernetes.git
export GIT_DESTINATION=/workspace
export KUBE_MANIFEST_PATH=kubernetes/dev-raspberry
export GIT_SSH_FOLDER=/git-ssh
export GPG_PRIVATE_KEY_PATH=/repo/private.key
export GPG_PASSPHRASE=my-passprhase

docker run -it \
    --env GIT_REPO=$GIT_REPO \
    --env GIT_DESTINATION=$GIT_DESTINATION \
    --env KUBE_MANIFEST_PATH=$KUBE_MANIFEST_PATH \
    --env GIT_SSH_FOLDER=$GIT_SSH_FOLDER \
    --env GPG_PRIVATE_KEY_PATH=$GPG_PRIVATE_KEY_PATH \
    --env GPG_PASSPHRASE=$GPG_PASSPHRASE \
    --volume $(pwd):/repo \
    --volume $(echo $HOME)/.ssh:/git-ssh docker.io/cocktavern/kube-ci:local /bin/sh
