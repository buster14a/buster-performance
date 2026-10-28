set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/color512-tail-r2-plain-f3-b00'
c='/tmp/buster421-color512-tail-r2-plain-f3-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_QUALIFIED_IMAGES'
6adfd4d0bd608f07cf70c96acff10fa3a11e9472af474e6e3eacb91726f75fa8  /home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler
0bf7f99eca610ea770a66debe3aa2b414a835479a2c6a65daf5895a4778a9653  /home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler
b97475e11fc3ca85df206a623e60a0217fed00b72a2904dd7935bc811926575b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336
4f4b5a30f1e3cd48dbd3892bfe7f465fcf4e9552e78237e3a4bb7558cfbfb457  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336
4b4c7a62a84601d843ebaed25e551293cb9a431cb9a5117cca8ea45c58733192  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672
f7e8e1648fdd74597e0e1e451ef571beb870f40db675e6b3191c41f1d87ab798  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672
48dd9bbbcbf78162ce2e1999704d56f9a78077835157b8be2348d4bfbcca7d07  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008
3bd23c7d51a0dd55eb5857d0e80437005ed13689bd93b66d5b5d81c4552daf53  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008
b507427c71db9fae57e0a12b3e743c7e0a457cbb3b7c74dab9dcdbed2380af82  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344
47db80e32a2411ac7a38c644537fe03c19fa4f941173d72575431f0f2d896f23  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344
74e49ac3ca2fbedd76ffd3d35fe61b40daf66623fd4a14bd3ecc28462d915c03  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680
a3f2ee4b90de305c0144ef32cd639614bc455ae7ee5ed1380d132a1aa14dfd82  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680
94372ff5866d47bb02e0bd3ebd8da0c22804252e7922d713252089f2342b4a91  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2016
d73ac97254a69dd6539d16f57f473a52c4d766dcb6443ea6e16c3b49abcd72b3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016
b9856771d7b3dd5a5d0daac0c60ee02064298fe6726fd0d6681b8258364b54ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352
90c0eb70b8e53cf32e5e8373adce1b8321257df8cc7e39eca11bad5f3ce32943  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2352
a7cd2398e491bd3b9aa0ba259281acdcffa0a414f12cdaaa52e89f176430a626  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688
a55d42a7d8b45427226a647f566bfdd869d376084f33c266dda85f638b7ec8d6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2688
77a65fd2b6f6b3fc23c6ed30dd27beb49df11a3700912fa5f61b9952964b5208  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3024
61685020655b0f8bfe4cb77e039bde7b41de03c0b319282d59d33607fd01cc13  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024
9447a16895bb6cdb57da40bc01b12a404acfc779c2d610e6f812b3e466a7715f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360
ac72f72773ac5383bc4f9ba3d31cfd0133290eb183932a3542f4bfe6909436bb  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3360
1b79e96268c31cfbfc571133ff589b756978fabda207aa4b94f172a807b9cc21  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696
a0c33b3cd3a943eaa32b8b03273c1713c197593d198db3821edaebab0cf700c8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3696
BUSTER421_QUALIFIED_IMAGES
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2352' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3360' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-035' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-036'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-036'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-036' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-036' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-037'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-037'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-037' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-037' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-038'
cmp '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-038'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-038' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-038' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-039'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-039'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-039' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-039' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-040'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-040'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-040' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-040' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-041'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-041'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-041' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-041' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-042'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-042'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-042' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-042' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-043'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-043'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-043' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-043' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-044'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-044'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-044' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-044' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-045'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-045'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-045' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-045' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-046'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-046'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-046' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-046' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-047'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-047'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-047' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-047' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-048'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-048'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-048' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-048' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-049'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-049'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-049' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-049' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-050'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-050'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-050' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-050' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-051'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-051'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-051' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-051' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-052'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-052'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-052' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-052' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-053'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-053'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-053' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-color512-tail-r2-plain-f3-b00/bin-053' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/color512-tail-r2-plain-f3-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
