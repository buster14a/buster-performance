# The 9700X job's toolchain (tools/ci/setup-benchpress.sh's staged official LLVM 23.1.4) and settings.
staged=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH=$staged/bin:$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2/bin:/usr/local/bin:/usr/bin:/bin
export BUSTER_CLANG_RESOURCE_DIR=$staged/lib/clang/23
export LD_LIBRARY_PATH=$staged/lib
export BUSTER_HOST_ARCH=znver5
export LC_ALL=C
export TMPDIR=/home/david/buster-fast-bench/2559-step5b-claude/tmp
