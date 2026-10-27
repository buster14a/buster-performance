#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p inputs/offsets results/offsets
clang -O2 -Wall -Wextra -Werror campaign/offsets.c -o campaign/offsets
for identity in 0 1; do
    source="inputs/offsets/$identity.s"
    : > "$source"
    if [[ "$identity" == 0 ]]; then
        cat >> "$source" <<'ASM'
.text
.globl _start
_start:
    mov $60,%eax
    xor %edi,%edi
    syscall
ASM
    fi
    cat >> "$source" <<ASM
.section .debug_str,"MS",@progbits,1
.Lstart$identity:
    .asciz "duplicate_shared_string"
ASM
    back=24
    if [[ "$identity" == 1 ]]; then
        printf '    .asciz "only_between_entries"\n' >> "$source"
        back=45
    fi
    cat >> "$source" <<ASM
.local named_$identity
named_$identity:
    .asciz "alpha_suffix"
.section .debug_info,"",@progbits
    .long named_$identity+6
    .quad named_$identity+7
    .quad named_$identity-$back
.section .note.GNU-stack,"",@progbits
ASM
    clang -c "$source" -o "inputs/offsets/$identity.o"
done
for way in base vector exact lanes; do
    driver=campaign/driver-merge
    options=(--lanes 1)
    case "$way" in
        base) driver=campaign/driver-base ;;
        exact) options+=(--scalar) ;;
        lanes) options=(--lanes 2) ;;
    esac
    "$driver" "${options[@]}" -o "outputs/offsets-$way" inputs/offsets/0.o inputs/offsets/1.o
    campaign/offsets "outputs/offsets-$way" > "results/offsets/$way.txt"
    "./outputs/offsets-$way"
done
cmp outputs/offsets-vector outputs/offsets-exact
cmp outputs/offsets-vector outputs/offsets-lanes
