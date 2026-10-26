#!/bin/bash
set -eu
exec /usr/bin/wild --thread-count="${CORES:-1}" "$@"
