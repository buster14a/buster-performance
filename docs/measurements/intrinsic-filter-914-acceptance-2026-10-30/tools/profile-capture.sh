#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-acceptance-20261030"
revision="$1"
profile="$2"
mmap_buffer="${3:-default}"
mmap_arguments=()
if [ "$mmap_buffer" != default ]; then mmap_arguments=(-m "$mmap_buffer"); fi
export LC_ALL=C
unset LD_PRELOAD LD_LIBRARY_PATH
test -z "${GLIBC_TUNABLES:-}"
printf 'source=%s profile=%s fresh_processes=30 event=cycles:u period=250003 target_cpu=2 recorder_cpu=3 user_stack=4096\n' "$revision" "$profile"
printf 'recorded environment whitelist: HOME=/home/david PATH=/usr/bin:/bin LC_ALL=C LANG=C; no inherited session environment\n'
printf 'perf writer buffer per CPU: %s\n' "$mmap_buffer"
sha256sum "$revision/compiler"
# The writer runs on CPU 3. Each fresh measured compiler pins itself to CPU 2.
# Decoding is performed offline, outside this measurement interval.
env -i HOME=/home/david PATH=/usr/bin:/bin LC_ALL=C LANG=C taskset -c 3 perf record "${mmap_arguments[@]}" --no-buildid-cache -T -e cycles:u -c 250003 --call-graph dwarf,4096 --sample-cpu --period -o "results/$revision-$profile.perf.data" -- bash sqlite-once.sh "$revision" 30
sha256sum "results/$revision-$profile.perf.data" "results/$revision-sqlite.o"
