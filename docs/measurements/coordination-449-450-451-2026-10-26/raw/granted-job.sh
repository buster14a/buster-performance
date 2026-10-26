#!/bin/bash
set -eu
quota=$1
shift
[[ ${CORES:-} =~ ^[1-9][0-9]*$ && -n ${CORES_CPUS:-} && -n ${CORES_HELD:-} ]] || exit 2
# This host has two SMT threads per physical core. Refuse a grant too small for the requested runnable-thread budget.
((CORES * 200 >= quota)) || { echo 'local validation: the shared grant is too small for this test' >&2; exit 2; }
directory=$(cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$directory/tmp"
exec systemd-run --user --scope --quiet -p "CPUQuota=$quota%" -p MemoryMax=8G taskset -c "$CORES_CPUS" env TMPDIR="$directory/tmp" BUSTER_DEBUG_INFO=0 BUSTER_LINKER="$directory/limited-wild.sh" OMP_NUM_THREADS=1 MAKEFLAGS=-j2 "$@"
