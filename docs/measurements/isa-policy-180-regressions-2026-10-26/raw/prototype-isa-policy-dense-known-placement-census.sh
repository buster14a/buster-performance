set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
8ec68d22539c65123fcb539faff0cd5eb649ac4bf75d4ef1322ebd06600d89b1  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-known/build/compiler
bd4b94ee265c76861dc22f7f5c12c8d4936d096fdcdd384419c0728223414bb4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-336
d70a521238229f94f078cbe7a458ceed7b1ea92fa738714ecc30b9e99424bc75  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-672
58b65b9fe7da00d325b2e56678751ef90fe1e0e735a766be31eb24379a30ff0d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1008
d88672e698848e0e6c463fc415089ac9cedc2875ca09041f34e56d5fb7e35796  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1344
f1cfa75e364b5ffe8c6bc4d53ad0542b51d03a2c1268e7220e9a57d903cccc8c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1680
640a13f660df792826f98907b2a891ca76393e83dcde154c0c55b3d7adc4d9b1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2016
2e7a230b3db65e2de26ab72bba813d56689231d5a25b82adb802b819dcee6549  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2352
38b71d915cb85cfba9a56fd7a2b91e5ddbb599ac7fb58136115b60faed14da6c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2688
1f96c99a96a73af0d9ddf3e332faf7df24b90e74e97b4bc51ed46c4348939376  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3024
fe9ddac7fce17ea97452621cb3963ef8ecb58b69394791d8efd3d8ea8b912ce2  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3360
cb25fbf2b2a657c5a0a6464a48c8c10e8752c713619035e2dc154e0869b5e4d3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-known/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-known/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-known-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
