set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/small-doc-final-current92-policy-r1'
c='/tmp/buster421-small-doc-final-current92-policy-r1'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
114163d0c6c231734a02a2b9156749e6c1b799ae4c4b229c6aff876175830b5c  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-003'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-004'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-005'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-small-doc-final-current92-policy-r1/bin-005' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/small-doc-final-current92-policy-r1.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
