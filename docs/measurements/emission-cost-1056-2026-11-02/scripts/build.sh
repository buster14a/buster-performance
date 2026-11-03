set -e
export EXCLUSIVE_OWNER=claude-1056 EXCLUSIVE_TITLE="#1056: no-debug compile cost of PR #1145" EXCLUSIVE_LINK="https://claude.ai/code/session_01TiDLnskdNJZGNsEWwi4BGK"
shifts="0 704 1408 2112 2752 3456"
for tree in base head; do
    cd ~/buster-fast-bench/1056-claude/$tree
    echo "== build $tree $(date -u +%FT%TZ)"
    ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/$tree main_unit_checker.c $shifts
done
ls -la ../shifts/base ../shifts/head
echo BUILD-DONE
