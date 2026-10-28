set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-sql-stages-r2'
c='/tmp/buster421-main1c6-sql-stages-r2'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' '0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d' '/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c' | sha256sum -c - > "$d/input-check.log"
sha256sum -c '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-qualification/placement-identities.sha256' > "$d/base-placement-check.log"
sha256sum -c '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-qualification/placement-identities.sha256' > "$d/head-placement-check.log"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-035' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-036'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-036'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-036' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-036' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-037'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-037'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-037' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-037' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-038'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-038'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-038' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-sql-stages-r2/bin-038' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-039'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-039'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-039' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-039' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-040'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-040'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-040' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-040' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-041'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-041'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-041' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-sql-stages-r2/bin-041' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-042'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-042'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-042' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-042' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-043'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-043'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-043' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-043' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-044'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-044'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-044' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-sql-stages-r2/bin-044' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-045'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-045'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-045' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-045' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-046'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-046'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-046' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-046' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-047'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-047'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-047' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-sql-stages-r2/bin-047' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-048'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-048'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-048' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-048' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-049'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-049'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-049' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-049' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-050'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-050'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-050' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-sql-stages-r2/bin-050' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-051'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-051'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-051' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-051' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-052'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-052'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-052' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-052' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-053'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-053'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-053' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-sql-stages-r2/bin-053' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-054'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-054'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-054' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-054' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-055'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-055'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-055' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-055' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-056'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-056'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-056' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-sql-stages-r2/bin-056' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-057'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-057'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-057' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-057' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-058'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-058'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-058' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-058' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-059'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-059'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-059' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-sql-stages-r2/bin-059' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-060'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-060'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-060' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-060' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-061'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-061'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-061' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-061' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-062'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-062'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-062' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' '/tmp/buster421-main1c6-sql-stages-r2/bin-062' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-063'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-063'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-063' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-063' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-064'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-064'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-064' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-064' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-065'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-065'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-065' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' '/tmp/buster421-main1c6-sql-stages-r2/bin-065' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-066'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-066'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-066' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-066' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-067'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-067'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-067' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-067' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-068'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-068'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-068' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' '/tmp/buster421-main1c6-sql-stages-r2/bin-068' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-069'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-069'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-069' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-069' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-070'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-070'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-070' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-070' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-071'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-071'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-071' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' '/tmp/buster421-main1c6-sql-stages-r2/bin-071' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-sql-stages-r2.list' "$d/commands.list"
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
