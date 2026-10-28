set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main-vector-full-r3-plain-f1-b00'
c='/tmp/buster421-main-vector-full-r3-plain-f1-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_QUALIFIED_IMAGES'
0bf7f99eca610ea770a66debe3aa2b414a835479a2c6a65daf5895a4778a9653  /home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler
c3001cc8e0d66718d08172147219beebe4f4e8ef0838ed425d255410f0d5be04  /home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler
b97475e11fc3ca85df206a623e60a0217fed00b72a2904dd7935bc811926575b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336
c8f67fb445e3eebba10e94db11d11bdbb58989e0cdd7b268e6e55a76cd1b0693  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336
c1b005986fa7721b359523f44ba33f6fa9cbef3e351de495764d5da4cea0e748  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672
4b4c7a62a84601d843ebaed25e551293cb9a431cb9a5117cca8ea45c58733192  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672
3bd23c7d51a0dd55eb5857d0e80437005ed13689bd93b66d5b5d81c4552daf53  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008
785509957e95029caed12a63f895eb5433ec2fa6ae49e75cc42a714bff9bfb63  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008
b507427c71db9fae57e0a12b3e743c7e0a457cbb3b7c74dab9dcdbed2380af82  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344
c42ef8d686fddc8cb63a18d57fd5637928d6757d1190a6fd51d5b9e4cbe77580  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344
82de527e3aa6c2667e45fa142a67561a1d04077285b6383ceb429c724c1243d4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680
74e49ac3ca2fbedd76ffd3d35fe61b40daf66623fd4a14bd3ecc28462d915c03  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680
d73ac97254a69dd6539d16f57f473a52c4d766dcb6443ea6e16c3b49abcd72b3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016
d966d6e1d65a63fe9de905eb78f252d9a0dc0adb2c0c7717234ba78beb19cbb3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016
b9856771d7b3dd5a5d0daac0c60ee02064298fe6726fd0d6681b8258364b54ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352
b1a6cc9dd363c1f7a420b8410d20f1a3cc6e84cd87b74dc6b29ad07d6303d3ca  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352
e13332b8ef959dfb5268a87a9e9eb90bd4f2039fe94bb58c84d846b7b15e8409  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688
a7cd2398e491bd3b9aa0ba259281acdcffa0a414f12cdaaa52e89f176430a626  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688
61685020655b0f8bfe4cb77e039bde7b41de03c0b319282d59d33607fd01cc13  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024
eb3b0e09f1662e7a799a5396e48e147a05b227505962f09c6dc1f434c3b2b36e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024
9447a16895bb6cdb57da40bc01b12a404acfc779c2d610e6f812b3e466a7715f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360
c5c76daca57f42b3fbf9d15614b5ce7d716df488b21d95e8081650f92fcd6a0b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360
ea9cc98b45f7a9e2c3d37b253df03cd17b702c45ef16ce73bcdc68b66110103a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696
1b79e96268c31cfbfc571133ff589b756978fabda207aa4b94f172a807b9cc21  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696
BUSTER421_QUALIFIED_IMAGES
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-035' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-036'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-036'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-036' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-036' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-037'
cmp '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-037'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-037' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-037' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-038'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-038'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-038' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-038' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-039'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-039'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-039' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-039' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-040'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-040'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-040' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-040' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-041'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-041'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-041' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-041' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-042'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-042'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-042' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-042' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-043'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-043'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-043' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-043' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-044'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-044'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-044' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-044' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-045'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-045'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-045' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-045' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-046'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-046'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-046' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-046' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-047'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-047'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-047' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-047' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-048'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-048'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-048' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-048' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-049'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-049'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-049' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-049' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-050'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-050'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-050' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-050' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-051'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-051'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-051' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-051' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-052'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-052'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-052' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-052' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-053'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-053'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-053' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' '/tmp/buster421-main-vector-full-r3-plain-f1-b00/bin-053' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/main-vector-full-r3-plain-f1-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 3 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
