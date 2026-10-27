#!/usr/bin/env bash
# #509's follow-up: the head's code sits 0x58c0 bytes after main's (2,240 mod 4,096), which none of the encoder unit's
# six shifts give main, and the head ran benchmark-x86-encoder 2.2% slower at all six with the same instructions. Main's
# encoder unit linked 2,240 bytes later and the head's 1,856 (4,096 - 2,240) give each the other's offset in its page,
# for the unit and what follows it, though not for .rodata, which precedes .text. Then the same comparison, placements
# paired by that offset: main at 0 against the head at 1,856, and main at 2,240 against the head at 0; main again at
# its own two. Waits for queue.sh first.
set -u
here="$HOME/buster-fast-bench/placements-509"
cd "$here"
while pgrep -f '^bash ./queue.sh$' > /dev/null; do sleep 20; done
export EXCLUSIVE_OWNER=claude-509-placements
export EXCLUSIVE_TITLE="#509: compare builds over code placements and copies (Claude Code)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/509
lock="$HOME/buster-fast-bench/exclusive.sh"
r=results
(cd main-e04462c1 && BUSTER_DEBUG_INFO=0 "$lock" bash ../head-b36288b5/build.sh shifts ../bin/main-e04462c1-encoder2 x86_64_encoder_benchmark.c 2240) > $r/build2-main.txt 2>&1 || { echo "build main failed"; exit 1; }
(cd head-b36288b5 && BUSTER_DEBUG_INFO=0 "$lock" bash ../head-b36288b5/build.sh shifts ../bin/head-b36288b5-encoder2 x86_64_encoder_benchmark.c 1856) > $r/build2-head.txt 2>&1 || { echo "build head failed"; exit 1; }
sha256sum bin/*-encoder2/* > $r/sha256-2.txt
tool="$here/bin/head-b36288b5-checker/compiler-0"
m="$here/bin/main-e04462c1-encoder"
h="$here/bin/head-b36288b5-encoder"
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 5 --copies 3 \
    --build main "$m/compiler-0" --build main "${m}2/compiler-2240" \
    --build head "${h}2/compiler-1856" --build head "$h/compiler-0" \
    --build main-again "$m/compiler-0" --build main-again "${m}2/compiler-2240" \
    --list benchmark-x86-encoder --only x86_encode_16 > $r/encoder-offsets.txt 2>&1
echo done > $r/queue2.done
