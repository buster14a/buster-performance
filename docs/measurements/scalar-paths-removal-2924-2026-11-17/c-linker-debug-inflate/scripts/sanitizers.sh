#!/bin/bash
# Piece 1's tests under the three sanitizer builds, one after another.
cd /tmp/claude-0/san
for s in undefined address memory; do
  BUSTER_SANITIZER=$s ./build.sh --config Release > /tmp/claude-0/san-$s-build.log 2>&1 || { echo "$s: build failed"; continue; }
  b=$(grep -o "published as [^ ]*" /tmp/claude-0/san-$s-build.log | tail -1 | cut -d' ' -f3)
  for t in test-debug test-inflate; do
    $b $t > /tmp/claude-0/san-$s-$t.log 2>&1; echo "$s $t exit $? $(tail -1 /tmp/claude-0/san-$s-$t.log)"
  done
done
