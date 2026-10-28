set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-runtime-r3'
mkdir "$d"
sha256sum -c - > "$d/qualified-programs-check.log" <<'BUSTER421_RUNTIME_PINS'
d1d3722f28d5a5b5178a14d3c202dc69d66e12a9e7a90add2c3c361660ccd3ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64
d1d3722f28d5a5b5178a14d3c202dc69d66e12a9e7a90add2c3c361660ccd3ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64-v3
d1d3722f28d5a5b5178a14d3c202dc69d66e12a9e7a90add2c3c361660ccd3ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64-v4
d1d3722f28d5a5b5178a14d3c202dc69d66e12a9e7a90add2c3c361660ccd3ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/head-x86-64
d1d3722f28d5a5b5178a14d3c202dc69d66e12a9e7a90add2c3c361660ccd3ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/head-x86-64-v3
d1d3722f28d5a5b5178a14d3c202dc69d66e12a9e7a90add2c3c361660ccd3ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/head-x86-64-v4
BUSTER421_RUNTIME_PINS
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
sha256sum main1c6-final-generated-proof/base-x86-64 main1c6-final-generated-proof/head-x86-64 main1c6-final-generated-proof/base-x86-64-v3 main1c6-final-generated-proof/head-x86-64-v3 main1c6-final-generated-proof/base-x86-64-v4 main1c6-final-generated-proof/head-x86-64-v4 > "$d/programs.sha256"
set +e
taskset -c 2 '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' 'time-runs' '--runs' '7' '--warmups' '1' '--copies' '3' '--directory' '/tmp' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64-v3' '--build' 'main' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64-v4' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/head-x86-64' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/head-x86-64-v3' '--build' 'head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/head-x86-64-v4' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64-v3' '--build' 'main-again' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-generated-proof/base-x86-64-v4' '--list' > "$d/time-runs.log" 2> "$d/time-runs.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
