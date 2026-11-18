#!/usr/bin/env bash
# perf record -F 199 -e cpu-clock:u of `test-ssa-source --typed --tier1 00040.c` with the given compiler, its wall time,
# and its reports: samples by process (each form is a child: the one with ir_interpret's most samples is the memory form,
# the typed form's is interpreter_typed_run), by process and symbol, and by symbol.
# usage: profile-00040.sh COMPILER OUT_DIR
set -u
compiler="$1"; out="$2"
perf=/usr/lib/linux-tools/6.8.0-149-generic/perf
mkdir -p "$out"
cd /home/user/buster
/usr/bin/time -f 'wall %e user %U sys %S' -o "$out/time.txt" "$perf" record -q -e cpu-clock:u -F 199 -o "$out/perf.data" -- \
    "$compiler" test-ssa-source --typed --tier1 build/c-testsuite/tests/single-exec/00040.c > "$out/report.txt" 2>&1
"$perf" report -i "$out/perf.data" --sort pid --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' > "$out/by-form.txt"
"$perf" report -i "$out/perf.data" --sort pid,sym --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | head -200 > "$out/by-form-symbol.txt"
"$perf" report -i "$out/perf.data" --sort sym --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | head -100 > "$out/by-symbol.txt"
"$perf" report -i "$out/perf.data" --stdio --header-only 2> /dev/null | grep -E 'sample|duration' > "$out/samples.txt"
cat "$out/time.txt"
