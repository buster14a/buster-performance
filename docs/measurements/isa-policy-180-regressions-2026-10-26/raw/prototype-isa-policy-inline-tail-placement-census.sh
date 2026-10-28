set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
0d7d81a1eae60d516e5b9416e5d9cce80905d4cc85bbab44702af3835c7e344d  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail/build/compiler
83d3c07ca1b37a0729749860ca9eac0adaf310e91f99b7cd2110fee4e7891dbc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-336
6db406ba3873a5aa3b247bef747981c1f5e528309bd2339d1d0237b4cf29260d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-672
8bf5ffb9fa4f1c028ed6188cb623aed4762ff90ccabc97e75e90060b7a5656e1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1008
17ee054fc656603ce2c47c92299e4d88558bf8ed95b445a88fe27cb58e6ab536  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1344
9083a8b01d4b4133aad6c01ca454aeb648327dbb0abfef4cef19f5f282225d47  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1680
7592ea4a465762a3b66abfa16e3b170e96759245eec0bb18b821d114a441574c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2016
e9a697828b2508be46aefac447f5b01c8fcc8fd9a4582f28c253320640b1f368  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2352
619bade38a25afd2ec3e1020120c93c76fdc6e3db2051ec467466ac1f46e89f6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2688
e5b34407ab1bd20b72dce5b9fb430267cbcd8b6432f86635606f0372ec57a0fe  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3024
c08a7681068c59bd08e03ff6ba80fc8714b8dda7a08da426416ddcfc0984afeb  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3360
4ef889592ad041a91719995d4d36227dd5e3a0dcf460680eb3be5c5618c9d09e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-inline-tail/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-inline-tail-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
