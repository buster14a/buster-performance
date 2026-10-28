set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
603b34f2ff20bc5ac3ae31f08d9d2f626a6126db931c4fae76300e0573fb9169  /home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler
e57e8e26275ba5d7eb1416be05ac7aec681eb977542b321c9a94dbab7f13be62  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336
40fc910327680a0dc58b923f97533264d10c6258b7f25a9348b8f464a4938ab9  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672
f70e2f801e1b6fffea9cc51741e95e11533b4a5e0e9047a1b325b8acf8c12da8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008
bdc1cbdd6f438d97abbb53177cce4ef73dcff6538a40cfa8ca277567b656bd85  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344
9ed0b9d45f71b1c983f4028bef1e6c2a92589e225ba8bc8826ca1a671e177f26  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680
bd7c1e432f203f400e498545c105951f887641e5345c82f87e9b043364688aae  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016
306ccd8f28a7d39771efc08a9d56efc689242b74bb291e37e27c2f6c1ee2eb0a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352
78c7a7c889b6ef957b3ff46ced696b1be27fcfcc55b1c5767066de2d10bc1e7c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688
706ea0dc9c5df19eb64e5a50363f3809c32da982f72be51a2e267c5caeffa131  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024
2c54edbf0689e9e5020e87a91cf8c334c1fbe743513be312e45e03780ebfe5d3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360
eb3ab855026b820b5dccc38036cc9665da07abec8b7575d18fed358101638a0c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-test-homes/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-test-homes-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
