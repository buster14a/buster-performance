set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/small-current92-backend-r3-after-encode-b00'
c='/tmp/buster421-small-current92-backend-r3-after-encode-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
114163d0c6c231734a02a2b9156749e6c1b799ae4c4b229c6aff876175830b5c  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail/build/compiler
d1119d64005d599e8216a245468ce2bf5788c7c2480bfd5a171091d429d53bf6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336
ed5b7dc601598e40f079d434bc46a6a6f5c4438e3989bfc710bdbdefd6d3fff8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-336
15f5745168919682038c472bcd6ad64062ad8729898395de0e577820eac8a40e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-672
58ab74498644cbd779441d1f00a95b331561c29c17daf66c5a9852f9365ecd33  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672
308821fe7ed78b9e4eccf83a0ed6ec622b7ddd3397b8b52cf30c6c44d46bab00  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008
a4e899423546290bc69bc1888c9991ef9ad3345a35bad5d22914a26731b9a9c8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-1008
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail/build/compiler' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-1008' '/tmp/buster421-small-current92-backend-r3-after-encode-b00/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/small-current92-backend-r3-after-encode-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 3 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
