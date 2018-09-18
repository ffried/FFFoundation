#!/bin/sh

if [ "$#" -ne "1" ]; then
	echo "Missing argument [swift_version]"
	exit 1
fi

SWIFT_VERSION="$1"
CONTAINER_TAG="swift:$SWIFT_VERSION"
CONTAINER_NAME="FFFoundationTests_Linux"
VOLUME_SRC="$(pwd)"
VOLUME_TARGET="/FFFoundation"

docker run \
	--mount src="$VOLUME_SRC",target="$VOLUME_TARGET",type=bind \
	--name "$CONTAINER_NAME" \
	--rm \
	"$CONTAINER_TAG" \
	bash -c "cd $VOLUME_TARGET && swift test"
