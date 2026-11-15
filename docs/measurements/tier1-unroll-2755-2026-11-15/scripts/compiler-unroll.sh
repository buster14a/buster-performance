#!/bin/sh
# The compiler with --tier1-passes=+unroll wherever the command has --tier1.
for argument in "$@"; do
    if [ "$argument" = "--tier1" ]; then
        exec /home/user/buster/build/compiler "$@" --tier1-passes=+unroll
    fi
done
exec /home/user/buster/build/compiler "$@"
