# Source from the campaign directory on Benchpress.
export LC_ALL=C
export EXCLUSIVE_OWNER=codex-1498
export EXCLUSIVE_TITLE="Measure designated initializer lookups (#1498)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/1498"
export BUSTER_HOST_ARCH=znver5
toolchain="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin"
export PATH="$toolchain:$PATH"
export CORES_TITLE="$EXCLUSIVE_TITLE" CORES_LINK="$EXCLUSIVE_LINK"
locked() {
    "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 "$@"
}
