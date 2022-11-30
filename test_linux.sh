#!/bin/bash

docker run --rm \
    --volume "$(pwd):/package" \
    --workdir "/package" \
    swift:5.7.1 \
    /bin/bash -c \
    "swift package resolve && swift test --build-path ./.build/linux"
