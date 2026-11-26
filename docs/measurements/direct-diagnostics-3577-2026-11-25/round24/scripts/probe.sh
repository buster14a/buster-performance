#!/bin/bash
# probe.sh FILE...: default -c against --no-direct -c with the head compiler, and the direct path's bail reason.
S=/tmp/claude-0/-home-user/cf3643bc-6e1c-51b2-99ca-175eb97147e4/scratchpad
P=${P:-/home/user/count-head/compiler}
export LLVM_PROFILE_FILE=/dev/null
for f in "$@"; do
  t=$(mktemp -d)
  rm -f $t/bail.txt
  BUSTER_TEST_DIRECT_BAILS=$t/bail.txt timeout 20 $P $EXTRA -c "$f" -o $t/a.o > $t/a.txt 2>&1; sa=$?
  timeout 20 $P --no-direct $EXTRA -c "$f" -o $t/b.o > $t/b.txt 2>&1; sb=$?
  if [ "$sa" = "$sb" ] && cmp -s $t/a.txt $t/b.txt; then c=SAME; else c=DIFF; fi
  printf '%s %s: direct=%s full=%s bail=[%s]\n' "$c" "$f" "$sa" "$sb" "$(cut -f1 $t/bail.txt 2>/dev/null | head -1)"
  if [ "$c" = DIFF ] || [ -n "$VERBOSE" ]; then sed 's/^/   full| /' $t/b.txt | grep -v "generated\.$" | head -${N:-6}; sed 's/^/ direct| /' $t/a.txt | grep -v "generated\.$" | head -4; fi
  rm -rf $t
done
