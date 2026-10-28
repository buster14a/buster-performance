set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
0d23c9f5b43ee5fcba8c9ec7759c32b8b4256102af22a127757bda30935a8ccf  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler
bc0ec5ec075c5e4407c96764f4a71e78abeec95bfcef862ebf153f384718a10a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336
68cc6f73944b978fa85c527b0dea3376bc2e2d2153282afe217c68202eed67f8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672
e60c5258224ace0ee9752330a692a7bd17af36294f1d17b564fd592d18dea926  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008
aa95e398da1f6b667e8129a39c0ee4c95beb3d2b4a06282222a6de97395b8fcd  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344
911ff026bc22a3ca20ce78f2cfabc3b236a4ae1319afc93846ca3ba31e14cf4e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680
2f345b8a5d5eb9928f2682bc5fa8aa208fb348ef86604af1965f758049b90ff9  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016
1e8c59fccd94691af22747875b1932471273ef928d64eb8017c459c17cedd05f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352
1f5d5f0e87b27a3de3f0203ac74fcb32142a453f4c8ec9161e37680dca456ce6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688
a151fa98278db7e471384c2a718d4103eb1f6f4ebfccd2bec8589c81e10f0b79  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024
d01e1b3ae2e084fdb2346a57214b06eff8c4bcf83a7cb68269925f198124384e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360
dcd98cdd7972af17281d0741969e866fb9a2be2ba451e0415647da6ecc1dd025  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-known-bit/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-known-bit-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
