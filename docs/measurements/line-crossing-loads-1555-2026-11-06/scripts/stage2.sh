#!/bin/bash
# The lexer head tree (znver5), then the in-process lexer variants (control and k1) in main tree, then their checks
# and benchmark, CPU 2.
set -x
cd ~/buster-fast-bench/1555-claude/lexer && env BUSTER_HOST_ARCH=znver5 ./build.sh > ../stage2-build-lexer.log 2>&1 && cp build/compiler ../run/bin/compiler-lexer && sha256sum ../run/bin/compiler-lexer
taskset -c 2 ./build/compiler test-lexer && taskset -c 2 ./build/compiler test-lexer --cplusplus && taskset -c 2 ./build/compiler test-lexer --no-digraphs --no-line-comments
cd ~/buster-fast-bench/1555-claude/main && cp ../variants/k1.c ../variants/k1-copy.c && env BUSTER_HOST_ARCH=znver5 ./build.sh lexer-variant control=src/buster/compiler/c_lexer.c k1=../variants/k1.c > ../stage2-build-variant.log 2>&1 && cp build/compiler ../run/bin/compiler-lexvariants && sha256sum ../run/bin/compiler-lexvariants
echo stage2-done
