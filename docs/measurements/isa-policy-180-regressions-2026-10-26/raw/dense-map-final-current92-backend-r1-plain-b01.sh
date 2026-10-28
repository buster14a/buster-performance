set -e
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/dense-map-final-current92-backend-r1-plain-b01'
c='/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_CURRENT_QUALIFIED'
75453a4536cc464c7c6d025e918fa67ce166ab4e5fc4645486b0b77f519fb505  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler
cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8  /home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler
d1119d64005d599e8216a245468ce2bf5788c7c2480bfd5a171091d429d53bf6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336
f26bfcca60a021b42bd7bae133b82a958885aebe58d3cafb82f94025d5809201  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336
58ab74498644cbd779441d1f00a95b331561c29c17daf66c5a9852f9365ecd33  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672
12af2e5454a22cf8e6a2d933840f1d278a2a756a9a54249eea4b17931ce98b7c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672
d24bf45af63e8d50e4ab770dbf9bad6047dea914dcb893ec662641b2005dff48  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008
308821fe7ed78b9e4eccf83a0ed6ec622b7ddd3397b8b52cf30c6c44d46bab00  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008
205422e8b62f5cf0b10208e56678da7704edd26b50bb1a4ae34ddf93e62f4721  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344
18ef15e31a5e9b400a35050a7864de3b545c9e250c74ec9a6a011bad1f7a1851  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344
f612be43148a87d931324998aadb1bdbe1202b236dd8c4310afd1d790ca598dc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680
cbd1feacaf9ea390ff13b0bede86936c5ecce8e2f3b3db4e526e45d1b6cf9df0  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680
8cde9b303ce13e62cbfd5c6001588953e1792c780cf0e8dd822ec8c8ecd67574  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016
ce4884607bd870280d6750242cd021502cc4ed93194c5588fdcf38a7bd3f6b26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016
bea4e4b7aa699cf386c9f75acced12589258bb2103c784bb659629c5ae767980  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352
91cd2c5f48856abdbc784b6a0c3f630a4cc21abd2cd6a65d6797648d547a09c0  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352
e289aa8190d93446f36848b04f2ffb449754b0d6921c0e5ba6f52a4ca27172b7  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688
3e670f7b6d3dc98f3b70e80a14aff35b1b1fe301596cd04c77507c4c5e63312e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688
bbd0de033b3a5edadd7af337436ee880f2b0c6f12c59c4faa15296a9317fd147  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024
9f87302e27cec3aafcded7486ce6c665f14886ddda68eaea888729b0cb01fa67  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024
8f9f1ddb0712f644ac9d6b46e2136219c2f56d38de8ad34d06ffaf6e6a8f7c95  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360
026f1a411fa565888a4cf68be4c42ac5eeb9146889175c9c2e84305aca52e78f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360
73f225b1d6ac28513496f3a3cb41b98e8612fce2332ab908537b81923fce2ac1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696
e9367ffad949d214b3280592c37ffa2bafe9e6a92309dab3ae6eb5e563a95dd5  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696
BUSTER421_CURRENT_QUALIFIED
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-base-current92/build/compiler' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-672' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1008' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-1680' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2016' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-2688' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3024' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-current92-checker-placements/compiler-3696' '/tmp/buster421-dense-map-final-current92-backend-r1-plain-b01/bin-035' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/dense-map-final-current92-backend-r1-plain-b01.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 1 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
