set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-runtime-r2'
mkdir "$d"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
sha256sum final-generated-proof/base-x86-64 final-generated-proof/head-x86-64 final-generated-proof/base-x86-64-v3 final-generated-proof/head-x86-64-v3 final-generated-proof/base-x86-64-v4 final-generated-proof/head-x86-64-v4 > "$d/programs.sha256"
set +e
taskset -c 2 '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' 'time-runs' '--runs' '7' '--warmups' '1' '--copies' '3' '--directory' '/tmp' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/base-x86-64' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/base-x86-64-v3' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/base-x86-64-v4' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/head-x86-64' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/head-x86-64-v3' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/head-x86-64-v4' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/base-x86-64' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/base-x86-64-v3' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-generated-proof/base-x86-64-v4' '--list' > "$d/time-runs.log" 2> "$d/time-runs.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
