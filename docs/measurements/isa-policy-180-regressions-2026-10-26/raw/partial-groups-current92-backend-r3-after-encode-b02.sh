set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/partial-groups-current92-backend-r3-after-encode-b02'
c='/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
73db3a1ac3a90369c775fa1efa79bf17bc849305c887f64f94aacc75a14c7e9d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-2688
e289aa8190d93446f36848b04f2ffb449754b0d6921c0e5ba6f52a4ca27172b7  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688
9f87302e27cec3aafcded7486ce6c665f14886ddda68eaea888729b0cb01fa67  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024
55423a39e684bdf42931ec426342fe08f54918209e9af629ad1117f7f398d00f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3024
8f9f1ddb0712f644ac9d6b46e2136219c2f56d38de8ad34d06ffaf6e6a8f7c95  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360
a2e75e6d0841a3b1755818a7429393dcf00bd15e52f030143272252b2cb8f758  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3360
b879e59a564c14372770c5b547d787f203c6f28f0d8d37ddb06ef1d01cc6784c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3696
73f225b1d6ac28513496f3a3cb41b98e8612fce2332ab908537b81923fce2ac1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-000'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-001'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-002'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3024' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-partial-groups-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-partial-groups-current92-backend-r3-after-encode-b02/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/partial-groups-current92-backend-r3-after-encode-b02.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 3 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
