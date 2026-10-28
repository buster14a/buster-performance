set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/small-current92-backend-r1-after-encode-b02'
c='/tmp/buster421-small-current92-backend-r1-after-encode-b02'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
e289aa8190d93446f36848b04f2ffb449754b0d6921c0e5ba6f52a4ca27172b7  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688
97eb1f2ac3ccd6d66dfcc3765ed364510e9d5eafb0b0eee2e0a7a6a7506ad841  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-2688
9f87302e27cec3aafcded7486ce6c665f14886ddda68eaea888729b0cb01fa67  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024
b543d88f0c0f722e5de684073cd040281cc967fd4a7522d8fa480ae3a564c3a5  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3024
d480871d399170655396d81ef62935d2bba5fc33567642f5170e9dcc5149fe4b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3360
8f9f1ddb0712f644ac9d6b46e2136219c2f56d38de8ad34d06ffaf6e6a8f7c95  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360
73f225b1d6ac28513496f3a3cb41b98e8612fce2332ab908537b81923fce2ac1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696
5c272ebe66425d49d6c690cb3b438d39ca8d7621d1d914b179aadf678b8f605c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3696
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-000'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-001'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-002'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-2688' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-one-tail-checker-placements/compiler-3696' '/tmp/buster421-small-current92-backend-r1-after-encode-b02/bin-011' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/small-current92-backend-r1-after-encode-b02.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
