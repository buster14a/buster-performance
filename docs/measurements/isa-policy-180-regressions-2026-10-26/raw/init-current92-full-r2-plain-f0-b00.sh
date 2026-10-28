set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/init-current92-full-r2-plain-f0-b00'
c='/tmp/buster421-init-current92-full-r2-plain-f0-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_QUALIFIED_IMAGES'
3d1de0c13a13e47ca17dd3bad52555e492a7cb19116d2459ffa617bf8d0aeb75  /home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
d1119d64005d599e8216a245468ce2bf5788c7c2480bfd5a171091d429d53bf6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336
64765ea5481fe4cdc606ecb6557c20563c550a0ae749474fe161ec01c9542031  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336
58ab74498644cbd779441d1f00a95b331561c29c17daf66c5a9852f9365ecd33  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672
7d8c545a04cbebc891b5e3b5ae3f771e6b92f56a4aa6d5888aea1a0960459966  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672
f5ca45d409918f3edc3cba46457c2b9f43371efb41a3ffb453d0f06cabde4588  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008
308821fe7ed78b9e4eccf83a0ed6ec622b7ddd3397b8b52cf30c6c44d46bab00  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008
205422e8b62f5cf0b10208e56678da7704edd26b50bb1a4ae34ddf93e62f4721  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344
e67627ef18e839169ea229acd266f368933fec30f4cfc5fe8cb8d6d312c3d6be  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344
f612be43148a87d931324998aadb1bdbe1202b236dd8c4310afd1d790ca598dc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680
fe1d97374bb5c0c707a97042c061cdfedb197b05629c920cef3196493974f743  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680
994c9358cff3aef1f160b40cf8e231dd3f09ccbb66d5d1a165b615e8002dbeef  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016
ce4884607bd870280d6750242cd021502cc4ed93194c5588fdcf38a7bd3f6b26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016
bea4e4b7aa699cf386c9f75acced12589258bb2103c784bb659629c5ae767980  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352
2a86705e41fdb14c086e85f236a8c86c25b037cc13593513681dfca54bb3f3ca  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352
e289aa8190d93446f36848b04f2ffb449754b0d6921c0e5ba6f52a4ca27172b7  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688
a1df56b239d261ffa386fe100d13ffa107dcf050afe29db279c77a1952045b35  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688
9adbdc6aed063f73844abbc7d12b0c8008def1ea4eafbded69d2ace332647c6b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024
9f87302e27cec3aafcded7486ce6c665f14886ddda68eaea888729b0cb01fa67  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024
8f9f1ddb0712f644ac9d6b46e2136219c2f56d38de8ad34d06ffaf6e6a8f7c95  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360
695c9e2ffa63e1f266f29aeee0f87ad730c859fe18b56816979c58f2cbb47db8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360
73f225b1d6ac28513496f3a3cb41b98e8612fce2332ab908537b81923fce2ac1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696
8e8142446cb7c85ecc461a712f52dedb976344ec4647f35ce042aea5de507540  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696
BUSTER421_QUALIFIED_IMAGES
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-035' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-036'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-036'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-036' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-036' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-037'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-037'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-037' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-037' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-038'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-038'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-038' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-038' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-039'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-039'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-039' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-039' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-040'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-040'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-040' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-040' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-041'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-041'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-041' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-041' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-042'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-042'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-042' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-042' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-043'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-043'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-043' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-043' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-044'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-044'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-044' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-044' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-045'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-045'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-045' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-045' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-046'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-046'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-046' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-046' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-047'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-047'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-047' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-047' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-048'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-048'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-048' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-048' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-049'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-049'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-049' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-049' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-050'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-050'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-050' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-050' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-051'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-051'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-051' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-051' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-052'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-052'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-052' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-052' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-053'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-053'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-053' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-init-current92-full-r2-plain-f0-b00/bin-053' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/init-current92-full-r2-plain-f0-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
