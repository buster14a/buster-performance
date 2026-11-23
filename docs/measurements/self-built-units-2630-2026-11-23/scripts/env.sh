# #2630 step 2 on the 9700X: the session's environment. build.sh stages CI's toolchain itself (benchpress-clang); the
# tools a script runs directly take the same staged clang first.
staged=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH=$staged/bin:$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2/bin:/usr/local/bin:/usr/bin:/bin
export BUSTER_CLANG_RESOURCE_DIR=$staged/lib/clang/23
export LC_ALL=C
d=$HOME/buster-fast-bench/2630-claude
