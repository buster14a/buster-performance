set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/dispatch-final-current92-backend-r2-after-encode-b01'
c='/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
205422e8b62f5cf0b10208e56678da7704edd26b50bb1a4ae34ddf93e62f4721  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344
aa75314968c376381dbd4e65fecfd2d335c401c877b35f6c41670b0097d87040  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1344
f612be43148a87d931324998aadb1bdbe1202b236dd8c4310afd1d790ca598dc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680
6d48f59243f5ff981795698fc7b039bf543d825d30391d7b1e9f0728b8a436f7  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1680
59550456e90d900d1259860dc0dcb270fb679a1dfe51e109ebd0c80aefc8bae3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2016
ce4884607bd870280d6750242cd021502cc4ed93194c5588fdcf38a7bd3f6b26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016
bea4e4b7aa699cf386c9f75acced12589258bb2103c784bb659629c5ae767980  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352
aa7a6d728a97afd458913d18429f3e8dd83c4a66ad90b1a0588ffe1d8de75c17  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2352
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-000'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-001'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-002'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1344' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-target-dispatch-checker-placements/compiler-2352' '/tmp/buster421-dispatch-final-current92-backend-r2-after-encode-b01/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/dispatch-final-current92-backend-r2-after-encode-b01.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
