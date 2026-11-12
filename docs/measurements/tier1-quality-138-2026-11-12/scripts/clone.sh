#!/bin/bash
# clone.sh COMMIT [DIRECTORY]: a clean clone of buster14a/buster at COMMIT in DIRECTORY (src), by a depth-1 fetch of
# that commit alone. No build, so no lock.
set -eu
cd "$(dirname "$0")"
commit=${1:?a commit}
directory=${2:-src}
test ! -e "$directory"
git init -q "$directory"
git -C "$directory" remote add origin https://github.com/buster14a/buster.git
GIT_TERMINAL_PROMPT=0 git -C "$directory" fetch -q --depth 1 origin "$commit"
git -C "$directory" checkout -q FETCH_HEAD
test "$(git -C "$directory" rev-parse HEAD)" = "$commit"
echo "$commit" > "$directory.commit"
git -C "$directory" status --porcelain | wc -l
