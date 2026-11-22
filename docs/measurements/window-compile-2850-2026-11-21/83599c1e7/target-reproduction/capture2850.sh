#!/bin/bash
set -u
stdout=$1
stderr=$2
shift 2
exec "$@" >"$stdout" 2>"$stderr"
