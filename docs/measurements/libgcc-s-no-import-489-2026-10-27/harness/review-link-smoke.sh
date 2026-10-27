#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 review-build link smoke' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/625
D=$HOME/buster-fast-bench/codex-489-review
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D"
mkdir -p review-smoke/tmp review-smoke/cache
export TMPDIR=$D/review-smoke/tmp
"$X" ./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory "$D/review-smoke/tmp" --cache "$D/review-smoke/cache" > review-smoke/link.log 2>review-smoke/link.stderr
echo 'review link smoke done'
