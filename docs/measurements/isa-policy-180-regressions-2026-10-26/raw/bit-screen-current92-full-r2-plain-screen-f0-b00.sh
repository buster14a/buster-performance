set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/bit-screen-current92-full-r2-plain-screen-f0-b00'
c='/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_QUALIFIED_IMAGES'
0d23c9f5b43ee5fcba8c9ec7759c32b8b4256102af22a127757bda30935a8ccf  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
d1119d64005d599e8216a245468ce2bf5788c7c2480bfd5a171091d429d53bf6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336
bc0ec5ec075c5e4407c96764f4a71e78abeec95bfcef862ebf153f384718a10a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336
58ab74498644cbd779441d1f00a95b331561c29c17daf66c5a9852f9365ecd33  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672
68cc6f73944b978fa85c527b0dea3376bc2e2d2153282afe217c68202eed67f8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672
e60c5258224ace0ee9752330a692a7bd17af36294f1d17b564fd592d18dea926  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008
308821fe7ed78b9e4eccf83a0ed6ec622b7ddd3397b8b52cf30c6c44d46bab00  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008
205422e8b62f5cf0b10208e56678da7704edd26b50bb1a4ae34ddf93e62f4721  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344
aa95e398da1f6b667e8129a39c0ee4c95beb3d2b4a06282222a6de97395b8fcd  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344
f612be43148a87d931324998aadb1bdbe1202b236dd8c4310afd1d790ca598dc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680
911ff026bc22a3ca20ce78f2cfabc3b236a4ae1319afc93846ca3ba31e14cf4e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680
2f345b8a5d5eb9928f2682bc5fa8aa208fb348ef86604af1965f758049b90ff9  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016
ce4884607bd870280d6750242cd021502cc4ed93194c5588fdcf38a7bd3f6b26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016
bea4e4b7aa699cf386c9f75acced12589258bb2103c784bb659629c5ae767980  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352
1e8c59fccd94691af22747875b1932471273ef928d64eb8017c459c17cedd05f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352
e289aa8190d93446f36848b04f2ffb449754b0d6921c0e5ba6f52a4ca27172b7  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688
1f5d5f0e87b27a3de3f0203ac74fcb32142a453f4c8ec9161e37680dca456ce6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688
a151fa98278db7e471384c2a718d4103eb1f6f4ebfccd2bec8589c81e10f0b79  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024
9f87302e27cec3aafcded7486ce6c665f14886ddda68eaea888729b0cb01fa67  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024
8f9f1ddb0712f644ac9d6b46e2136219c2f56d38de8ad34d06ffaf6e6a8f7c95  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360
d01e1b3ae2e084fdb2346a57214b06eff8c4bcf83a7cb68269925f198124384e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360
73f225b1d6ac28513496f3a3cb41b98e8612fce2332ab908537b81923fce2ac1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696
dcd98cdd7972af17281d0741969e866fb9a2be2ba451e0415647da6ecc1dd025  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696
BUSTER421_QUALIFIED_IMAGES
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-bit-screen-current92-full-r2-plain-screen-f0-b00/bin-035' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/bit-screen-current92-full-r2-plain-screen-f0-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
