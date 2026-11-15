#!/bin/sh
exec /usr/bin/clang-23 -fstack-protector-strong "$@"
