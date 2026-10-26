#!/bin/bash
# #442: makes and builds the four trees this record compares, each `git archive` of its Buster commit with emit_ab.c
# and its registration added. Usage: build-trees.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY
# On a host without AMD's mwaitx (this record's Intel host), the two older trees' lane.c needs the shim below to compile;
# main had guarded it with __MWAITX__ since. The 9700X has mwaitx: leave SHIM unset there.
set -e
here=$(cd "$(dirname "$0")" && pwd)
buster=$1
out=$2
mkdir -p "$out"
declare -A commits=(
    [main]=3bfb4a72a51f4a7872090905d52f92b95b3e1375   # main just before #418's merge (the merge's first parent)
    [pr]=54703dcf6607ecc1c7267869e46e59ab225ab393     # #418's merge
    [head]=7e3782ada38379f972f244a5f6b89ed0b2d4ed4a   # main when #442's work started
    [scans]=dd8b22b2f2437ebf602f45fa93ef0daebcf8e547  # #442's first commit on head: the scans and the ABI rows
    [new]=cb935a7aa1406db7e23457b557ae27cba4b91514    # #442's change: and the dotted labels alone in the names' table
)
for t in main pr head scans new; do
    rm -rf "$out/$t"
    mkdir -p "$out/$t"
    git -C "$buster" archive "${commits[$t]}" | tar -x -C "$out/$t"
    cp "$here/emit_ab.c" "$out/$t/src/buster/compiler/emit_ab.c"
    case $t in
        main | pr) tail="NULL, false" ;;
        *) tail="NULL, NULL, false" ;;
    esac
    python3 "$here/register.py" "$out/$t/src/buster/compiler/main.c" "$tail"
    if [ -n "$SHIM" ] && { [ $t = main ] || [ $t = pr ]; }; then
        sed -i 's|^static uint32_t lane_wait(uint32_t\* word, uint32_t value)$|// #442 off-host build shim: this host has no mwaitx.\n#ifndef __MWAITX__\n#define _mm_monitorx(a, b, c) ((void)0)\n#define _mm_mwaitx(a, b, c) _mm_pause()\n#endif\n&|' "$out/$t/src/buster/compiler/lane.c"
    fi
    (cd "$out/$t" && BUSTER_DEBUG_INFO=0 ./build.sh)
done
# The ablations of #418's merge: pr_emit, with main's c_check_program_emit.c (#418's naming undone), and pr_select,
# without #418's edges from a body to its block-scope statics (and their room).
for t in pr_emit pr_select; do
    rm -rf "$out/$t"
    cp -r "$out/pr" "$out/$t"
    rm -rf "$out/$t/build"
done
git -C "$buster" show "${commits[main]}":src/buster/compiler/c_check_program_emit.c > "$out/pr_emit/src/buster/compiler/c_check_program_emit.c"
python3 "$here/ablate_edges.py" "$out/pr_select/src/buster/compiler/c_check_program_select.c"
for t in pr_emit pr_select; do
    (cd "$out/$t" && BUSTER_DEBUG_INFO=0 ./build.sh)
done
