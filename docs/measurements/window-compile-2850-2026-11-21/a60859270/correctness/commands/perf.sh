#!/bin/bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/.." && pwd);r=5882f7c2a
for which in current current-parent;do until grep -q 'published as build/compiler' "$w/pure-interior-study/$which-build.log";do if grep -Eq ' error:|build stopped|FAILED:' "$w/pure-interior-study/$which-build.log";then exit 1;fi;sleep 3;done;done
ln -f "$w/window-constants-parent/build/compiler" "$d/b86eadcbd-compiler"
CORES_TITLE='Measure true four-corpus current-main integer window compiles with verified complete ELF manifests' CORES_LINK=https://github.com/buster14a/buster/issues/2850 cores -n 1 -- python "$d/perf.py" "$r"
