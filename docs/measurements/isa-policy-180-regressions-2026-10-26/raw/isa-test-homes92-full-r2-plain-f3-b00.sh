set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/isa-test-homes92-full-r2-plain-f3-b00'
c='/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_QUALIFIED_IMAGES'
603b34f2ff20bc5ac3ae31f08d9d2f626a6126db931c4fae76300e0573fb9169  /home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
d1119d64005d599e8216a245468ce2bf5788c7c2480bfd5a171091d429d53bf6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336
e57e8e26275ba5d7eb1416be05ac7aec681eb977542b321c9a94dbab7f13be62  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336
58ab74498644cbd779441d1f00a95b331561c29c17daf66c5a9852f9365ecd33  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672
40fc910327680a0dc58b923f97533264d10c6258b7f25a9348b8f464a4938ab9  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672
f70e2f801e1b6fffea9cc51741e95e11533b4a5e0e9047a1b325b8acf8c12da8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008
308821fe7ed78b9e4eccf83a0ed6ec622b7ddd3397b8b52cf30c6c44d46bab00  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008
205422e8b62f5cf0b10208e56678da7704edd26b50bb1a4ae34ddf93e62f4721  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344
bdc1cbdd6f438d97abbb53177cce4ef73dcff6538a40cfa8ca277567b656bd85  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344
f612be43148a87d931324998aadb1bdbe1202b236dd8c4310afd1d790ca598dc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680
9ed0b9d45f71b1c983f4028bef1e6c2a92589e225ba8bc8826ca1a671e177f26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680
bd7c1e432f203f400e498545c105951f887641e5345c82f87e9b043364688aae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016
ce4884607bd870280d6750242cd021502cc4ed93194c5588fdcf38a7bd3f6b26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016
bea4e4b7aa699cf386c9f75acced12589258bb2103c784bb659629c5ae767980  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352
306ccd8f28a7d39771efc08a9d56efc689242b74bb291e37e27c2f6c1ee2eb0a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352
e289aa8190d93446f36848b04f2ffb449754b0d6921c0e5ba6f52a4ca27172b7  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688
78c7a7c889b6ef957b3ff46ced696b1be27fcfcc55b1c5767066de2d10bc1e7c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688
706ea0dc9c5df19eb64e5a50363f3809c32da982f72be51a2e267c5caeffa131  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024
9f87302e27cec3aafcded7486ce6c665f14886ddda68eaea888729b0cb01fa67  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024
8f9f1ddb0712f644ac9d6b46e2136219c2f56d38de8ad34d06ffaf6e6a8f7c95  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360
2c54edbf0689e9e5020e87a91cf8c334c1fbe743513be312e45e03780ebfe5d3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360
73f225b1d6ac28513496f3a3cb41b98e8612fce2332ab908537b81923fce2ac1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696
eb3ab855026b820b5dccc38036cc9665da07abec8b7575d18fed358101638a0c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696
BUSTER421_QUALIFIED_IMAGES
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-035' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-036'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-036'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-036' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-036' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-037'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-037'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-037' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-037' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-038'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-038'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-038' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-038' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-039'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-039'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-039' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-039' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-040'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-040'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-040' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-040' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-041'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-041'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-041' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-041' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-042'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-042'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-042' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-042' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-043'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-043'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-043' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-043' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-044'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-044'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-044' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-044' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-045'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-045'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-045' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-045' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-046'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-046'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-046' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-046' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-047'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-047'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-047' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-047' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-048'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-048'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-048' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-048' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-049'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-049'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-049' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-049' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-050'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-050'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-050' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-050' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-051'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-051'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-051' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-051' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-052'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-052'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-052' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-052' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-053'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-053'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-053' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-isa-test-homes92-full-r2-plain-f3-b00/bin-053' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/isa-test-homes92-full-r2-plain-f3-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
