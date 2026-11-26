#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# BASE_TREE HEAD_TREE CONFIGURED_CCAN_TREE LUA_RELEASE_TREE OUTPUT
set -euo pipefail
base=$(realpath "$1")
head=$(realpath "$2")
ccan=$(realpath "$3")
lua=$(realpath "$4")
mkdir -p -- "$5"
out=$(realpath "$5")
here=$(dirname "$(realpath "$0")")
export LC_ALL=C
export PATH="$(bash "$head/tools/ci/session-toolchain.sh" stage):$PATH"
export BUSTER_CLANG_RESOURCE_DIR="$(clang -print-resource-dir)"
cache="$out/cache"
mkdir -p "$cache"
grep -qx '#define HAVE_SECTION_START_STOP 1' "$ccan/config.h"
sources=()
for f in "$lua"/src/*.c; do
    if [[ ${f##*/} != luac.c ]]; then sources+=("$f"); fi
done
for n in 2048 8192; do awk -v sets="$n" -f "$here/fixtures.awk" > "$out/sets$n.c"; done
# The same four registries span eight producer files, 128 members in each registry.
mkdir -p "$out/entries"
for ((u=0;u<8;u++)); do
    awk -v unit="$u" 'BEGIN {for (i=0;i<64;i++) {n=unit*64+i; printf "const unsigned entry%d __attribute__((used,section(\"reg%d\")))=%du;\n",n,n%4,n+1}}' > "$out/entries/unit$u.c"
done
awk 'BEGIN {
    for(k=0;k<4;k++) printf "extern const unsigned __start_reg%d[],__stop_reg%d[];\n",k,k
    print "int main(void) {"
    for(k=0;k<4;k++) {
        printf "if (__stop_reg%d-__start_reg%d!=128) return 1;\n",k,k
        printf "for (unsigned i=0;i<128;++i) if (__start_reg%d[i]!=4*i+%d) return 2;\n",k,k+1
    }
    print "return 0; }"
}' > "$out/entries/main.c"
for side in base head; do
    tree=$base
    if [[ $side == head ]]; then tree=$head; fi
    bash "$here/instrument.sh" "$tree" "$out/$side"
    for case in ccan registries lua 2048 8192; do
        case "$case" in
            ccan) cd "$ccan"; args=(-I. ccan/autodata/test/run.c ccan/autodata/test/helper.c ccan/tap/tap.c);;
            registries) args=("$out"/entries/*.c);;
            lua) args=(-std=gnu99 -DLUA_USE_LINUX "${sources[@]}" -lm -ldl);;
            *) args=("$out/sets$case.c");;
        esac
        target="$out/$side/$case"
        XDG_CACHE_HOME="$cache" "$tree/build/compiler" --lanes 1 "${args[@]}" -o "$target.elf"
        XDG_CACHE_HOME="$cache" LLVM_PROFILE_FILE="$target.profraw" "$out/$side/compiler" --lanes 1 "${args[@]}" -o "$target.profiled.elf"
        cmp "$target.elf" "$target.profiled.elf"
        run=()
        if [[ $case == lua ]]; then run=(-e 'local t={}; for i=1,1000 do t[i]=i end; table.sort(t,function(a,b) return a>b end); assert(t[1]==1000 and t[1000]==1); print(_VERSION)'); fi
        "$target.elf" "${run[@]}" > "$target.stdout"
        if [[ $side == head ]]; then cmp "$out/base/$case.elf" "$target.elf"; cmp "$out/base/$case.stdout" "$target.stdout"; fi
        llvm-profdata merge "$target.profraw" -o "$target.profdata"
        llvm-cov export --skip-expansions --skip-branches -instr-profile="$target.profdata" "$out/$side/compiler" "$tree/src/buster/compiler/executable_impl.c" "$tree/src/buster/compiler/bind.c" > "$target.json"
    done
done
{
    printf 'workload\tbaseline_atom_visits\tindexed_endpoint_reads\tbaseline_grouping_calls\tpatched_grouping_calls\tbind_index_builds\telf_sha256\n'
    for case in ccan registries lua 2048 8192; do
        # LLVM regions start at the opening brace of the corresponding loop or conditional.
        b="$out/base/$case.json"
        h="$out/head/$case.json"
        visits=$(jq -er '.data[0].functions[] | select(.name|endswith(":executable_bound_value")) | first(.regions[] | select(.[0]==3114 and .[2]>3114)) | .[4]' "$b")
        reads=$(jq -er '.data[0].functions[] | select(.name|endswith(":executable_linker_value")) | first(.regions[] | select(.[0]==3121 and .[2]>3121)) | .[4]' "$h")
        builds=$(jq -er '.data[0].functions[] | select(.name|endswith(":bind_section_bound")) | first(.regions[] | select(.[0]==989 and .[2]>989)) | .[4]' "$h")
        group=' .data[0].functions[] | select(.name|endswith(":executable_bound_sections")) | .count '
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$case" "$visits" "$reads" "$(jq -er "$group" "$b")" "$(jq -er "$group" "$h")" "$builds" "$(sha256sum "$out/head/$case.elf" | cut -d' ' -f1)"
    done
} | tee "$out/counters.tsv"
