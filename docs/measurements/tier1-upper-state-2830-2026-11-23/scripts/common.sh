# common.sh: sourced by the steps. The work directory, the lock's identity and the toolchain.
W=/tmp/buster-2830-claude
export EXCLUSIVE_OWNER=claude-2830
export EXCLUSIVE_TITLE="Issue 2830: Tier 1 vzeroupper and VEX scalar forms"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2830
LOCK=~/buster-fast-bench/exclusive.sh
CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
BASE=$W/bin/base
HEAD=$W/bin/head
state() { echo "--- $(date -u +%FT%TZ) $1"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; }
