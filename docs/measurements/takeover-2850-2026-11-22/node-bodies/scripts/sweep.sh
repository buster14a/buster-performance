#!/bin/bash
# sweep.sh COMPILER OUT: the sweep's sources under each option set of the list below, six at a time.
cc=$1; out=$2
h=$(dirname "$0")
mkdir -p "$out"
ls /tmp/claude-1000/lazy/b3/loud/units3/*.c /tmp/claude-1000/lazy/b3/loud/units4/*.c "$h/sweep.c" "$h/fixture.c" "$h/splice.c" > "$out/sources.txt"
options=(
"" "-mfma" "-mavx" "-mavx2" "-mavx512f" "-march=x86-64-v2" "-march=x86-64-v3" "-march=x86-64-v4" "-march=native" "-msse4.2" "-mbmi2" "-mno-sse3" "-fwrapv" "-fno-builtin" "-O2" "-O3" "-Os"
"-fPIC" "-fPIE" "-fno-omit-frame-pointer" "-fsigned-char" "-funsigned-char" "-std=c89" "-std=c99" "-std=gnu11" "-std=c23" "-fno-common" "-ffunction-sections -fdata-sections"
"-fvisibility=hidden" "-ffreestanding" "-fno-strict-aliasing" "-fexceptions" "-fno-asynchronous-unwind-tables" "-mcmodel=large" "-fno-plt" "-mtune=znver5" "-fno-math-errno" "-fmath-errno"
"-fno-signed-zeros" "-ffp-contract=off" "-ffp-contract=on" "-frounding-math" "-fno-trapping-math" "-fcf-protection" "-fno-jump-tables" "-fshort-wchar" "-fms-extensions" "-fgnu89-inline"
"-pthread" "-D_FORTIFY_SOURCE=2" "-fno-delete-null-pointer-checks" "-fno-inline" "-finline-functions" "-fmerge-all-constants" "-fno-zero-initialized-in-bss" "-fstack-clash-protection"
"-fno-stack-protector" "-g0" "-w" "-pedantic" "-fpack-struct" "-mstackrealign" "-mpreferred-stack-boundary=4" "-fno-semantic-interposition" "-ftls-model=initial-exec" "-fhonor-nans"
"-fno-unsigned-char"
"-fstack-protector" "-fstack-protector-strong" "-fstack-protector-all" "-fsanitize=address" "-fsanitize=undefined" "-fsanitize=signed-integer-overflow" "-fsanitize=memory" "-fsanitize=thread"
"-fsanitize=kernel-address" "-fsanitize=bounds" "-fsanitize=null" "-fsanitize=shift" "-fsanitize=alignment" "-fsanitize=cfi" "-fsanitize=safe-stack" "-fsanitize=shadow-call-stack"
"-pg" "-pg -mfentry" "-finstrument-functions" "-mno-red-zone" "-fomit-frame-pointer" "-mgeneral-regs-only" "-msoft-float" "-mno-sse" "-mno-sse2" "-mno-mmx" "-mno-80387" "-mlong-double-64"
"-mlong-double-128" "-fshort-enums" "-fno-pic" "-fpie" "-fpic" "-mcmodel=medium" "-mcmodel=kernel" "-mcmodel=small" "-fsplit-stack" "-fpatchable-function-entry=2" "-fpatchable-function-entry=4,2"
"-ftrapv" "-ffast-math" "-funsafe-math-optimizations" "-ffinite-math-only" "-fexcess-precision=standard" "-ffp-eval-method=double" "-ffp-eval-method=extended" "-ffp-eval-method=source"
"-ffp-model=strict" "-ffp-model=precise" "-ffp-model=fast" "-ffp-exception-behavior=strict" "-ffp-exception-behavior=maytrap" "-fno-builtin-memcpy" "-mretpoline" "-mindirect-branch=thunk"
"-mindirect-branch=thunk-extern" "-mharden-sls=all" "-mfunction-return=thunk-extern" "-fzero-call-used-regs=all" "-fzero-call-used-regs=used-gpr" "-ftrivial-auto-var-init=zero"
"-ftrivial-auto-var-init=pattern" "-fno-optimize-sibling-calls" "-foptimize-sibling-calls" "-fsemantic-interposition" "-fdirect-access-external-data" "-fno-direct-access-external-data"
"-mskip-rax-setup" "-mrecord-mcount -pg" "-fasynchronous-unwind-tables" "-funwind-tables" "-fno-unwind-tables" "-fsanitize-coverage=trace-pc" "-fno-addrsig" "-mstack-alignment=32"
"-mstack-probe-size=8192" "-fstack-check" "-fcf-protection=branch" "-fcf-protection=return" "-mno-avx" "-mavx512bw" "-mavx512vl" "-mavx512dq" "-mf16c" "-mfma4" "-mxop" "-mlzcnt" "-mpopcnt" "-mbmi"
"-mmovbe" "-madx" "-mrdrnd" "-maes" "-mpclmul" "-msha" "-mcx16" "-msahf" "-mprfchw" "-mcrc32" "-march=znver4" "-march=skylake" "-march=haswell" "-march=nehalem" "-march=core2" "-march=k8"
"-march=x86-64" "-mtune=generic" "-mtune=native" "-O0" "-O1" "-Og" "-Oz" "-Ofast" "-fstrict-aliasing" "-fno-strict-overflow" "-fstrict-flex-arrays=3" "-fno-common -fPIC" "-fPIC -ftls-model=local-dynamic"
"-fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2" "-fPIC -mfma -O2" "-fno-plt -fPIC" "-mcmodel=large -fPIC" "-fvisibility=protected" "-fvisibility=internal" "-fkeep-static-consts"
"-fno-keep-static-consts" "-fwritable-strings" "-fno-ident" "-fverbose-asm" "-fno-verbose-asm" "-fdebug-prefix-map=/a=/b" "-ffile-prefix-map=/a=/b" "-fmacro-prefix-map=/a=/b" "-frandom-seed=1"
"-fno-signaling-nans" "-fsignaling-nans" "-fno-rounding-math" "-fno-finite-math-only" "-fassociative-math" "-freciprocal-math" "-fapprox-func" "-fno-honor-infinities" "-fhonor-infinities"
"-fdenormal-fp-math=preserve-sign" "-fcx-limited-range" "-fcx-fortran-rules" "-fcomplex-arithmetic=basic" "-ffloat-store" "-fsingle-precision-constant" "-fno-fast-math" "-fprotect-parens"
"-Wno-everything" "-Werror" "-fno-diagnostics-color" "-fdiagnostics-show-option" "-ferror-limit=1" "-fmax-errors=1" "-ftabstop=4" "-fno-caret-diagnostics" "-fdiagnostics-absolute-paths"
"-fsyntax-only" "-S" "-E"
)
# A job a line: its index, then its options (none for the first: its line has no trailing blank, which would join it to
# the next for xargs -L).
i=0
: > "$out/jobs.txt"
for o in "${options[@]}"; do
    if [[ -n $o ]]; then echo "$i $o"; else echo "$i"; fi >> "$out/jobs.txt"
    i=$((i + 1))
done
xargs -P "${CORES:-6}" -L 1 bash -c 'index=$0; "'"$h"'/sweep-one.sh" "'"$cc"'" "'"$out"'" "$index" "$@"' < "$out/jobs.txt" > "$out/results.txt" 2>&1
echo "option sets: $(wc -l < "$out/jobs.txt"); with a unit accepted: $(grep -vc ' accepted=0 ' "$out/results.txt"); with a difference: $(grep -vc 'DIFFER=0$' "$out/results.txt")"
echo "units accepted in all: $(awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^accepted=/) { split($i, a, "="); s += a[2] } } END { print s }' "$out/results.txt"); the same: $(awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^same=/) { split($i, a, "="); s += a[2] } } END { print s }' "$out/results.txt")"
grep -v 'DIFFER=0$' "$out/results.txt" | head -20
