set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-scan-r1-after30-f3'
mkdir "$d"
printf '%s
' 'ded4c396d61d2e5cb5dfc89cf5af910acfa5dcd012bc263b4125725ff02835e1  /home/david/buster-fast-bench/codex-421-template-phase-checked/phase-probe' | sha256sum -c - > "$d/program-check.log"
sha256sum '/home/david/buster-fast-bench/codex-421-template-phase-checked/phase-probe' > "$d/binary-identity.sha256"
printf '%s
' 'taskset -c 2 env LC_ALL=C '\''/home/david/buster-fast-bench/codex-421-template-phase-checked/phase-probe'\'' '\''--phase-order'\'' '\''0'\'' '\''--only'\'' '\''x86_encode_16'\'' '\''--count'\'' '\''65536'\'' '\''--section'\'' '\''65536'\'' '\''--offsets'\'' '\''--fixups'\'' '\''--after-scalar'\'' '\''30'\''' > "$d/command.txt"
set +e
taskset -c 2 env LC_ALL=C '/home/david/buster-fast-bench/codex-421-template-phase-checked/phase-probe' '--phase-order' '0' '--only' 'x86_encode_16' '--count' '65536' '--section' '65536' '--offsets' '--fixups' '--after-scalar' '30' > "$d/stdout.log" 2> "$d/stderr.log"
result=$?
set -e
printf '%s
' "$result" > "$d/exit.txt"
tar -cf - -C "$d" .
exit "$result"
