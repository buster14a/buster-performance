set -e
o='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-checked-qualification-retry'
s='/home/david/buster-fast-bench/codex-421-template-phase-checked'
i='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-checked-inputs'
mkdir "$o"
printf '%s
' 'd16f51e8bfdc6c82bcf1f3b8cc7e39cc9429be8884e0b574e16d1e2a828b4727  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-checked-inputs/source-full.tar' '07e919650441ac1d0dba37cedd7eca4782028868ec352028c65cf7c76125dba8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-checked-inputs/raw/template-phase-checked-source-files.sha256' | sha256sum -c - > "$o/input-identities.log"
printf '%s
' '939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae  /usr/bin/clang' '8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51  /usr/bin/wild' | sha256sum -c - > "$o/tool-identities.log"
cd "$s"
sha256sum -c "$i/raw/template-phase-checked-source-files.sha256" > "$o/source-identities.log"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I src --ld-path=/usr/bin/wild phase-probe.c -o phase-probe > "$o/build.log" 2>&1
taskset -c 2 ./phase-probe --verify > "$o/verify.log" 2>&1
set +e
taskset -c 2 ./phase-probe --verify > /dev/full 2> "$o/verify-full.stderr"
verify_status=$?
taskset -c 2 ./phase-probe --phase-order 0 --only x86_encode_16 --count 65536 --section 65536 > /dev/full 2> "$o/scan-full.stderr"
scan_status=$?
set -e
printf 'verify_stdout_failure=%d
prebenchmark_stdout_failure=%d
' "$verify_status" "$scan_status" > "$o/io-tests.log"
test "$verify_status" -eq 1
test "$scan_status" -eq 1
test ! -s "$o/verify-full.stderr"
test ! -s "$o/scan-full.stderr"
sha256sum phase-probe > "$o/binary-identity.sha256"
size -A phase-probe > "$o/sizes.log"
readelf -Ws phase-probe > "$o/symbols.txt"
objdump -d --no-show-raw-insn -Mintel --disassemble=x86_encode_16 phase-probe > "$o/encoder.dis"
printf 'build=0
verify=0
exit=0
' > "$o/steps.txt"
tar -cf - -C "$o" .
