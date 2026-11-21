#!/bin/bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/.." && pwd);rev=5882f7c2a;r="$d/$rev";mkdir -p "$r"
for which in current current-parent;do until grep -q 'published as build/compiler' "$w/pure-interior-study/$which-build.log";do if grep -Eq ' error:|build stopped|FAILED:' "$w/pure-interior-study/$which-build.log";then exit 1;fi;sleep 3;done;done
ln -f "$w/window-constants-parent/build/compiler" "$d/b86eadcbd-compiler"
CORES_TITLE='Compare current ordinary compiler and --node-window-constants across all fixtures, corpora and policies' CORES_LINK=https://github.com/buster14a/buster/issues/2850 cores -n 2 -- bash -c 'set -eu; for suite in frozen tracked generated;do python "$1/driver.py" "$2/compiler" "$1/b86eadcbd-compiler" "$2/$suite" "$suite";done; python "$1/stages.py" "$2/compiler" "$2/stages"' _ "$d" "$r"
