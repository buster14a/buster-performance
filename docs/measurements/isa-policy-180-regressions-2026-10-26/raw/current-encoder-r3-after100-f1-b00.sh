set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-encoder-r3-after100-f1-b00'
c='/tmp/buster421-current-encoder-r3-after100-f1-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-000'
cmp -- '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-001'
cmp -- '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-002'
cmp -- '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-003'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-004'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-005'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-336' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-006'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-007'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-008'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-672' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-009'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-010'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-base-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-011'
cmp -- '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-head-checker-placements/compiler-1008' '/tmp/buster421-current-encoder-r3-after100-f1-b00/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-encoder-r3-after100-f1-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 3 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
s=$?
printf '%s
' "$s" > "$d/exit.txt"
tar -cf - -C "$d" .
exit "$s"
