export PATH=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/lib
export TMPDIR=$HOME/buster-fast-bench/droid-zen5/tmp
export EXCLUSIVE_OWNER=droid-zen5 EXCLUSIVE_TITLE="Droid: Zen 5 AVX-512 kernel optimization (#1039)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/1039"
mkdir -p "$TMPDIR"
lock=$HOME/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
shifts="0 704 1344 2048 2688 3392"
