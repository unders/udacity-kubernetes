#!/usr/bin/env bash

command_exists () {
    type "$1" &> /dev/null ;
}

docker_is_required() {
    if command_exists docker; then
        return
    fi

    echo ""
    echo "You must install Docker:"
    echo "    https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac"
    echo ""
    exit 0
}

python_is_required() {
    if command_exists python; then
        return
    fi

    echo "You must install: python 2.7"
    exit 0
}

is_sdk_installed() {
    if command_exists gcloud; then
        gcloud components update
        gcloud components install kubectl
        exit 0
    fi
}

main() {
    docker_is_required
    python_is_required
    is_sdk_installed
    echo ""
    echo "Install Google Cloud Platform SDK:"
    echo "   https://cloud.google.com/sdk/docs/quickstart-mac-os-x"
    echo ""
}

main
