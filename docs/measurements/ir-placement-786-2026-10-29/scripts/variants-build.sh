#!/bin/bash
# The 41 sources at -O3 without -g (the build's flags), then main_unit_backend.c of each variant, each linked with the
# others' objects into vN/compiler: the variants differ in the backend unit's code alone.
set -e
root=$HOME/.cache/claude-786/o3
tree=$HOME/.cache/claude-786/wt
mkdir -p "$root/base"
cd "$tree"
mapfile -d '' flags < <(./build.sh print-compile-flags 2>/dev/null)
mapfile -d '' sources < <(./build.sh print-sources 2>/dev/null)
args=()
for f in "${flags[@]}"; do
    case "$f" in -g) ;; *) args+=("$f") ;; esac
done
printf '%s\n' "${args[@]}" > "$root/flags"
for i in "${!sources[@]}"; do
    clang -c "${sources[$i]}" -o "$root/base/$i.o" "${args[@]}" &
    while [ "$(jobs -rp | wc -l)" -ge "${CORES:-6}" ]; do wait -n; done
done
wait
for v in v0 v1 v2 v3 v4; do
    (cd "$root/$v" && clang -c src/buster/compiler/main_unit_backend.c -o backend.o "${args[@]}") &
    while [ "$(jobs -rp | wc -l)" -ge "${CORES:-6}" ]; do wait -n; done
done
wait
for v in v0 v1 v2 v3 v4; do
    objects=()
    for i in "${!sources[@]}"; do
        if [ "$(basename "${sources[$i]}")" = main_unit_backend.c ]; then objects+=("$root/$v/backend.o"); else objects+=("$root/base/$i.o"); fi
    done
    clang -no-pie --ld-path=/usr/bin/wild "${objects[@]}" -lm -ldl -o "$root/$v/compiler"
    echo "$v linked"
done
