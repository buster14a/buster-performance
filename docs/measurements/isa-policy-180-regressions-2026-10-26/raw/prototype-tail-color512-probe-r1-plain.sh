set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-probe-r1-plain'
c='/tmp/buster421-prototype-tail-color512-probe-r1-plain'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s\n' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-003'
cmp '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-004'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-005'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-006'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-007'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-008'
cmp '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-009'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-010'
cmp '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-011'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-035' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-036'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-036'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-036' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-036' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-037'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-037'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-037' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-037' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-038'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-038'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-038' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-038' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-039'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-039'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-039' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-039' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-040'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-040'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-040' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-040' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-041'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-041'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-041' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-041' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-042'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-042'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-042' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-042' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-043'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-043'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-043' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-043' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-044'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-044'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-044' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-044' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-045'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-045'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-045' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-045' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-046'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-046'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-046' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-046' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-047'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-047'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-047' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-prototype-tail-color512-probe-r1-plain/bin-047' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-probe-r1-plain.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
