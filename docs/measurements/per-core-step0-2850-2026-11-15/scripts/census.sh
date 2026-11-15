#!/bin/bash
# usage: ./census.sh [DUMPS] ; builds tools/census.c (which includes tools/sweeps.c, the one-core record's prototype,
# unchanged) and counts what each of the sweeps' answers depends on, over that record's two dumps in DUMPS (default
# scratch/: sqlite3.dump and musl.dump, whose hashes its raw/sweeps/dump-sizes.txt gives): each corpus alone, and the
# two as one population. It is a count, so it needs neither the 9700X nor its lock. Results in ../results/census.
set -euo pipefail
cd "$(dirname "$0")"
dumps=${1:-scratch}
out=../results/census
mkdir -p "$out" build
clang -O3 -march=native -Wall -Wextra -Wno-unused-function -o build/census tools/census.c 2> "$out/census-build.log"
{
    sha256sum tools/sweeps.c tools/census.c
    (cd "$dumps" && sha256sum sqlite3.dump musl.dump)
    clang --version | head -1
    echo "host: $(uname -srm); $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')"
} > "$out/census-hashes.txt"
(cd "$dumps" && "$OLDPWD/build/census" sqlite3.dump --rows) > "$out/census-sqlite3.txt"
(cd "$dumps" && "$OLDPWD/build/census" musl.dump --rows) > "$out/census-musl.txt"
(cd "$dumps" && "$OLDPWD/build/census" sqlite3.dump musl.dump --rows) > "$out/census-both.txt"
echo done > "$out/census.done"
