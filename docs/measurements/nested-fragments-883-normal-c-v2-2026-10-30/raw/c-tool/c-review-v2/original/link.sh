#!/usr/bin/env bash
# link.sh TREE VARIANT SHIFT OUT [INSIDE]: TREE/objects/VARIANT.s with SHIFT bytes of .text before its code, and
# INSIDE bytes at the start of .text.buster_checker after its page alignment (#502's section), assembled for the
# host (as build.sh's -march=native compiles) and linked in the sources' order with wild, as build.sh links, into OUT.
set -e
cd "$1"
c=$(< objects/checker.index); n=$(< objects/count)
inside=${5-0}
work=objects/link-$2-$3-$inside
mkdir -p "$work"
{ printf '\t.text\n\t.skip %d\n' "$3"; awk -v k="$inside" '{print} !done && /^\t\.p2align\t12$|^\t\.p2align 12$/ {if (k > 0) printf "\t.skip %d\n", k; done = 1}' "objects/$2.s"; } > "$work/checker.s"
clang -c -march=native "$work/checker.s" -o "$work/checker.o"
linked=()
for ((i = 0; i < n; i += 1)); do
    if [ "$i" -eq "$c" ]; then linked+=("$work/checker.o"); else linked+=("objects/$i.o"); fi
done
clang -no-pie --ld-path="$(command -v wild)" "${linked[@]}" -lm -ldl -o "$4"
