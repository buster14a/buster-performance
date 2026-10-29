#!/bin/bash
# The record's identities on the 9700X: every source file of each tree (but its build/ and the scripts' logs), the
# executables and inputs, and whether a rebuild of head gives the bytes measured.
cd ~/buster-fast-bench/cc137-claude
export EXCLUSIVE_OWNER=claude-137 EXCLUSIVE_TITLE="solve #137 (record: a rebuild of the measured head)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/137
for t in main head pr2 pr3; do
    (cd $t && find . -path ./build -prune -o -type f ! -path ./build.log ! -path ./shifts.log -print | LC_ALL=C sort | xargs sha256sum) > source-$t.sha256
    echo "$t: $(wc -l < source-$t.sha256) files"
done
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
{
    sha256sum main/build/compiler head/build/compiler pr2/build/compiler pr3/build/compiler shifts/*/compiler-* $S/sqlite3.c
    uname -r
    clang --version | head -1
} > inputs.sha256
mv head/build head/build-measured
(cd head && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > rebuild.log 2>&1; tail -1 rebuild.log)
sha256sum head/build-measured/compiler head/build/compiler
cmp head/build-measured/compiler head/build/compiler && echo "rebuild: identical"
rm -rf head/build && mv head/build-measured head/build && rm -f head/rebuild.log
echo done
