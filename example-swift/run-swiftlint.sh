#!/bin/bash -ex
if which swiftlint >/dev/null; then
	swiftlint lint path example-swift/*.swift --config ../.swiftlint.yml
else
	echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi

