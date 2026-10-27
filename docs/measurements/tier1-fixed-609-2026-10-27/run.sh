#!/usr/bin/env bash
# Run after build.sh. One qualification benchmark, including sequential fresh-process samples; capped at 90 seconds.
set -euo pipefail
record_dir=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$record_dir/logs"
export EXCLUSIVE_OWNER=codex-609
export EXCLUSIVE_TITLE='Buster #609 fixed-register filtering'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/609
"$HOME/buster-fast-bench/exclusive.sh" bash -c 'cd "$1"; exec taskset -c 2 ./campaign' _ "$record_dir"
