#!/bin/bash
# #442's rebaseline (2026-11-06): makes and builds the trees compared, each `git archive` of its Buster commit with the
# stage-split harness added and registered. Usage: build-trees.sh GIT_DIR OUTPUT_DIRECTORY NAME=COMMIT:KIND [PATCH]...
# KIND `old` takes the 2026-10-26 record's emit_ab.c and register.py ("NULL, false": check_program_emit's arguments after
# `scratch` before #395's rows), for trees before #1057's check_source_prepare; `now` takes emit_ab_now.c and
# register_now.py. NAME=COMMIT:KIND:PATCH applies PATCH (a `git diff` against COMMIT) to the tree first. LOCK, if set,
# runs each build under it (on the 9700X, ~/buster-fast-bench/exclusive.sh with EXCLUSIVE_OWNER and the rest).
set -e
here=$(cd "$(dirname "$0")" && pwd)
git=$1
out=$2
shift 2
mkdir -p "$out"
for spec in "$@"; do
    name=${spec%%=*}
    rest=${spec#*=}
    commit=${rest%%:*}
    rest=${rest#*:}
    kind=${rest%%:*}
    patch=
    [ "$rest" != "$kind" ] && patch=${rest#*:}
    rm -rf "$out/$name"
    mkdir -p "$out/$name"
    git -C "$git" archive "$commit" | tar -x -C "$out/$name"
    if [ -n "$patch" ]; then
        (cd "$out/$name" && patch -p1 --quiet < "$patch")
    fi
    case $kind in
        old)
            cp "$here/emit_ab.c" "$out/$name/src/buster/compiler/emit_ab.c"
            python3 "$here/register.py" "$out/$name/src/buster/compiler/main.c" "NULL, false"
            ;;
        now)
            cp "$here/emit_ab_now.c" "$out/$name/src/buster/compiler/emit_ab.c"
            python3 "$here/register_now.py" "$out/$name/src/buster/compiler/main.c"
            ;;
        *)
            echo "unknown kind $kind" >&2
            exit 1
            ;;
    esac
    (cd "$out/$name" && $LOCK env BUSTER_DEBUG_INFO=0 ./build.sh) > "$out/build-$name.log" 2>&1
    echo "$name $commit $kind ${patch:+$(sha256sum < "$patch" | cut -c1-16)} $(sha256sum < "$out/$name/build/compiler" | cut -c1-64)" >> "$out/trees.txt"
done
