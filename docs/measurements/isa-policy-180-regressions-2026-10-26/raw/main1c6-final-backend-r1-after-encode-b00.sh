set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-backend-r1-after-encode-b00'
c='/tmp/buster421-main1c6-final-backend-r1-after-encode-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
25e0ae7158270c5725dd278bfec252452354e59d67a52b745b339952f58f6efa  /home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler
c8e4ffd91f9e4cb8d2fc207db419c8916e0708ae0a7cce911f6cc16c1a88b3e4  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler
e377ba633adbafdffecec75ddfcc211035c180ce766586273792e32b920d3040  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336
c4427e9165adc1ad8ccf332b3e598890c5917c4766fc377854810373c971014d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336
78257599a66463b1f1d00d7e264a5c99d63910c24d22785d42a739683cbbddec  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672
ea8a6bd8d1a508d40d3f7bcde0cb959799f148ea3461b3b57fb828d422afcb6a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672
02285aaed64a5204bcf04e4d523667e6c6c6626d7ad915ad915ef3bb20f175c4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008
d73e7b0b6908d7821c49a020094c45943e8732b979901ab93c0dbe39bedaf4e3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' '/tmp/buster421-main1c6-final-backend-r1-after-encode-b00/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-backend-r1-after-encode-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
