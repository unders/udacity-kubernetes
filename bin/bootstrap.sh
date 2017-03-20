#!/usr/bin/env bash

command_exists () {
    type "$1" &> /dev/null ;
}

python_is_required() {
    if command_exists python; then
        return
    fi

    echo "You must install: python 2.7"
    exit 0
}

main() {
    python_is_required
    echo "Installing Google Cloud SDK"
}

main
