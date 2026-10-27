set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-assembler-copies-1'
c='/tmp/buster421-asm-1'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
cp --reflink=never '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-asm-1/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-asm-1/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-asm-1/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-current-head-df02/build/compiler' '/tmp/buster421-asm-1/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-current-main-a66f/build/compiler' '/tmp/buster421-asm-1/bin-002' >> "$d/image-inodes.txt"
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/current-assembler-copies-1.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
s=$?
printf '%s
' "$s" > "$d/exit.txt"
tar -cf - -C "$d" .
exit "$s"
