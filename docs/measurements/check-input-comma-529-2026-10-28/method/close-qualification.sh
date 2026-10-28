#!/usr/bin/env bash
# Identity/output closure and lean archive collection only; no new compilation or performance measurements.
set -euo pipefail
campaign=/home/david/buster-fast-bench/unclaimed-perf-20261028
stage=$campaign/issue-529-b8ee-clang2314
common=$campaign/integrated-e7-672-clang2314
cd "$stage"
printf '%s  %s\n' 06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e "$common/compiler-native" \
    3f162da86b82260fe26c443932cbcb0f9ea5d308641fef9eae01639edb044ec7 "$stage/head/build/compiler" > closure-expected-images.sha256
sha256sum -c closure-expected-images.sha256 > closure-images.log
(cd head && sha256sum -c ../source-SHA256SUMS) > closure-head-source.log
(cd "$common/source" && sha256sum -c "$stage/method/base-source-SHA256SUMS") > closure-base-source.log
(cd "$common" && sha256sum -c frozen-header-files.sha256) > closure-headers.log
for role in base head; do sha256sum -c "$stage/hot-$role/placements/SHA256SUMS" > "closure-$role-variants.log"; done
for round in 1 2 3; do cmp byte-controls/sql-base.o "layout-sql-$round/output.o"; done
cmp byte-controls/tiny-base-default.o layout-tiny-1/output.o
cmp byte-controls/sql-base.o time-output-sql.o
cmp byte-controls/tiny-base-default.o time-output-tiny.o
cmp byte-controls/comma-1024-base-default.o time-output-comma.o
printf 'all four stage2 and three stage1 final timing objects equal the independently gated original objects\n' > closure-outputs.log
sha256sum layout-sql-{1,2,3}/output.o layout-tiny-1/output.o > closure-output-SHA256SUMS
uname -a > closure-kernel.txt
lscpu > closure-cpu.txt
date -u +%Y-%m-%dT%H:%M:%SZ > closure-date.txt
find . -type f \( -name '*.o' -o -name '*.s' -o -name '*.exe' -o -name '*.text' -o -name '*.tar' -o -perm /111 \) -print0 > payload-files.nul
xargs -0 -r sha256sum < payload-files.nul > payload-SHA256SUMS
xargs -0 -r stat -c '%s %n' < payload-files.nul > payload-sizes.txt
find . -path ./head -prune -o -type f \( -name '*.log' -o -name '*.txt' -o -name '*.tsv' -o -name '*.json' -o -name '*.diff' \
    -o -name '*.sha256' -o -name '*SHA256*' -o -name SOURCE_COMMIT -o -name '*.out' -o -name '*.err' -o -name '*.stdout' \
    -o -name '*.stderr' -o -name '*.runtime' -o -name '*.sh' -o -name '*.c' \) -print0 > closure-text-files.nul
tar --null -T closure-text-files.nul -cf closure-text.tar
zstd -q -T1 -3 closure-text.tar -o closure-text.tar.zst
sha256sum closure-text.tar.zst > closure-text.tar.zst.sha256
