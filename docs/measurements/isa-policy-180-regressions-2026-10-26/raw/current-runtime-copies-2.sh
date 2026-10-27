set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-runtime-copies-2'
mkdir "$d"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
sha256sum current-generated-proof-retry1/base-x86-64 current-generated-proof-retry1/head-x86-64 current-generated-proof-retry1/base-x86-64-v3 current-generated-proof-retry1/head-x86-64-v3 current-generated-proof-retry1/base-x86-64-v4 current-generated-proof-retry1/head-x86-64-v4 > "$d/programs.sha256"
printf '%s  %s
' 'e89df4814bcc7bf47bed677974846fb12c4c0e2ff02c13335faec51d2eb48d35' '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' | sha256sum -c - > "$d/parent-check.log"
set +e
taskset -c 2 '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' 'time-runs' '--runs' '7' '--warmups' '1' '--copies' '3' '--directory' '/tmp/buster421-runtime-2' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/base-x86-64' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/base-x86-64-v3' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/base-x86-64-v4' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/head-x86-64' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/head-x86-64-v3' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/head-x86-64-v4' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/base-x86-64' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/base-x86-64-v3' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-generated-proof-retry1/base-x86-64-v4' '--list' > "$d/time-runs.log" 2> "$d/time-runs.err"
s=$?
printf '%s
' "$s" > "$d/exit.txt"
tar -cf - -C "$d" .
exit "$s"
