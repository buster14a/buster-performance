set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-backend-r1-after-vector-b01'
c='/tmp/buster421-main1c6-final-backend-r1-after-vector-b01'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
28a34bc65e5f248b26c02a4337b3be414df2b00a57cddd9e35fbe56614738afd  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344
10aa8103d42bd093e31f03aa6b43f553bf2de8f4fb2eab0df93ec56885c288b8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344
ac736ec6a505fa3eaa7083f470a16701bbbc9ba366a90fc3cc41ba37a12c0c96  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680
269428430c66a5700a1581bd739cd83d6cd0ae98c803d2ed397bd7d661b15545  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680
7c188b026b3bb5b2dbad4b7feb1c7ce2524773c26c0f9bfb6635867922c3d595  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016
9e8973c76d8eacea939e3cbf5d033177776ce9a3330b23322ba8cb8cf745284a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016
5386fbbbfc288bf1c861d63c4e4ff87b3f5c06c4a0c0d3eec3144ad9a4af4722  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352
bfe5c4273d507e035fb94759076a9228831f7c3a10ae44f96596420f41eb19db  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-000'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-001'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-002'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' '/tmp/buster421-main1c6-final-backend-r1-after-vector-b01/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-backend-r1-after-vector-b01.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
