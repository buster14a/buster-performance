#!/usr/bin/env bash
set -euo pipefail
workdir=$1
mode=$2
action=$3
where=$4
cd "$workdir"
source "$where/tools/microarch/workloads.sh"
flags=()
[[ $mode == default ]] || flags=(-Wall -Wextra)
srcs=("$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c)
out="$mode-$action"
mkdir -p "$out"
printf 'source\tbase_status\thead_status\tmatch\tbase_stdout_sha256\tbase_stderr_sha256\tbase_object_sha256\n' >"$out/results.tsv"
for source in "${srcs[@]}"; do
    tag=()
    for v in base head; do
        args=()
        if [[ $action == object ]]; then args=(-c -o "$out/work.o"); else args=(-fsyntax-only); fi
        rm -f "$out/work.o"
        status=0
        "bin/compiler-$v" "${MUSL_OPTIONS[@]}" --lanes 1 "${flags[@]}" "${args[@]}" "$source" >"$out/$v.stdout" 2>"$out/$v.stderr" || status=$?
        sp=-
        if [[ -f "$out/work.o" ]]; then sp=$(sha256sum "$out/work.o"); sp=${sp%% *}; fi
        tag+=("$status" "$sp")
    done
    match=yes
    if [[ ${tag[0]} != "${tag[2]}" || ${tag[1]} != "${tag[3]}" ]] || ! cmp -s "$out/base.stderr" "$out/head.stderr" || ! cmp -s "$out/base.stdout" "$out/head.stdout"; then
        match=no
        cp "$out/base.stderr" "$out/${source//\//-}.base.stderr"
        cp "$out/head.stderr" "$out/${source//\//-}.head.stderr"
    fi
    stdout=$(sha256sum "$out/base.stdout"); stderr=$(sha256sum "$out/base.stderr")
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$source" "${tag[0]}" "${tag[2]}" "$match" "${stdout%% *}" "${stderr%% *}" "${tag[1]}" >>"$out/results.tsv"
done
awk -F '\t' 'NR>1 {n++; ok+=($2==0); diff+=($4!="yes")} END {printf "%d files, %d base successes, %d differences\n", n,ok,diff; exit diff!=0}' "$out/results.tsv"
