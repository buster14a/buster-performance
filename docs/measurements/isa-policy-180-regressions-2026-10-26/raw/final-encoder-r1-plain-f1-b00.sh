set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-encoder-r1-plain-f1-b00'
c='/tmp/buster421-final-encoder-r1-plain-f1-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-000'
cmp -- '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-421-ac57-head/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-001'
cmp -- '/home/david/buster-fast-bench/codex-421-ac57-head/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-ac57-head/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-ac57-head/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-002'
cmp -- '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-003'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-004'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-005'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-006'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-007'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-008'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-672' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-009'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-010'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-011'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-012'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-013'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-014'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-015'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-016'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-017'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-1680' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-018'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-019'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-020'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-021'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-022'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-023'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-024'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-025'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-026'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-2688' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-027'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-028'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-029'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-030'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-031'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-032'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-033'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-034'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-035'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/ac57-head-checker-placements/compiler-3696' '/tmp/buster421-final-encoder-r1-plain-f1-b00/bin-035' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/final-encoder-r1-plain-f1-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
