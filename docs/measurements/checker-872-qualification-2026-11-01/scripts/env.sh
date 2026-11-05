D=/home/david/buster-fast-bench/872-qual-20261101
export EXCLUSIVE_OWNER=opencode-872
export EXCLUSIVE_TITLE="872 checker regression qualification (OpenCode session)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/872"
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
