set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/dynamic-current92-backend-r2-after-encode-b01'
c='/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
205422e8b62f5cf0b10208e56678da7704edd26b50bb1a4ae34ddf93e62f4721  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344
c3eee29f1f9529130a2a919f0d371e2c462ca853c95fc7038ca56b8c3eb3fdb9  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1344
f612be43148a87d931324998aadb1bdbe1202b236dd8c4310afd1d790ca598dc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680
33fd1da31c0c33fefdbf37661d2602a2b5dcc980000bf6025b361ef504b09360  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1680
586d7c7b57c7b41231ebf0f6c5edb365f6764e56cc0ad9aaf19dfbf1e058e13e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2016
ce4884607bd870280d6750242cd021502cc4ed93194c5588fdcf38a7bd3f6b26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016
bea4e4b7aa699cf386c9f75acced12589258bb2103c784bb659629c5ae767980  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352
072adfaa3b688ccbf54b00df4ac0773fc91765ec697584187c0a839cbabe306e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2352
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-000'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-001'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-002'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1344' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dynamic-tail-checker-placements/compiler-2352' '/tmp/buster421-dynamic-current92-backend-r2-after-encode-b01/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/dynamic-current92-backend-r2-after-encode-b01.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
