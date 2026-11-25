#!/bin/bash
# Moves base to main 20f3573ee and head and work to the pushed head 363094190, then builds each in a locked run of its own.
D=$HOME/buster-fast-bench/3577-claude
cd "$D/repo" || exit 1
git fetch -q origin main claude/adoring-goodall-mr1480 || exit 1
git -C ../base checkout -q --detach 20f3573ee || exit 1
git -C ../head checkout -q --detach 363094190 || exit 1
git -C ../work checkout -q -- src tools docs 2>/dev/null
git -C ../work checkout -q --detach 363094190 || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path diagnostics: builds after merging main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
for t in base head work; do
  cd "$D/$t" || exit 1
  echo "== build $t $(git log --oneline -1 | cut -c1-40) $(date -u +%H:%M:%S)"
  ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$t.log" 2>&1
  echo "status $? $(date -u +%H:%M:%S)"
  tail -1 "$D/build-$t.log"
done
