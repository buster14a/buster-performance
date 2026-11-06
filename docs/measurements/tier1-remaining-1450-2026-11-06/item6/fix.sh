#!/bin/bash
# #1450 item 6, phase B: the branch before (nofix) and after (fix) its change to which frames under a page touch rsp,
# both built znver5. Lua 5.4.8 by each with -fstack-clash-protection at Tier 0 and --tier1, and once without the option
# (the same bytes by both: the change is behind the option). Every build's five scripts must print clang -O0's output.
# time-runs: 11 rounds after a warm-up, 3 copies, CPU 2; and each build's counters on closures.lua over 5 rounds.
set -u
NOFIX=${1:?commit before}
FIX=${2:?commit after}
W=~/buster-fast-bench/1450-claude/item6
L="env EXCLUSIVE_OWNER=claude-1450 EXCLUSIVE_TITLE=GitHub_issue_1450 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1450 $HOME/buster-fast-bench/exclusive.sh"
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
SCRIPTS=$HOME/buster-fast-bench/claude-141-reciprocal/lua
cd $W
log() { echo "$(date -u +%FT%TZ) $*" >> $W/fix-steps.log; }
for pair in "nofix $NOFIX" "fix $FIX"; do
  set -- $pair
  if [ ! -d $1 ]; then git clone -q --shared ~/buster-fast-bench/1450-claude/a $1; fi
  (cd $1 && git fetch -q https://github.com/buster14a/buster claude/happy-albattani-bwnrfa && git checkout -q $2 && git log -1 --format=%H > ../$1.commit)
  $L bash -c "cd $W/$1 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > $W/build-$1.log 2>&1"; log "build $1 exit $?"
done
mkdir -p $W/lua && cp $SCRIPTS/*.lua $W/lua/
files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do files="$files $LUA/$f.c"; done
cc_of() {
  case $1 in
    t0) echo "$W/fix/build/compiler" ;;
    t0p-nofix) echo "$W/nofix/build/compiler -fstack-clash-protection" ;;
    t0p-fix) echo "$W/fix/build/compiler -fstack-clash-protection" ;;
    t1) echo "$W/fix/build/compiler --tier1 -fno-asynchronous-unwind-tables" ;;
    t1p-nofix) echo "$W/nofix/build/compiler --tier1 -fno-asynchronous-unwind-tables -fstack-clash-protection" ;;
    t1p-fix) echo "$W/fix/build/compiler --tier1 -fno-asynchronous-unwind-tables -fstack-clash-protection" ;;
    clang0) echo "clang -O0" ;;
  esac
}
BUILDS="t0 t0p-nofix t0p-fix t1 t1p-nofix t1p-fix"
for c in $BUILDS clang0; do
  $L bash -c "cd $W/lua && $(cc_of $c) -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$c $files -lm -ldl > build-$c.txt 2>&1"; log "lua $c exit $?"
done
$L bash -c "cd $W/lua && for s in calls tables strings arithmetic closures; do ./lua-clang0 \$s.lua > \$s-clang0.out 2>&1; for c in $BUILDS; do ./lua-\$c \$s.lua > \$s-\$c.out 2>&1; cmp -s \$s-clang0.out \$s-\$c.out && echo \"\$s \$c same\" || echo \"\$s \$c differs\"; done; done" > $W/lua/compare.txt 2>&1
log "compare $(grep -c same $W/lua/compare.txt) same, $(grep -c differs $W/lua/compare.txt) differ"
# The touches left: `or byte [rsp], 0` (80 0c 24 00) in each build's executable.
for c in $BUILDS; do echo "$c $(objdump -d --no-show-raw-insn $W/lua/lua-$c | grep -c 'orb *\$0x0,(%rsp)')"; done > $W/lua/touches.txt
E=cycles:u,instructions:u,ls_stlf,ls_bad_status2.stli_other
: > $W/lua/counters.csv
for round in 1 2 3 4 5; do
  for c in t0 t0p-nofix t0p-fix t1 t1p-nofix t1p-fix; do
    $L taskset -c 2 perf stat -x, -e $E -o $W/lua/stat-$c-$round.txt $W/lua/lua-$c $W/lua/closures.lua > /dev/null 2>&1
    grep -v '^#' $W/lua/stat-$c-$round.txt | grep -v '^$' | awk -F, -v r=$round -v c=$c '{print r","c","$3","$1}' >> $W/lua/counters.csv
  done
done
args=""
for c in $BUILDS; do args="$args --build $c $W/lua/lua-$c"; done
$L bash -c "cd $W/lua && taskset -c 2 $W/fix/build/compiler time-runs --runs 11 --warmups 1 --copies 3 --directory /tmp $args --list calls.lua --list tables.lua --list strings.lua --list arithmetic.lua --list closures.lua" > $W/lua/time-runs.txt 2>&1; log "time-runs exit $?"
echo done > $W/fix.done
