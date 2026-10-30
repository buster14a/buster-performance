#!/usr/bin/env bash
set -euo pipefail
task=/home/david/Documents/Codex/2026-10-30/tak-3/work
tool="$task/perf-unwind-914"
campaign="$task/pr914-acceptance"
revision="$1"
run="$2"
binary="$campaign/bin/$revision/compiler"
id=$(readelf -n "$binary" | awk '/Build ID/{print substr($3,1,40)}')
mkdir -p "$tool/safe" "$tool/symfs/.debug/.build-id/${id:0:2}/${id:2}" "$tool/symfs/home/david/buster-fast-bench/codex-pr914-acceptance-20261030/$revision"
ln -sfn "$binary" "$tool/symfs/.debug/.build-id/${id:0:2}/${id:2}/elf"
ln -sfn "$binary" "$tool/symfs/home/david/buster-fast-bench/codex-pr914-acceptance-20261030/$revision/compiler"
input="$campaign/raw/$revision-safe-p$run.perf.data"
prefix="$tool/safe/$revision-safe-p$run"
perf script -G --no-inline --comms compiler -F comm,pid,tid,period,event,ip,sym,dso --symfs "$tool/symfs" -i "$input" > "$prefix.primary.txt" 2> "$prefix.primary.stderr"
LD_PRELOAD="$tool/reuse_exec.so" perf script --no-inline --comms compiler -F comm,pid,tid,period,event,ip,sym,dso --symfs "$tool/symfs" -i "$input" > "$prefix.chains.txt" 2> "$prefix.chains.stderr"
test ! -s "$prefix.primary.stderr"
test ! -s "$prefix.chains.stderr"
"$tool/attribution914" "$input" "$binary" "$campaign/runtime-9700x/libc.so.6" "$prefix.primary.txt" "$prefix.chains.txt" "$prefix.proof.csv" > "$prefix.summary.json" 2> "$prefix.reader.stderr"
test ! -s "$prefix.reader.stderr"
processes=$(awk '{print $2}' "$prefix.primary.txt" | sort -u | wc -l)
test "$processes" = 30
printf '%s-p%s processes=%s ' "$revision" "$run" "$processes"
cat "$prefix.summary.json"
