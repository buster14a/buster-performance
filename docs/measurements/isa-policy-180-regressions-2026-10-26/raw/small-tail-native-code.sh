set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/small-tail-native-code'
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
sha256sum -c - > "$d/image-checks.log" <<'BUSTER421_FINAL_CODE_IMAGE'
114163d0c6c231734a02a2b9156749e6c1b799ae4c4b229c6aff876175830b5c  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler
BUSTER421_FINAL_CODE_IMAGE
sha256sum -c - > "$d/tool-check.log" <<'BUSTER421_FINAL_CODE_TOOL'
9273687d5b7323cb103300f4facb847276657995ea6d5e5e6e25c97f4fc4594e  /usr/bin/objdump
BUSTER421_FINAL_CODE_TOOL
sha256sum /usr/bin/objdump > "$d/tool.sha256"
objdump -d --no-show-raw-insn -M intel --start-address=0x000000000123e2d0 --stop-address=0x1240f47 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' > "$d/prototype-isa-policy-inline-one-tail-documented-native-checker-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000001482980 --stop-address=0x1488445 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' > "$d/prototype-isa-policy-inline-one-tail-documented-native-standalone-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x00000000019f5580 --stop-address=0x19f81f7 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' > "$d/prototype-isa-policy-inline-one-tail-documented-native-backend-encoder.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000000ab4100 --stop-address=0xab41c5 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' > "$d/prototype-isa-policy-inline-one-tail-documented-native-scalar-policy.objdump.txt"
objdump -d --no-show-raw-insn -M intel --start-address=0x0000000000ab4200 --stop-address=0xab4391 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-one-tail-documented/build/compiler' > "$d/prototype-isa-policy-inline-one-tail-documented-native-vector-policy.objdump.txt"
