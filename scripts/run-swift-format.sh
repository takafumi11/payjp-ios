#!/bin/bash -ex
ROOT="$(git rev-parse --show-toplevel)"
swiftlint autocorrect --format $ROOT
swiftlint autocorrect --format $ROOT/example-swift/**/*.swift
