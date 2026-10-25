# The frozen inputs of #117's 2026-10-23 acceptance (preprocessor-corpora-astra-01a158dd).
bundle=/home/david/buster-fast-bench/preprocessor-corpora-astra-01a158dd
system=(-target x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
    -isystem "$bundle/headers/usr/lib/clang/23/include"
    -isystem "$bundle/headers/usr/local/include"
    -isystem "$bundle/headers/usr/include")
sqlite=("${system[@]}" "$bundle/sqlite/sqlite3.c")
# main.c of a frozen tree, with the system's headers (the bundle lacks linux/memfd.h), as the 9700X job's smoke command
# preprocesses it.
frozen=/home/david/buster-fast-bench/codex-117-01a16812/base-635434f2
mainc=(-march=native -std=gnu17 -I "$frozen/src" -fwrapv -funsigned-char "$frozen/src/buster/compiler/main.c")
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
