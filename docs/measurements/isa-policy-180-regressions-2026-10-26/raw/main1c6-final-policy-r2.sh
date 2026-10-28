set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-policy-r2'
c='/tmp/buster421-main1c6-final-policy-r2'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
c8e4ffd91f9e4cb8d2fc207db419c8916e0708ae0a7cce911f6cc16c1a88b3e4  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler
25e0ae7158270c5725dd278bfec252452354e59d67a52b745b339952f58f6efa  /home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-003'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-004'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-005'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' '/tmp/buster421-main1c6-final-policy-r2/bin-005' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-final-policy-r2.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
