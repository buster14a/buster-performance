# Shared settings for the #3067 runs on the 9700X (sourced by the other scripts).
export EXCLUSIVE_OWNER=claude-3067
export EXCLUSIVE_TITLE='PR sweep: #3067 Tier 1 private values'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3067
W="$HOME/buster-fast-bench/3067-claude"
LOCK="$HOME/buster-fast-bench/exclusive.sh"
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
CLANG_BIN="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin"
TOOLS_BIN="$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2/bin"
MAIN=e20c6ff98e3af23012ef36d7e9578e87bb4249a4
MERGE=a3c7c1b434655b65e1a70cb291139f302cfcbaf5
DEFINE=-DBUSTER_TIER1_PRIVATE_VALUES=1
export TMPDIR="$W/tmp"
mkdir -p "$TMPDIR" "$W/bin" "$W/logs"
