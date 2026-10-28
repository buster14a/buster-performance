set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_REG_CENSUS_PINS'
b6a0c07311bfd18959478ba05a96aea9b03e969388e51bb81d9149d6e5ae4b7d  /home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler
f0c6a011cab1a30d5a49e06ca32797bd110b876017c12518700461993716d939  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336
3e58395584298b96384b524adfd0aa15b4f1a1c69a7fbbe47943cf5c4a254afe  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672
5a0fdb26abe0be9aee3a43f55fe7269b182a2d8679d72cd3a3a771541c1a1b5c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008
d48b0aa040fcb14cbafdf9f1dfc9dc3882e3ea8d617a0e88b42e5b3f55907a27  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344
e5ad852b4640fd36e603f9becf5913ec8153035d23516dc6f562587983c5c34c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680
00a8d251d0ea5692196662aacd7b3e71dd68dbcc2d8bf07780d163a3ca969e46  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016
c4c0601581fc9514f72811cb3f416ec76675834e2010abcc2e88dda010e4b672  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352
ec2b5e275f9d539b26fa8cc0f31a0a833fc29049c02f565a1754aed4dbeeb815  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688
3fd5890865108f72c24d0b27bf8d9978768b5f298d6d0c7c4f571ce7e70f642b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024
cdd74430688d35d47b6fcf62d2344ade0919b2c0802110d19f1b172530f969f4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360
e7423b826ce141621148f86fba60410060b9b1be6483246369cdc6a7eae017d2  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696
BUSTER421_REG_CENSUS_PINS
printf 'image	%s	%s	%s
' 'candidate' 0 '/home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-fixup-register/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-fixup-register-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
