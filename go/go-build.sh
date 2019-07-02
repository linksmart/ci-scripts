#!/bin/bash

# EXAMPLES
# Build for default platforms:
# NAME=app ./go-build.sh
# Build for specific platforms:
# NAME=app PLATFORMS="linux/arm64 linux/arm" ./go-build.sh
# Build with ldflags:
# NAME=app LDFLAGS="-X main.Version=$version -X main.BuildNumber=$buildnum" ./go-build.sh

echo "Go Builder: https://github.com/linksmart/ci-scripts/blob/master/go/go-build.sh"

output_dir=bin

if [[ -z "$NAME" ]]; then
  echo "usage: NAME=app sh go-build.sh"
  exit 1
fi

if [[ -z "$PLATFORMS" ]]; then
  PLATFORMS="windows/amd64 darwin/amd64 linux/amd64 linux/amd64 linux/arm64 linux/arm"
  echo "Using default platforms: $PLATFORMS"
fi

for platform in $PLATFORMS
do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    output_name=$output_dir'/'$NAME'-'$GOOS'-'$GOARCH
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi
    echo "Building $output_name"

    go build -mod=vendor -tags="netgo -a -v" -ldflags "$LDFLAGS" -o $output_name
    if [ $? -ne 0 ]; then
        echo "An error has occurred! Aborting the script execution..."
        exit 1
    fi
done

# Adapted from: 
# https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-16-04
