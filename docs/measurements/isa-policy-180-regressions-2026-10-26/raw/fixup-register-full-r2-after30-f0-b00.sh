set -e
set -o pipefail
d='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/fixup-register-full-r2-after30-f0-b00'
c='/tmp/buster421-fixup-register-full-r2-after30-f0-b00'
mkdir "$d" "$c"
trap 'rm -rf -- "$c"' EXIT
printf '%s  %s
' '94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' | sha256sum -c - > "$d/harness-check.log"
sha256sum -c - >> "$d/harness-check.log" <<'BUSTER421_QUALIFIED_IMAGES'
b6a0c07311bfd18959478ba05a96aea9b03e969388e51bb81d9149d6e5ae4b7d  /home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler
0bf7f99eca610ea770a66debe3aa2b414a835479a2c6a65daf5895a4778a9653  /home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler
b97475e11fc3ca85df206a623e60a0217fed00b72a2904dd7935bc811926575b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336
f0c6a011cab1a30d5a49e06ca32797bd110b876017c12518700461993716d939  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336
4b4c7a62a84601d843ebaed25e551293cb9a431cb9a5117cca8ea45c58733192  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672
3e58395584298b96384b524adfd0aa15b4f1a1c69a7fbbe47943cf5c4a254afe  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672
5a0fdb26abe0be9aee3a43f55fe7269b182a2d8679d72cd3a3a771541c1a1b5c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008
3bd23c7d51a0dd55eb5857d0e80437005ed13689bd93b66d5b5d81c4552daf53  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008
b507427c71db9fae57e0a12b3e743c7e0a457cbb3b7c74dab9dcdbed2380af82  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344
d48b0aa040fcb14cbafdf9f1dfc9dc3882e3ea8d617a0e88b42e5b3f55907a27  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344
74e49ac3ca2fbedd76ffd3d35fe61b40daf66623fd4a14bd3ecc28462d915c03  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680
e5ad852b4640fd36e603f9becf5913ec8153035d23516dc6f562587983c5c34c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680
00a8d251d0ea5692196662aacd7b3e71dd68dbcc2d8bf07780d163a3ca969e46  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016
d73ac97254a69dd6539d16f57f473a52c4d766dcb6443ea6e16c3b49abcd72b3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016
b9856771d7b3dd5a5d0daac0c60ee02064298fe6726fd0d6681b8258364b54ae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352
c4c0601581fc9514f72811cb3f416ec76675834e2010abcc2e88dda010e4b672  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352
a7cd2398e491bd3b9aa0ba259281acdcffa0a414f12cdaaa52e89f176430a626  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688
ec2b5e275f9d539b26fa8cc0f31a0a833fc29049c02f565a1754aed4dbeeb815  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688
3fd5890865108f72c24d0b27bf8d9978768b5f298d6d0c7c4f571ce7e70f642b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024
61685020655b0f8bfe4cb77e039bde7b41de03c0b319282d59d33607fd01cc13  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024
9447a16895bb6cdb57da40bc01b12a404acfc779c2d610e6f812b3e466a7715f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360
cdd74430688d35d47b6fcf62d2344ade0919b2c0802110d19f1b172530f969f4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360
1b79e96268c31cfbfc571133ff589b756978fabda207aa4b94f172a807b9cc21  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696
e7423b826ce141621148f86fba60410060b9b1be6483246369cdc6a7eae017d2  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696
BUSTER421_QUALIFIED_IMAGES
cp --reflink=never '/home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-000'
cmp '/home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-000'
sha256sum '/home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-000' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-000' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-001'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-001'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-001' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-001' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-002'
cmp '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-002'
sha256sum '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-002' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-421-integrated-base-74da/build/compiler' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-002' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-003'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-003'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-003' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-003' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-004'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-004'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-004' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-004' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-005'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-005'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-005' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-005' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-006'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-006'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-006' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-006' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-007'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-007'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-007' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-007' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-008'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-008'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-008' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-672' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-008' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-009'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-009'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-009' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-009' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-010'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-010'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-010' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-010' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-011'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-011'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-011' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1008' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-011' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-012'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-012'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-012' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-012' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-013'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-013'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-013' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-013' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-014'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-014'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-014' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-014' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-015'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-015'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-015' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-015' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-016'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-016'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-016' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-016' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-017'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-017'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-017' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-1680' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-017' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-018'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-018'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-018' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-018' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-019'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-019'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-019' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-019' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-020'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-020'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-020' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2016' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-020' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-021'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-021'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-021' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-021' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-022'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-022'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-022' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-022' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-023'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-023'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-023' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-023' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-024'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-024'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-024' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-024' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-025'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-025'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-025' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-025' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-026'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-026'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-026' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-2688' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-026' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-027'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-027'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-027' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-027' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-028'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-028'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-028' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-028' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-029'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-029'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-029' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3024' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-029' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-030'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-030'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-030' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-030' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-031'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-031'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-031' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-031' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-032'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-032'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-032' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-032' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-033'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-033'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-033' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-033' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-034'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-034'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-034' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-034' >> "$d/image-inodes.txt"
cp --reflink=never '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-035'
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-035'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-035' >> "$d/image-identities.sha256"
stat -c '%d %i %s %n' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/integrated-base-checker-placements/compiler-3696' '/tmp/buster421-fixup-register-full-r2-after30-f0-b00/bin-035' >> "$d/image-inodes.txt"
cp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/fixup-register-full-r2-after30-f0-b00.list' "$d/commands.list"
cd '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence'
set +e
'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/procbench-24f54c2' --rounds 1 --first 2 --out "$d" "$d/commands.list" > "$d/processes.tsv" 2> "$d/harness.err"
status=$?
printf '%s
' "$status" > "$d/exit.txt"
tar -cf - -C "$d" .
archive_status=$?
if [ "$status" -ne 0 ]; then exit "$status"; else exit "$archive_status"; fi
