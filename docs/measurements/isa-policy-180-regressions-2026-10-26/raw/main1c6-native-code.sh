set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main1c6-native-code'
mkdir "$d"
finish()
{
    s=$?
    trap - EXIT
    printf '%s\n' "$s" > "$d/exit.txt"
    set +e
    tar -cf - -C "$d" .
    a=$?
    if [ "$s" -ne 0 ]; then exit "$s"; else exit "$a"; fi
}
trap finish EXIT
sha256sum -c - > "$d/image-checks.log" <<'BUSTER421_FRESH_CODE_IMAGES'
25e0ae7158270c5725dd278bfec252452354e59d67a52b745b339952f58f6efa  /home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler
c8e4ffd91f9e4cb8d2fc207db419c8916e0708ae0a7cce911f6cc16c1a88b3e4  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler
BUSTER421_FRESH_CODE_IMAGES
sha256sum -c - > "$d/tool-check.log" <<'BUSTER421_FRESH_CODE_TOOL'
9273687d5b7323cb103300f4facb847276657995ea6d5e5e6e25c97f4fc4594e  /usr/bin/objdump
BUSTER421_FRESH_CODE_TOOL
sha256sum /usr/bin/objdump > "$d/tool.sha256"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000001290130 --stop-address=0x12925f9 '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' > "$d/base-checker-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x00000000014d7b30 --stop-address=0x14dc662 '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' > "$d/base-standalone-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000001a43280 --stop-address=0x1a45749 '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' > "$d/base-backend-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000000aff800 --stop-address=0xaff9fb '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' > "$d/base-scalar-policy.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000000affa00 --stop-address=0xaffa86 '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' > "$d/base-vector-policy.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000001254390 --stop-address=0x1257007 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' > "$d/head-checker-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x000000000149c2e0 --stop-address=0x14a1da5 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' > "$d/head-standalone-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000001a12820 --stop-address=0x1a15497 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' > "$d/head-backend-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000000abb100 --stop-address=0xabb1c5 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' > "$d/head-scalar-policy.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000000abb200 --stop-address=0xabb391 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' > "$d/head-vector-policy.objdump.txt"
