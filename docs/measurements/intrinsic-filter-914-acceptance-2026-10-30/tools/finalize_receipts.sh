#!/usr/bin/env bash
set -euo pipefail
workspace=/home/david/Documents/Codex/2026-10-30/tak-3
tool="$workspace/work/perf-unwind-914"
campaign="$workspace/work/pr914-acceptance"
cd "$tool"
mkdir -p final-controls
cat > final-build-commands.txt <<'COMMANDS'
cd /home/david/Documents/Codex/2026-10-30/tak-3/work/perf-unwind-914
clang -std=c17 -O2 -Wall -Wextra -Werror attribution914.c -o attribution914 -ldw -lelf
clang -shared -fPIC -O2 -Wall -Wextra -Werror reuse_exec.c -o reuse_exec.so -ldw -lelf -ldl
clang -O2 -Wall -Wextra -Werror reuse_exec_test.c -o reuse_exec_test -ldw -lelf -ldl
clang -std=c17 -O2 -Wall -Wextra -Werror audit_fixture.c -o audit_fixture
clang -std=c17 -O2 -Wall -Wextra -Werror text_fixture.c -o text_fixture
COMMANDS
clang -std=c17 -O2 -Wall -Wextra -Werror attribution914.c -o attribution914 -ldw -lelf
clang -shared -fPIC -O2 -Wall -Wextra -Werror reuse_exec.c -o reuse_exec.so -ldw -lelf -ldl
clang -O2 -Wall -Wextra -Werror reuse_exec_test.c -o reuse_exec_test -ldw -lelf -ldl
clang -std=c17 -O2 -Wall -Wextra -Werror audit_fixture.c -o audit_fixture
clang -std=c17 -O2 -Wall -Wextra -Werror text_fixture.c -o text_fixture
cp "$campaign/bin/base/compiler" final-controls/different-filename-compiler
cd "$workspace"
date -u '+before_analysis_utc=%Y-%m-%dT%H:%M:%SZ' > "$tool/final-analysis-receipt.txt"
sha256sum work/perf-unwind-914/attribution914.c work/perf-unwind-914/attribution914 \
  work/perf-unwind-914/reuse_exec.c work/perf-unwind-914/reuse_exec.so \
  work/perf-unwind-914/reuse_exec_test.c work/perf-unwind-914/reuse_exec_test \
  work/perf-unwind-914/audit_fixture.c work/perf-unwind-914/audit_fixture \
  work/perf-unwind-914/text_fixture.c work/perf-unwind-914/text_fixture \
  work/perf-unwind-914/decode_one.sh work/perf-unwind-914/decode_grid.sh \
  work/perf-unwind-914/finalize_receipts.sh /usr/bin/perf /usr/bin/clang \
  /usr/lib/libdw.so.1 /usr/lib/libelf.so.1 \
  work/pr914-acceptance/bin/base/compiler work/pr914-acceptance/bin/head/compiler \
  work/pr914-acceptance/runtime-9700x/libc.so.6 work/pr914-acceptance/runtime-9700x/ld-linux-x86-64.so.2 \
  work/pr914-acceptance/raw/base-safe-p1.perf.data work/pr914-acceptance/raw/base-safe-p2.perf.data \
  work/pr914-acceptance/raw/base-safe-p3-retry.perf.data work/pr914-acceptance/raw/head-safe-p1.perf.data \
  work/pr914-acceptance/raw/head-safe-p2.perf.data work/pr914-acceptance/raw/head-safe-p3-retry.perf.data \
  > "$tool/final-decoder-sha256.txt"
perf version --build-options > "$tool/final-perf-build-options.txt"
clang --version > "$tool/final-clang-version.txt"
LD_PRELOAD="$tool/reuse_exec.so" "$tool/reuse_exec_test" "$campaign/bin/base/compiler" \
  "$tool/final-controls/different-filename-compiler" "$campaign/runtime-9700x/libc.so.6" \
  > "$tool/final-controls/reuse_exec_controls.log"
for mode in {0..9}; do
  prefix="$tool/final-controls/audit-$mode"
  "$tool/audit_fixture" "$mode" "$prefix.perf.data"
  actual=0
  "$tool/attribution914" --audit "$prefix.perf.data" > "$prefix.json" 2> "$prefix.stderr" || actual=$?
  expected=1
  if [[ "$mode" = 0 ]]; then expected=0; fi
  test "$actual" = "$expected"
  printf 'audit-%s expected_exit=%s actual_exit=%s PASS\n' "$mode" "$expected" "$actual"
done > "$tool/final-controls/audit-controls.log"
for mode in {0..3}; do
  prefix="$tool/final-controls/text-$mode"
  source="$tool/safe/base-safe-p1.primary.txt"
  if [[ "$mode" = 1 ]]; then source="$tool/safe/base-safe-p1.chains.txt"; fi
  "$tool/text_fixture" "$mode" "$source" "$prefix.txt"
  primary="$tool/safe/base-safe-p1.primary.txt"
  chains="$tool/safe/base-safe-p1.chains.txt"
  if [[ "$mode" = 1 ]]; then chains="$prefix.txt"; else primary="$prefix.txt"; fi
  actual=0
  "$tool/attribution914" "$campaign/raw/base-safe-p1.perf.data" "$campaign/bin/base/compiler" \
    "$campaign/runtime-9700x/libc.so.6" "$primary" "$chains" "$prefix.proof.csv" \
    > "$prefix.json" 2> "$prefix.stderr" || actual=$?
  test "$actual" = 1
  printf 'text-%s expected_exit=1 actual_exit=%s PASS\n' "$mode" "$actual"
done > "$tool/final-controls/text-controls.log"
date -u '+grid_begin_utc=%Y-%m-%dT%H:%M:%SZ' >> "$tool/final-analysis-receipt.txt"
bash work/perf-unwind-914/decode_grid.sh > "$tool/final-grid.log" 2>&1
date -u '+grid_end_utc=%Y-%m-%dT%H:%M:%SZ' >> "$tool/final-analysis-receipt.txt"
sha256sum --check "$tool/final-decoder-sha256.txt" > "$tool/final-identities-after-check.txt"
printf 'All frozen decoder, measured input, control and canonical grid gates passed.\n' >> "$tool/final-analysis-receipt.txt"
