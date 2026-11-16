#!/bin/bash
# corpora.sh BINARY LABEL: the census of what reads T's record on the compiler's own source, sqlite3.c and Lua by a
# sanitizer build, each in the background; reports in LABEL-reports, outputs LABEL-<unit>.{out,err,status}
cd /home/user/buster
binary=$1; label=$2
mkdir -p /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-reports
export MSAN_SYMBOLIZER_PATH=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer ASAN_SYMBOLIZER_PATH=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer
export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer:log_path=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-reports/report"
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-reports/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-reports/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer:log_path=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-reports/report"
export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer:log_path=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-reports/report"
MAIN="-march=native -Isrc -fwrapv -funsigned-char --predefines /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/predefines.h src/buster/compiler/main.c"
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/corpus/sqlite /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/corpus/sqlite/sqlite3.c"
LUA="/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/corpus/lua/lua-5.4.8/src/*.c"
for unit in main sqlite3 lua; do
    case $unit in main) arguments=$MAIN ;; sqlite3) arguments=$SQ ;; lua) arguments=$LUA ;; esac
    ( start=$(date +%s); $binary measure-node-machine --shadow --facts-reads --passes 0 $arguments > /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-$unit.out 2> /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-$unit.err; echo "status $? wall $(( $(date +%s) - start )) s" > /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-$unit.status ) &
done
wait
echo corpora $label done > /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/msan/$label-corpora.done
