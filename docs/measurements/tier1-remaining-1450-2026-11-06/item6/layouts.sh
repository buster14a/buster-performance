#!/bin/bash
# #1450 item 6, phase C: -fstack-clash-protection over relative code layouts (docs/commands/profiling.md's protocol).
# Lua 5.4.8's 33 units compiled once per build by the item's compiler (fix, fcbc25d1): t0 (Tier 0), t0p (Tier 0 with the
# option), t1 (--tier1 -fno-asynchronous-unwind-tables) and t1p (t1's and the option). Each build's fixed objects linked
# by clang in 16 recorded orders, the same for every build: order 0 the normal one, 1 to 15 shuffled with a fixed seed
# before any timing. Every executable's closures.lua output must be clang -O0's. Then one time-runs over all 64, the
# builds' placements in the same order, 9 runs after a warm-up, pinned to CPU 2. Each step is one hold of the lock.
set -u
W=~/buster-fast-bench/1450-claude/item6
C=$W/fix/build/compiler
L="env EXCLUSIVE_OWNER=claude-1450 EXCLUSIVE_TITLE=GitHub_issue_1450 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1450 $HOME/buster-fast-bench/exclusive.sh"
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
O=$W/layouts
mkdir -p $O && cd $O
log() { echo "$(date -u +%FT%TZ) $*" >> $O/steps.log; }
UNITS="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
python3 -I -c '
import random, sys
units = sys.argv[1].split()
rng = random.Random(1450)
print(" ".join(units))
for k in range(15):
    order = units[:]
    rng.shuffle(order)
    print(" ".join(order))
' "$UNITS" > orders.txt
cat > compile.sh <<'INNER'
#!/bin/bash
set -eu
C=$1; LUA=$2; O=$3; UNITS=$4
for b in t0 t0p t1 t1p; do
  case $b in
    t0) flags="" ;;
    t0p) flags="-fstack-clash-protection" ;;
    t1) flags="--tier1 -fno-asynchronous-unwind-tables" ;;
    t1p) flags="--tier1 -fno-asynchronous-unwind-tables -fstack-clash-protection" ;;
  esac
  mkdir -p $O/obj-$b
  for u in $UNITS; do $C $flags -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $O/obj-$b/$u.o $LUA/$u.c; done
done
INNER
chmod +x compile.sh
$L ./compile.sh $C $LUA $O "$UNITS" > compile.log 2>&1; log "compile exit $?"
sha256sum obj-*/*.o > objects.txt
cat > link.sh <<'INNER'
#!/bin/bash
set -eu
O=$1
k=0
while read -r order; do
  for b in t0 t0p t1 t1p; do
    objs=""; for u in $order; do objs="$objs $O/obj-$b/$u.o"; done
    clang -o $O/lua-$b-$k $objs -lm -ldl
  done
  k=$((k + 1))
done < $O/orders.txt
INNER
chmod +x link.sh
$L ./link.sh $O > link.log 2>&1; log "link exit $?"
sha256sum lua-t* > executables.txt
cp ~/buster-fast-bench/1450-claude/item6/lua/closures.lua ~/buster-fast-bench/1450-claude/item6/lua/closures-clang0.out .
$L bash -c "cd $O && for e in lua-t*-*; do ./\$e closures.lua > out.tmp 2>&1; cmp -s out.tmp closures-clang0.out && echo \"\$e same\" || echo \"\$e differs\"; done; rm -f out.tmp" > compare.txt 2>&1
log "compare $(grep -c same compare.txt) same, $(grep -c differs compare.txt) differ"
args=""
for k in $(seq 0 15); do for b in t0 t0p t1 t1p; do args="$args --build $b $O/lua-$b-$k"; done; done
$L bash -c "cd $O && taskset -c 2 $C time-runs --runs 9 --warmups 1 $args --list closures.lua" > time-runs.txt 2>&1; log "time-runs exit $?"
echo done > $O/layouts.done
