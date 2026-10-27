#!/usr/bin/env bash
# #473 against main without and with #502's section, each executable as two fresh copies (other physical pages),
# -fsyntax-only of sqlite3.c by perf stat by turns, three rounds; then benchmark-checker-source on main and the
# section, two rounds. Every link and run takes the lock alone.
set -u
here="$HOME/buster-fast-bench/checker-placement-502"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
r=results
./locked.sh ./link.sh pr473-on-35f26f6 checker 0 "$here/bin/p-s0" >> $r/link4.txt 2>&1 || { echo "link failed"; exit 1; }
copies=()
for b in m-s0 sec-s0 p-s0 secpr-s0; do
    for c in a b; do cp bin/$b bin/$b-c$c; copies+=("$b-c$c"); done
done
sha256sum bin/m-s0* bin/sec-s0* bin/p-s0* bin/secpr-s0* > $r/sha4.txt
n=${#copies[@]}
for round in 1 2 3; do
    for ((k = 0; k < n; k += 1)); do
        b=${copies[$(((k + (round - 1) * 3) % n))]}
        ./locked.sh taskset -c 2 perf stat -r 21 -x, -e cycles:u,instructions:u "$here/bin/$b" -fsyntax-only "${sqlite[@]}" \
            > /dev/null 2> $r/stat4-$b-$round.txt
    done
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for round in 1 2; do
    for b in m-s0 sec-s0; do
        ./locked.sh taskset -c 2 "$here/bin/$b" benchmark-checker-source "${source[@]}" > $r/source4-$b-$round.txt 2>&1
    done
done
echo done > $r/queue4.done
