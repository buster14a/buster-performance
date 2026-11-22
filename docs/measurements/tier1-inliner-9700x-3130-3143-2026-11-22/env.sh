# Shared settings for the #3130/#3143 runs on the 9700X (sourced by the other scripts).
export EXCLUSIVE_OWNER=claude-3130
export EXCLUSIVE_TITLE='PR sweep: #3130/#3143 Tier 1 inliner'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3130
W="$HOME/buster-fast-bench/3130-claude"
LOCK="$HOME/buster-fast-bench/exclusive.sh"
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export TMPDIR="$W/tmp"
mkdir -p "$TMPDIR" "$W/bin" "$W/logs"
