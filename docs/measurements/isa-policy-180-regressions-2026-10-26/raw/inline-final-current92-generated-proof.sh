#!/bin/bash
set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/inline-final-current92-generated-proof'
mkdir "$d"
finish()
{
    s=$?
    trap - EXIT
    printf '%s\n' "$s" > "$d/exit.txt"
    set +e
    tar -cf - -C "$d" .
    a=$?
    if [ "$s" -ne 0 ]; then exit "$s"; else exit "$a"; fi
}
trap finish EXIT
sha256sum -c - > "$d/input-checks.log" <<'BUSTER421_PROOF_INPUTS'
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
0d7d81a1eae60d516e5b9416e5d9cce80905d4cc85bbab44702af3835c7e344d  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler
4d8cbf1745c8c03b35fb651584671985cdb241f1442fee67ba381605e981d0dc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/inline-final-current92-audit-elf.c
47442a469e617f316494b04ffd5a08f82bd5c81169cba07ba85806b20106ca58  /home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c
939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae  /usr/bin/clang
8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51  /usr/bin/wild
BUSTER421_PROOF_INPUTS
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -O0 -MD -MF "$d/clang-reference.d" --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/clang-reference" > "$d/clang-build.log" 2>&1
taskset -c 2 "$d/clang-reference" > "$d/clang-reference.out"
sed 's/\\$//' "$d/clang-reference.d" | tr ' \t' '\n' | sed -n '/^\//{ /:$/d; p; }' | sort -u | xargs -r sha256sum -- > "$d/header-identities.sha256"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I '/home/david/buster-fast-bench/codex-421-prototype-base-current92/src' --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/inline-final-current92-audit-elf.c' -o "$d/audit-base" > "$d/audit-base-build.log" 2>&1
taskset -c 2 "$d/audit-base" --self-test > "$d/audit-base-self-test.log" 2> "$d/audit-base-self-test.err"
set +e
taskset -c 2 "$d/audit-base" --self-test > /dev/full 2> "$d/audit-base-devfull.err"
io=$?
set -e
printf '%s\n' "$io" > "$d/audit-base-devfull.exit"
test "$io" -eq 1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/base-x86-64.o" > "$d/base-x86-64-object-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/base-x86-64.repeat.o" > "$d/base-x86-64-repeat-object-build.log" 2>&1
cmp "$d/base-x86-64.o" "$d/base-x86-64.repeat.o"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64 -o "$d/base-x86-64" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/base-x86-64-program-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64 -o "$d/base-x86-64.repeat" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/base-x86-64-repeat-program-build.log" 2>&1
cmp "$d/base-x86-64" "$d/base-x86-64.repeat"
taskset -c 2 "$d/base-x86-64" > "$d/base-x86-64.out"
cmp "$d/clang-reference.out" "$d/base-x86-64.out"
taskset -c 2 "$d/audit-base" x86-64 "$d/base-x86-64.o" > "$d/base-x86-64-base-audit.log"
sha256sum "$d/base-x86-64.o" "$d/base-x86-64" >> "$d/generated-identities.sha256"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v3 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/base-x86-64-v3.o" > "$d/base-x86-64-v3-object-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v3 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/base-x86-64-v3.repeat.o" > "$d/base-x86-64-v3-repeat-object-build.log" 2>&1
cmp "$d/base-x86-64-v3.o" "$d/base-x86-64-v3.repeat.o"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v3 -o "$d/base-x86-64-v3" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/base-x86-64-v3-program-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v3 -o "$d/base-x86-64-v3.repeat" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/base-x86-64-v3-repeat-program-build.log" 2>&1
cmp "$d/base-x86-64-v3" "$d/base-x86-64-v3.repeat"
taskset -c 2 "$d/base-x86-64-v3" > "$d/base-x86-64-v3.out"
cmp "$d/clang-reference.out" "$d/base-x86-64-v3.out"
taskset -c 2 "$d/audit-base" x86-64-v3 "$d/base-x86-64-v3.o" > "$d/base-x86-64-v3-base-audit.log"
sha256sum "$d/base-x86-64-v3.o" "$d/base-x86-64-v3" >> "$d/generated-identities.sha256"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v4 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/base-x86-64-v4.o" > "$d/base-x86-64-v4-object-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v4 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/base-x86-64-v4.repeat.o" > "$d/base-x86-64-v4-repeat-object-build.log" 2>&1
cmp "$d/base-x86-64-v4.o" "$d/base-x86-64-v4.repeat.o"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v4 -o "$d/base-x86-64-v4" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/base-x86-64-v4-program-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' --verify -march=x86-64-v4 -o "$d/base-x86-64-v4.repeat" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/base-x86-64-v4-repeat-program-build.log" 2>&1
cmp "$d/base-x86-64-v4" "$d/base-x86-64-v4.repeat"
taskset -c 2 "$d/base-x86-64-v4" > "$d/base-x86-64-v4.out"
cmp "$d/clang-reference.out" "$d/base-x86-64-v4.out"
taskset -c 2 "$d/audit-base" x86-64-v4 "$d/base-x86-64-v4.o" > "$d/base-x86-64-v4-base-audit.log"
sha256sum "$d/base-x86-64-v4.o" "$d/base-x86-64-v4" >> "$d/generated-identities.sha256"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/src' --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/inline-final-current92-audit-elf.c' -o "$d/audit-head" > "$d/audit-head-build.log" 2>&1
taskset -c 2 "$d/audit-head" --self-test > "$d/audit-head-self-test.log" 2> "$d/audit-head-self-test.err"
set +e
taskset -c 2 "$d/audit-head" --self-test > /dev/full 2> "$d/audit-head-devfull.err"
io=$?
set -e
printf '%s\n' "$io" > "$d/audit-head-devfull.exit"
test "$io" -eq 1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/head-x86-64.o" > "$d/head-x86-64-object-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/head-x86-64.repeat.o" > "$d/head-x86-64-repeat-object-build.log" 2>&1
cmp "$d/head-x86-64.o" "$d/head-x86-64.repeat.o"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64 -o "$d/head-x86-64" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/head-x86-64-program-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64 -o "$d/head-x86-64.repeat" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/head-x86-64-repeat-program-build.log" 2>&1
cmp "$d/head-x86-64" "$d/head-x86-64.repeat"
taskset -c 2 "$d/head-x86-64" > "$d/head-x86-64.out"
cmp "$d/clang-reference.out" "$d/head-x86-64.out"
taskset -c 2 "$d/audit-base" x86-64 "$d/head-x86-64.o" > "$d/head-x86-64-base-audit.log"
taskset -c 2 "$d/audit-head" x86-64 "$d/head-x86-64.o" > "$d/head-x86-64-head-audit.log"
sha256sum "$d/head-x86-64.o" "$d/head-x86-64" >> "$d/generated-identities.sha256"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v3 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/head-x86-64-v3.o" > "$d/head-x86-64-v3-object-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v3 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/head-x86-64-v3.repeat.o" > "$d/head-x86-64-v3-repeat-object-build.log" 2>&1
cmp "$d/head-x86-64-v3.o" "$d/head-x86-64-v3.repeat.o"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v3 -o "$d/head-x86-64-v3" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/head-x86-64-v3-program-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v3 -o "$d/head-x86-64-v3.repeat" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/head-x86-64-v3-repeat-program-build.log" 2>&1
cmp "$d/head-x86-64-v3" "$d/head-x86-64-v3.repeat"
taskset -c 2 "$d/head-x86-64-v3" > "$d/head-x86-64-v3.out"
cmp "$d/clang-reference.out" "$d/head-x86-64-v3.out"
taskset -c 2 "$d/audit-base" x86-64-v3 "$d/head-x86-64-v3.o" > "$d/head-x86-64-v3-base-audit.log"
taskset -c 2 "$d/audit-head" x86-64-v3 "$d/head-x86-64-v3.o" > "$d/head-x86-64-v3-head-audit.log"
sha256sum "$d/head-x86-64-v3.o" "$d/head-x86-64-v3" >> "$d/generated-identities.sha256"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v4 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/head-x86-64-v4.o" > "$d/head-x86-64-v4-object-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v4 -c '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' -o "$d/head-x86-64-v4.repeat.o" > "$d/head-x86-64-v4-repeat-object-build.log" 2>&1
cmp "$d/head-x86-64-v4.o" "$d/head-x86-64-v4.repeat.o"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v4 -o "$d/head-x86-64-v4" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/head-x86-64-v4-program-build.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail-documented/build/compiler' --verify -march=x86-64-v4 -o "$d/head-x86-64-v4.repeat" '/home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c' > "$d/head-x86-64-v4-repeat-program-build.log" 2>&1
cmp "$d/head-x86-64-v4" "$d/head-x86-64-v4.repeat"
taskset -c 2 "$d/head-x86-64-v4" > "$d/head-x86-64-v4.out"
cmp "$d/clang-reference.out" "$d/head-x86-64-v4.out"
taskset -c 2 "$d/audit-base" x86-64-v4 "$d/head-x86-64-v4.o" > "$d/head-x86-64-v4-base-audit.log"
taskset -c 2 "$d/audit-head" x86-64-v4 "$d/head-x86-64-v4.o" > "$d/head-x86-64-v4-head-audit.log"
sha256sum "$d/head-x86-64-v4.o" "$d/head-x86-64-v4" >> "$d/generated-identities.sha256"
cmp "$d/base-x86-64.o" "$d/head-x86-64.o"
cmp "$d/base-x86-64" "$d/head-x86-64"
cmp "$d/base-x86-64-v3.o" "$d/head-x86-64-v3.o"
cmp "$d/base-x86-64-v3" "$d/head-x86-64-v3"
cmp "$d/base-x86-64-v4.o" "$d/head-x86-64-v4.o"
cmp "$d/base-x86-64-v4" "$d/head-x86-64-v4"
sha256sum "$d/audit-base" "$d/audit-head" > "$d/auditor-identities.sha256"
sha256sum -c "$d/header-identities.sha256" > "$d/headers-after-check.log"
printf 'objects=6\nprograms=6\nrepeat_objects=6\nrepeat_programs=6\nprofile_pairs=3\nclang_outputs=6\nisa_audits=9\nexit=0\n' > "$d/steps.txt"
