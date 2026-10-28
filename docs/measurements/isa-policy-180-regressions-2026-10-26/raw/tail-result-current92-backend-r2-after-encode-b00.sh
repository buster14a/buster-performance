set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/tail-result-current92-backend-r2-after-encode-b00'
c='/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
2e5158923d371851d3b1a59d00269a7e9b9893154f2c1a8e142fca6188ace802  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
d1119d64005d599e8216a245468ce2bf5788c7c2480bfd5a171091d429d53bf6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336
cda59a126a1dffbec9e00ba8e3709c825f8bb3cdc052166d165e5d591ede4781  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336
58ab74498644cbd779441d1f00a95b331561c29c17daf66c5a9852f9365ecd33  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672
2fff71986b6cf6432f0c747bdc35d97374fa4e7d896aa7e657e577e588718508  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672
5a9ace2c182d62ddae594c1d5b5156d06552ac4c1bedefffd0acc793a27b3c1b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008
308821fe7ed78b9e4eccf83a0ed6ec622b7ddd3397b8b52cf30c6c44d46bab00  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-tail-result-current92-backend-r2-after-encode-b00/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/tail-result-current92-backend-r2-after-encode-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
