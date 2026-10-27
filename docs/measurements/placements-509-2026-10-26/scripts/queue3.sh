#!/usr/bin/env bash
# #509's second campaign. The first one's shifts did nothing: wild 0.10 dropped the padding, so every "placement" was
# the unshifted executable again (results/sha256.txt). Main (e04462c1) and the head (337fd15a), built with the head's
# build.sh (whose shifts keep the padding and check it), each linked at six shifts spread over a page, of the checker's
# unit and of the encoder benchmark's, every build under the lock alone, without -g as the 9700X job builds. Then, each
# time-runs process under the lock alone and pinned to CPU 2 by ab, with the head's time-runs: -fsyntax-only of the
# frozen sqlite3.c and benchmark-x86-encoder --only x86_encode_16 by main, the head and main again (main's executables,
# other copies), at their six placements from three fresh copies each, three rounds; and the old way, the unshifted
# executable of each tree, no copies, three rounds.
set -u
here="$HOME/buster-fast-bench/placements-509"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
export EXCLUSIVE_OWNER=claude-509-placements
export EXCLUSIVE_TITLE="#509: compare builds over code placements and copies (Claude Code)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/509
lock="$HOME/buster-fast-bench/exclusive.sh"
r=results2
shifts=(0 688 1376 2064 2752 3440)
head=head-337fd15a
mkdir -p bin2
for tree in main-e04462c1 $head; do
    for unit in checker:main_unit_checker.c encoder:x86_64_encoder_benchmark.c; do
        (cd $tree && BUSTER_DEBUG_INFO=0 "$lock" bash ../$head/build.sh shifts "../bin2/$tree-${unit%%:*}" "${unit#*:}" "${shifts[@]}") > $r/build-$tree-${unit%%:*}.txt 2>&1 || { echo "build $tree ${unit%%:*} failed"; exit 1; }
    done
done
sha256sum bin2/*/* > $r/sha256.txt
tool="$here/bin2/$head-checker/compiler-0"
builds()
{
    args=()
    for b in main:main-e04462c1 head:$head main-again:main-e04462c1; do
        for s in "${shifts[@]}"; do
            args+=(--build "${b%%:*}" "$here/bin2/${b#*:}-$1/compiler-$s")
        done
    done
}
builds checker
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 3 --copies 3 "${args[@]}" --list -fsyntax-only "${sqlite[@]}" > $r/sqlite-placements.txt 2>&1
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 11 --executable "$here/bin2/main-e04462c1-checker/compiler-0" --executable "$here/bin2/$head-checker/compiler-0" --list -fsyntax-only "${sqlite[@]}" > $r/sqlite-old.txt 2>&1
builds encoder
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 5 --copies 3 "${args[@]}" --list benchmark-x86-encoder --only x86_encode_16 > $r/encoder-placements.txt 2>&1
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 21 --executable "$here/bin2/main-e04462c1-encoder/compiler-0" --executable "$here/bin2/$head-encoder/compiler-0" --list benchmark-x86-encoder --only x86_encode_16 > $r/encoder-old.txt 2>&1
echo done > $r/queue3.done
