#!/bin/sh

if [ "$#" -ne "1" ]; then
	echo "Missing argument [destination]"
	exit 1
fi

XCODEPROJ="Xcode/FFFoundation.xcodeproj"
SCHEME="FFFoundation"
DESTINATION="$1"

set -o pipefail && \
xcodebuild \
	-project "$XCODEPROJ" \
	-scheme "$SCHEME" \
	-destination "$DESTINATION" \
	build test | \
xcpretty
