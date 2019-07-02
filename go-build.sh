#!/usr/bin/env bash

if [[ -z "$NAME" ]]; then
  echo "usage: PLATFORMS=\"windows/amd64 darwin/amd64 linux/amd64 linux/arm\" NAME=app $0"
  exit 1
fi

if [[ -z "$PLATFORMS" ]]; then
  PLATFORMS="windows/amd64 darwin/amd64 linux/amd64 linux/amd64 linux/arm"
  echo "Using default platforms: $PLATFORMS"
fi

for platform in $PLATFORMS
do
    echo "Building for $platform"
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    output_name=$NAME'-'$GOOS'-'$GOARCH
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi

    GOOS=$GOOS GOARCH=$GOARCH go build -o bin/$output_name
    if [ $? -ne 0 ]; then
        echo "An error has occurred! Aborting the script execution..."
        exit 1
    fi
done

# Adapted from: 
# https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-16-04
