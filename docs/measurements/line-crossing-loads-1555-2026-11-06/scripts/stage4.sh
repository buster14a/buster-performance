#!/bin/bash
# The lexer variants in one process: control (main c_lexer.c) and k1 (the head), built into main tree, then checked
# and timed against c_tokenize on the frozen sqlite3.c, the C library corpus and the repository src. CPU 2.
cd ~/buster-fast-bench/1555-claude/main
env BUSTER_HOST_ARCH=znver5 ./build.sh lexer-variant control=src/buster/compiler/c_lexer.c k1=src/buster/compiler/c_lexer_k1_1555.c > ../stage4-build-variant.log 2>&1 || { echo "variant build FAILED"; tail -20 ../stage4-build-variant.log; exit 1; }
cp build/compiler ../run/bin/compiler-lexvariants && sha256sum ../run/bin/compiler-lexvariants
cd ~/buster-fast-bench/1555-claude
for corpus in run/corpus/sqlite/sqlite3.c ~/azp-bench/c-tokenizer/corpus/libc main/src; do
    echo "== $corpus"
    taskset -c 2 run/bin/compiler-lexvariants benchmark-lexer $corpus 2>&1 | tail -14
    echo "== $corpus --no-digit-separators"
    taskset -c 2 run/bin/compiler-lexvariants benchmark-lexer --no-digit-separators $corpus 2>&1 | tail -14
done
echo stage4-done
