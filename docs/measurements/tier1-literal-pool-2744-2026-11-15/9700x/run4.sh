#!/usr/bin/env bash
# buster#2744: the rest of step 2's 9700X runs and step 3's (after run.sh's builds and harness), one lock hold per
# round of short processes, every timeout inside the hold. Rounds interleave the builds.
set -uo pipefail
D=$HOME/buster-fast-bench/2744-claude
HEAD=5e33fe81db6ca38fe2683208976177c7843dc342
export EXCLUSIVE_OWNER=claude-2744
export EXCLUSIVE_TITLE="GitHub issue #2744 (Tier 1 literal pool)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2794
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D" || exit 1
echo $$ > run4.pid
log() { echo "$(date -u +%FT%TZ) $*" >> "$D/run4.log"; }
log "start"
R=$(ls -d rows/measure-tier1-rows-* | head -1)
# Step 3's compiler: the patch on step 2's head, built in one hold.
[ -d head3 ] || git -C repo worktree add -q --detach "$D/head3" $HEAD >> run4.log 2>&1
if [ ! -f head3/.patched ]; then
    git -C head3 apply "$D/step3.patch" >> run4.log 2>&1 && touch head3/.patched
fi
[ -f head3/.patched ] || { log "patch failed"; exit 1; }
if [ ! -x results/compiler-head3 ]; then
    (cd head3 && "$X" env BUSTER_DEBUG_INFO=0 timeout 3600 ./build.sh --config Release > "$D/build-head3.log" 2>&1)
    log "build head3 status $? $(tail -1 build-head3.log)"
    [ -x head3/build/compiler ] && cp head3/build/compiler results/compiler-head3
fi
[ -x results/compiler-head3 ] || { log "no head3 compiler"; exit 1; }
# The lexer programs by one command each (the harness's mains), step 2's head and step 3's, then base's harness build.
FLAGS="--tier1 -fno-asynchronous-unwind-tables -march=native -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing -c $D/head/src/buster/compiler/c_lexer_benchmark.c"
for side in head head3; do
    "$X" timeout 900 results/compiler-$side $FLAGS -o "$D/results/lexer-$side.o" > "$D/results/lexer-$side.report" 2>&1
    log "lexer $side object status $?"
    clang -o "$D/results/lexer-$side" "$D/$R/lexer-main.o" "$D/results/lexer-$side.o" >> run4.log 2>&1
done
cp $R/lexer-base $R/lexer-tier1 $R/lexer-clang2 results/
sha256sum results/lexer-* results/compiler-head3 > results/programs4.sha256 2>&1
# The Zen 5 rows step 3 adds, one hold.
(cd head3 && "$X" timeout 900 taskset -c 2 "$D/results/compiler-head3" measure-x86-zen5 --missing --table > "$D/results/zen5-table.txt" 2> "$D/results/zen5-table.err")
log "zen5 table status $? $(wc -l < results/zen5-table.txt) lines"
grep -n 'VPBROADCAST[DQ]_[XYZ]_XM\(32\|64\), MEMORY' results/zen5-table.txt >> run4.log
# Five rounds, one hold each: every program on the file and on src, pinned to CPU 2, in a rotated order.
cat > round.sh <<'ROUND'
#!/usr/bin/env bash
D=$1; round=$2; shift 2
for input in mid src; do
    target=$D/mid.c; [ $input = src ] && target=$D/head/src
    for program in "$@"; do
        timeout 300 taskset -c 2 "$D/results/$program" "$target" > "$D/results/r$round-$program-$input.log" 2>&1
        echo "$program $input $round status $? $(grep 'c_tokenize ' "$D/results/r$round-$program-$input.log" | tr -s ' ')"
    done
done
ROUND
chmod +x round.sh
programs=(lexer-base lexer-tier1 lexer-head lexer-head3 lexer-clang2)
for round in 1 2 3 4 5; do
    k=$((round % ${#programs[@]}))
    order=("${programs[@]:$k}" "${programs[@]:0:$k}")
    "$X" ./round.sh "$D" $round "${order[@]}" >> run4.log 2>&1
    log "round $round status $?"
done
for input in mid src; do
    for program in lexer-tier1 lexer-head lexer-head3; do
        grep -v ' ms \|exclusive.sh\|title:\|link:\|held by' results/r1-$program-$input.log > cmp-$program.txt
    done
    cmp -s cmp-lexer-tier1.txt cmp-lexer-head3.txt && cmp -s cmp-lexer-tier1.txt cmp-lexer-head.txt && log "outputs agree ($input)" || log "OUTPUTS DIFFER ($input)"
done
# Whole-driver compile time, time-runs under ab (one hold a round): base, head and base again, three copies each.
B="--build base $D/results/compiler-base --build head $D/results/compiler-head --build base-again $D/results/compiler-base"
LEXER="--tier1 -fno-asynchronous-unwind-tables -march=znver5 -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing -c $D/head/src/buster/compiler/c_lexer_benchmark.c -o $D/out-lexer.o"
C=$D/corpus
SQLITE="--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include -c $C/sqlite/sqlite3.c -o $D/out-sqlite.o"
# The drive check, in one hold: each command's status by each compiler.
cat > drive.sh <<'DRIVE'
#!/usr/bin/env bash
D=$1; shift
for side in base head; do
    for list in lexer sqlite sqlite-tier1; do
        case $list in lexer) args=$LEXER ;; sqlite) args=$SQLITE ;; *) args="--tier1 $SQLITE" ;; esac
        timeout 600 "$D/results/compiler-$side" $args > /dev/null 2>&1
        echo "drive check $side $list status $?"
    done
done
DRIVE
chmod +x drive.sh
LEXER=$LEXER SQLITE=$SQLITE "$X" ./drive.sh "$D" >> run4.log 2>&1
results/compiler-head ab --rounds 3 --cpu 2 --lock "$X" "$D/results/compiler-head" -- time-runs --runs 3 --copies 3 $B --list $LEXER > results/ab-lexer.log 2>&1
log "ab lexer status $?"
results/compiler-head ab --rounds 3 --cpu 2 --lock "$X" "$D/results/compiler-head" -- time-runs --runs 3 --copies 3 $B --list $SQLITE > results/ab-sqlite.log 2>&1
log "ab sqlite tier0 status $?"
results/compiler-head ab --rounds 3 --cpu 2 --lock "$X" "$D/results/compiler-head" -- time-runs --runs 2 --copies 2 $B --list --tier1 $SQLITE > results/ab-sqlite-tier1.log 2>&1
log "ab sqlite tier1 status $?"
{ uname -r; grep -m1 'model name' /proc/cpuinfo; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null; } > results/host.txt 2>&1
rm -rf base/build head/build head3/build
log "done"
touch run4.done
