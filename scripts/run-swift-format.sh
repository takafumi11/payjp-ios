#!/bin/bash -ex
ROOT="$(git rev-parse --show-toplevel)"
swiftlint autocorrect --format $ROOT --config $ROOT/.swiftlint.yml
swiftlint autocorrect --format $ROOT/example-swift/**/*.swift --config $ROOT/.swiftlint.yml
