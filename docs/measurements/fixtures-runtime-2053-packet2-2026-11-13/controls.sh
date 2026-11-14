#!/bin/bash
# #2053 packet 2's controls, on the 4-CPU cloud container with Develop's executables: test-checker with its default
# seed before the move (BASE, main's tree) and after it (HEAD, the branch's tree); then on HEAD's executable, with a
# private copy of tests/ as the fixture root (--fixtures): one case's flag flipped to rejected (flag), one case's file
# removed (missing), and a case added as a file and a line (added). Each run's tail and exit status to controls/NAME.txt.
set -u
out=$HOME/.cache/claude-2053p2/controls
base=/home/user/buster-wt-base2053
head=/home/user/buster
run() {
    local name=$1 tree=$2; shift 2
    (cd "$tree" && ./build/compiler test-checker "$@" > "$out/$name.log" 2>&1; echo "exit $?" >> "$out/$name.log")
    { grep -h "^test-checker: [0-9]* checks\|failed: \|fixtures (#2053)" "$out/$name.log" | tail -6; tail -1 "$out/$name.log"; } > "$out/$name.txt"
    echo "== $name"; cat "$out/$name.txt"
}
copy() {
    rm -rf "$out/root-$1"; cp -r "$head/tests" "$out/root-$1"
}
run base "$base"
run head "$head"
copy flag; sed -i 's/^0001\t0001.c\t-\t/0001\t0001.c\trejected\t/' "$out/root-flag/checker/cleanup/catalog.tsv"; run flag "$head" --fixtures "$out/root-flag"
copy missing; rm "$out/root-missing/checker/generic-builtins/0100.c"; run missing "$head" --fixtures "$out/root-missing"
copy added; printf 'int added_case(int x)\n{\n    return x * 2;\n}\n' > "$out/root-added/checker/musttail/0064.c"; printf '0064\t0064.c\t-\tan added case runs with no rebuild\n' >> "$out/root-added/checker/musttail/catalog.tsv"; run added "$head" --fixtures "$out/root-added"
