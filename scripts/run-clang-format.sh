#!/bin/bash -ex
ROOT="$(git rev-parse --show-toplevel)"
find $ROOT/Sources/ -iname *.h -o -iname *.m | xargs clang-format -i -style=Google
find $ROOT/example-objc/example-objc/ -iname *.h -o -iname *.m | xargs clang-format -i -style=Google