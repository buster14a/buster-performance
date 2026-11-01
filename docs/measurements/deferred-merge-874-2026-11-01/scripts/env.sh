# #874 verification: deferred merge's cold huge pages. Common settings.
D=/home/david/buster-fast-bench/874-verify
export EXCLUSIVE_OWNER=874-verify
export EXCLUSIVE_TITLE="#874 deferred merge cold huge pages (Claude Code session)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/874"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
unit_file()
{
    case "$1" in
        sqlite) echo "$corpus/sqlite/sqlite3.c" ;;
        00*) echo "$D/inputs/c-testsuite/$1.c" ;;
        *) echo "$D/inputs/synthetic/$1.c" ;;
    esac
}
