#!/bin/bash
set -e
cd '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance'
clang -std=gnu17 -O1 -g -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all -I /home/david/.cache/buster421-base-92c0/src '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/current-audit-elf.c' --ld-path=/usr/bin/wild -o /home/david/.cache/buster421-c051/audit-current92-sanitize
export ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1
/home/david/.cache/buster421-c051/audit-current92-sanitize --self-test > '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/current-audit-local-sanitizer-self-test.log' 2> '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/current-audit-local-sanitizer-self-test.err'
set +e
/home/david/.cache/buster421-c051/audit-current92-sanitize --self-test > /dev/full 2> '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/current-audit-local-sanitizer-devfull.err'
s=$?
set -e
printf '%s\n' "$s" > '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/current-audit-local-sanitizer-devfull.exit'
test "$s" -eq 1
