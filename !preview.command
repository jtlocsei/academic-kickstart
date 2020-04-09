#!/bin/bash

# Change to the directory from which the script is being run
cd "$(dirname "$BASH_SOURCE")" || {
    echo "Error getting script directory" >&2
    exit 1
}

open http://localhost:1313/
hugo server -D
