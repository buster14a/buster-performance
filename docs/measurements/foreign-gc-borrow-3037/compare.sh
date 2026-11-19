#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run in a clean disposable checkout of buster. zlib/ is a checkout of zlib 1.3.1.
set -euo pipefail
export LC_ALL=C BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3
# The hosted correctness row supplies GDB and permits its child-process debugging.
if [[ -n ${GITHUB_ACTIONS:-} ]]; then
    if ! command -v gdb >/dev/null; then
        sudo apt-get -o Acquire::Retries=3 update -qq
        sudo apt-get -o Acquire::Retries=3 install -y --no-install-recommends gdb
    fi
    sudo sysctl -w kernel.yama.ptrace_scope=0
fi
gdb --version | sed -n '1p'
repo=$PWD
here=$(cd "$(dirname "$0")" && pwd)
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=$(cat "$here/head-revision")
test "$(git rev-parse HEAD)" = "$base"
test "$(git -C zlib rev-parse HEAD)" = 51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf
git fetch --no-tags https://github.com/buster14a/buster.git "$head"
test "$(git rev-parse FETCH_HEAD^)" = "$base"
work=$(mktemp -d)
cd "$work"
echo "BUSTER_SOURCE base=$base head=$head"
clang --version | head -1
cc --version | head -1
ld.bfd --version | head -1
ld.lld --version | head -1
flags=(-O2 -fno-pie -fno-stack-protector -ffunction-sections -fdata-sections)
no_eh=(-fno-asynchronous-unwind-tables -fno-unwind-tables)
cat > start.s <<'EOF'
.text
.globl _start
_start:
    call checksums
    mov %eax,%edi
    mov $60,%eax
    syscall
.section .note.GNU-stack,"",@progbits
EOF
cat > program.c <<'EOF'
extern unsigned long adler32(unsigned long, const unsigned char *, unsigned);
extern unsigned long crc32(unsigned long, const unsigned char *, unsigned);
extern const unsigned selected;
int forced_payload = 77;
int *forced_data = &forced_payload;
int unreferenced_data = 111;
int checksums(void)
{
    const unsigned char *data = (const unsigned char *)"123456789";
    if (adler32(1, data, 9) != 0x091e01deUL || crc32(0, data, 9) != 0xcbf43926UL)
        return 1;
    return selected == 17 ? 42 : selected == 99 ? 43 : 2;
}
EOF
clang -c start.s
for value in 17 99; do
    cat > "group-$value.s" <<EOF
.section .rodata.selected,"aG",@progbits,selected,comdat
.weak selected
.type selected,@object
.size selected,4
selected: .long $value
.section .note.GNU-stack,"",@progbits
EOF
    clang -c "group-$value.s"
    readelf --section-groups "group-$value.o" | grep 'COMDAT group.*selected'
done
for kind in plain unwind; do
    mkdir "$kind"
    eh=("${no_eh[@]}")
    if [[ $kind == unwind ]]; then eh=(-fasynchronous-unwind-tables); fi
    for unit in crc32 adler32; do
        clang "${flags[@]}" "${eh[@]}" -c "$repo/zlib/$unit.c" -o "$kind/$unit.o"
    done
    clang "${flags[@]}" "${eh[@]}" -c program.c -o "$kind/program.o"
