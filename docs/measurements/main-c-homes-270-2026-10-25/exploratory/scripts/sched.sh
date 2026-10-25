#!/bin/bash
# sched.sh VARIANT TREE: compiles TREE's build.sh sources with build.sh's flags (no -g, as the 9700X job builds) into a
# temporary directory, scheduled as VARIANT says, then prints each compile's start and end in ms from the first start,
# sorted by end, and the whole compile's wall time. It doesn't link: build.sh's link comes after every compile anyway.
#   all     every source at once (build.sh)
#   nice    every source at once, those but main.c's units under nice -n 10
#   pin     every source at once, main_unit_checker.c pinned to CPU 2 and the rest to the other CPUs
#   lpt15   at most 15 at once, longest first (by main's measured times)
#   lpt8    at most 8 at once, longest first
#   alone   main_unit_checker.c, main_unit_backend.c and main_unit_frontend.c one at a time, then the checker's on CPU 2
#   alone:A,B  the units A.c and B.c one at a time
variant="$1"
cd "$2"
eval "$(sed -n 's/^sources=(\(.*\))$/sources=(\1)/p' build.sh)"
sources+=(src/buster/compiler/main_unit_fragments.c)
out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT
export out
now() { echo "${EPOCHREALTIME//[!0-9]/}"; }
one()
{
    local source="$1"
    shift
    local name start end
    name="$(basename "$source")"
    start="$(now)"
    "$@" clang -c "$source" -o "$out/$name.o" -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -O3
    end="$(now)"
    echo "$start $end $name" >> "$out/times"
}
export -f one now
# main's order, longest first, from a 9700X build of 2026-10-25.
order="main_unit_checker main_unit_backend main_unit_frontend main_unit_executable main_unit_link main_unit_fragments main_unit_assembler main_unit_dynamic main_unit_types c_parser_benchmark main main_unit_check_builtins main_unit_x86 link_benchmark c_preprocessor_benchmark c_files_benchmark foreign_benchmark executable_benchmark bind_benchmark snapshot_benchmark c_refine_benchmark c_checker_benchmark tier0_benchmark x86_64_encoder_benchmark import_benchmark tier1_select_benchmark c_lexer_benchmark branch_sizing_benchmark object_writer_benchmark calling_convention_benchmark x86_64_disassembler_benchmark x86_semantics_benchmark tier1_model_measure tier1_schedule_benchmark dominators_benchmark c_types_benchmark tier1_frame_benchmark tier1_allocate_benchmark c_builtin_benchmark dataflow_benchmark lane_benchmark floors_benchmark"
ordered=()
for name in $order; do
    for s in "${sources[@]}"; do
        [ "$(basename "${s%.c}")" = "$name" ] && ordered+=("$s")
    done
done
[ "${#ordered[@]}" -eq "${#sources[@]}" ] || { echo "sched.sh: the order has ${#ordered[@]} of ${#sources[@]} sources" >&2; exit 1; }
others="$(seq -s, 0 15 | sed 's/\b2,//')"
begin="$(now)"
case "$variant" in
    all) for s in "${sources[@]}"; do one "$s" & done; wait ;;
    nice) for s in "${sources[@]}"; do if [[ "$s" == */main*.c ]]; then one "$s" & else one "$s" nice -n 10 & fi; done; wait ;;
    pin) for s in "${sources[@]}"; do if [[ "$s" == */main_unit_checker.c ]]; then one "$s" taskset -c 2 & else one "$s" taskset -c "$others" & fi; done; wait ;;
    lpt[0-9]*) printf '%s\n' "${ordered[@]}" | xargs -P "${variant#lpt}" -I{} bash -c 'one {}' ;;
    alone) for s in src/buster/compiler/main_unit_checker.c src/buster/compiler/main_unit_backend.c src/buster/compiler/main_unit_frontend.c; do one "$s"; done; one src/buster/compiler/main_unit_checker.c taskset -c 2 ;;
    alone:*) for name in $(echo "${variant#alone:}" | tr , ' '); do one "src/buster/compiler/$name.c"; done ;;
    *) echo "sched.sh: unknown variant $variant" >&2; exit 1 ;;
esac
finish="$(now)"
sort -n -k2 "$out/times" | awk -v b="$begin" '{ printf "  %7.1f %7.1f %7.1f s %s\n", ($1 - b) / 1e6, ($2 - b) / 1e6, ($2 - $1) / 1e6, $3 }'
echo "$variant: $(( (finish - begin) / 1000 )) ms"
