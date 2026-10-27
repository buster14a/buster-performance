#!/usr/bin/env bash
# #509's campaign on the 9700X. Builds main (e04462c1) and the head (b36288b5) with the head's build.sh (the same
# sources; main's lacks `shifts`), each linked at six shifts of the checker's unit and six of the encoder benchmark's,
# every build under the lock alone, without -g as the 9700X job builds. Then, each time-runs process under the lock
# alone and pinned to CPU 2 by ab: -fsyntax-only of the frozen sqlite3.c and benchmark-x86-encoder --only
# x86_encode_16 by three builds, main, the head and main again (main's executables, other copies), at their six
# placements from three fresh copies each, three rounds; and the old way, one executable of each tree at shift 0, no
# copies, 11 runs, three rounds.
set -u
here="$HOME/buster-fast-bench/placements-509"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
export EXCLUSIVE_OWNER=claude-509-placements
export EXCLUSIVE_TITLE="#509: compare builds over code placements and copies (Claude Code)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/509
lock="$HOME/buster-fast-bench/exclusive.sh"
r=results
checker=(0 16 48 128 512 2048)
encoder=(0 64 192 512 1024 2048)
mkdir -p bin
for tree in main-e04462c1 head-b36288b5; do
    if [ ! -x "bin/$tree-encoder/compiler-2048" ]; then
        (cd $tree && BUSTER_DEBUG_INFO=0 "$lock" bash ../head-b36288b5/build.sh shifts "../bin/$tree-checker" main_unit_checker.c "${checker[@]}") > $r/build-$tree-checker.txt 2>&1 || { echo "build $tree checker failed"; exit 1; }
        (cd $tree && BUSTER_DEBUG_INFO=0 "$lock" bash ../head-b36288b5/build.sh shifts "../bin/$tree-encoder" x86_64_encoder_benchmark.c "${encoder[@]}") > $r/build-$tree-encoder.txt 2>&1 || { echo "build $tree encoder failed"; exit 1; }
    fi
done
sha256sum bin/*/* > $r/sha256.txt
tool="$here/bin/head-b36288b5-checker/compiler-0"
builds()
{
    local kind="$1"
    shift
    args=()
    for b in main:main-e04462c1 head:head-b36288b5 main-again:main-e04462c1; do
        for s in "$@"; do
            args+=(--build "${b%%:*}" "$here/bin/${b#*:}-$kind/compiler-$s")
        done
    done
}
builds checker "${checker[@]}"
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 3 --copies 3 "${args[@]}" --list -fsyntax-only "${sqlite[@]}" > $r/sqlite-placements.txt 2>&1
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 11 --executable "$here/bin/main-e04462c1-checker/compiler-0" --executable "$here/bin/head-b36288b5-checker/compiler-0" --list -fsyntax-only "${sqlite[@]}" > $r/sqlite-old.txt 2>&1
builds encoder "${encoder[@]}"
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 5 --copies 3 "${args[@]}" --list benchmark-x86-encoder --only x86_encode_16 > $r/encoder-placements.txt 2>&1
"$tool" ab --rounds 3 --cpu 2 --lock "$lock" "$tool" -- time-runs --runs 21 --executable "$here/bin/main-e04462c1-encoder/compiler-0" --executable "$here/bin/head-b36288b5-encoder/compiler-0" --list benchmark-x86-encoder --only x86_encode_16 > $r/encoder-old.txt 2>&1
echo done > $r/queue.done