done
for o in plain/*.o start.o group-*.o; do
    if readelf -SW "$o" | grep -F '.eh_frame'; then exit 1; fi
done
for o in unwind/*.o; do readelf -SW "$o" | grep -F '.eh_frame' >/dev/null; done

printf '%s\n' '.section .eh_frame,"a",@progbits' '.section .note.GNU-stack,"",@progbits' > empty.s
clang -c empty.s
readelf -SW empty.o | grep -E '\.eh_frame .* 000000 ' >/dev/null
cat > export.c <<'EOF'
extern __attribute__((visibility("hidden"))) int payload;
int *exported_data = &payload;
EOF
cat > payload.c <<'EOF'
__attribute__((visibility("hidden"))) int payload = 73;
__attribute__((visibility("hidden"))) int discarded_payload = 11;
EOF
clang "${flags[@]}" "${no_eh[@]}" -fPIC -c export.c payload.c
cat > load.c <<'EOF'
#include <dlfcn.h>
int main(int argc, char **argv)
{
    void *handle = argc == 2 ? dlopen(argv[1], RTLD_NOW) : 0;
    const int *const *p = handle ? dlsym(handle, "exported_data") : 0;
    return p && *p && **p == 73 ? 73 : 1;
}
EOF
clang -O2 load.c -ldl -o load
awk 'BEGIN {
    print ".text\n.globl _stress_start\n_stress_start: call sg0; mov %eax,%edi; mov $60,%eax; syscall"
    for (i=0; i<4096; ++i) {
        printf ".section .text.sg%d,\"ax\",@progbits\n.globl sg%d\n.type sg%d,@function\nsg%d:\n",i,i,i,i
        if (i+2<4096) printf "jmp sg%d\n",i+2
        else print "mov $42,%eax; ret"
    }
    print ".section .note.GNU-stack,\"\",@progbits"
}' > stress.s
clang -c stress.s
sha256sum start.o group-*.o plain/*.o unwind/*.o empty.o export.o payload.o stress.o
build_compiler() {
    local log="$work/build-$1.log"
    (cd "$repo" && ./build.sh --config Release) > "$log" 2>&1 || { tail -80 "$log"; return 1; }
    sha256sum "$repo/build/compiler" | sed "s|$repo/build/compiler|compiler-$1|"
}
run_case() {
    local variant=$1 mode=$2 name=$3 expected=$4
    shift 4
    local dir="$work/results/$variant/$mode" output="$work/results/$variant/$mode/$name" rc=0
    mkdir -p "$dir"
    if [[ $mode == probe ]]; then export BUSTER_GC_MAPS="$output.maps"; else unset BUSTER_GC_MAPS; fi
    "$repo/build/compiler" link-foreign --lanes 1 --gc-sections -o "$output.elf" "$@" 2>"$output.log" || { cat "$output.log"; return 1; }
    if [[ $name == exports ]]; then
        ./load "$output.elf" || rc=$?
    else
        "$output.elf" || rc=$?
    fi
    test "$rc" = "$expected" || { echo "$name runtime exit $rc, expected $expected"; return 1; }
    echo "EXIT $variant $mode $name $rc"
    readelf -sW "$output.elf" > "$output.symbols"
    readelf -rW "$output.elf" > "$output.relocations"
    if [[ $name == exports ]]; then
        readelf --dyn-syms -W "$output.elf" | grep -E 'OBJECT .* exported_data$' >/dev/null
        if grep -qE ' discarded_payload$' "$output.symbols"; then return 1; fi
        grep -Eq 'R_X86_64_|RELR|relr.dyn' "$output.relocations"
    elif [[ $name == unwind ]]; then
        readelf -wf "$output.elf" > "$output.frames"
        grep -q ' CIE' "$output.frames" && grep -q ' FDE ' "$output.frames"
    elif [[ $name == forced || $name == reversed ]]; then
        for sym in forced_data forced_payload; do grep -qE " $sym$" "$output.symbols"; done
        if grep -qE ' unreferenced_data$' "$output.symbols"; then return 1; fi
    elif [[ $name == plain ]]; then
        if grep -qE ' (forced_data|forced_payload|unreferenced_data)$' "$output.symbols"; then return 1; fi
    fi
    if [[ $mode == probe ]]; then
        awk -v materialize="$([[ $variant == base || $name == unwind ]] && echo 1 || echo 0)" '
            /^GC-WORK / {
                ++lines; for (i=2;i<=NF;++i) {split($i,f,"="); m[f[1]]=f[2]+0}
                n=m["atoms"]+m["synthetic_nodes"]
                cols=25*m["atoms"]+4*m["fixups"]
                bytes=33*n+4*m["fixups"]+4+4*m["extra_edges"]
                ok=materialize ? (m["columns_copied"]==cols && m["cursors_copied"]==4*n && m["graph_scratch"]>=bytes && m["graph_scratch"]<=bytes+7) : (m["columns_copied"]+m["cursors_copied"]+m["graph_scratch"]==0)
            } END {exit !(lines==1 && ok)}' "$output.log"
        test -s "$output.maps"
        echo "WORK $variant $name $(grep '^GC-WORK' "$output.log")"
        cmp "$output.elf" "$work/results/$variant/clean/$name.elf"
        if [[ $variant == head ]]; then
            cmp "$output.maps" "$work/results/base/$mode/$name.maps"
            if [[ $name == unwind ]]; then
                grep -Eq 'synthetic_nodes=[1-9][0-9]* extra_edges=[1-9]' "$output.log"
                for metric in graph_scratch columns_copied cursors_copied; do grep -Eq "$metric=[1-9]" "$output.log"; done
            else
                grep -q 'synthetic_nodes=0 extra_edges=0 graph_scratch=0 columns_copied=0 cursors_copied=0' "$output.log"
            fi
            sha256sum "$output.maps" "$output.elf" | sed "s|$dir/||"
        fi
    fi
    if [[ $variant == head ]]; then
        for extension in elf symbols relocations; do cmp "$output.$extension" "$work/results/base/$mode/$name.$extension"; done
        if [[ $name == unwind ]]; then cmp "$output.frames" "$work/results/base/$mode/$name.frames"; fi
    fi
}
for variant in base head; do
    if [[ $variant == head ]]; then git -C "$repo" checkout --detach "$head"; fi
    for mode in clean probe; do
        if [[ $mode == probe ]]; then git -C "$repo" apply "$here/probe.patch"; fi
        build_compiler "$variant-$mode"
        caseargs=(-static -e _start start.o plain/program.o plain/adler32.o plain/crc32.o)
        run_case "$variant" "$mode" plain 42 "${caseargs[@]}" group-17.o group-99.o
        run_case "$variant" "$mode" forced 42 -u forced_data "${caseargs[@]}" group-17.o group-99.o
        run_case "$variant" "$mode" reversed 43 -u forced_data "${caseargs[@]}" group-99.o group-17.o
        run_case "$variant" "$mode" empty 42 "${caseargs[@]}" group-17.o group-99.o empty.o
        run_case "$variant" "$mode" unwind 42 -static -e _start start.o unwind/program.o unwind/adler32.o unwind/crc32.o group-17.o group-99.o
        run_case "$variant" "$mode" exports 73 -shared -soname gc-data.so export.o payload.o
        run_case "$variant" "$mode" stress 42 -static -e _stress_start stress.o
        if [[ $mode == clean ]]; then
            (cd "$repo" && ./build/compiler test-foreign --cross-check) > "$work/suite-$variant.log" 2>&1 || { tail -100 "$work/suite-$variant.log"; exit 1; }
            echo "CROSS-CHECK $variant"
            tail -50 "$work/suite-$variant.log"
        else
            git -C "$repo" apply -R "$here/probe.patch"
        fi
    done
done
git -C "$repo" diff --exit-code
echo 'COMPARISON PASSED'
