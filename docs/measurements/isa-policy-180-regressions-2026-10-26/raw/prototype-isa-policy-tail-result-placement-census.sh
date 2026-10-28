set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
2e5158923d371851d3b1a59d00269a7e9b9893154f2c1a8e142fca6188ace802  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler
cda59a126a1dffbec9e00ba8e3709c825f8bb3cdc052166d165e5d591ede4781  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336
2fff71986b6cf6432f0c747bdc35d97374fa4e7d896aa7e657e577e588718508  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672
5a9ace2c182d62ddae594c1d5b5156d06552ac4c1bedefffd0acc793a27b3c1b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008
97095e829b483f81e9246ec198f8a034d69ecb8aeef51f123644fc5625ccac24  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1344
508c4b6d71f5b6cfa32b8e5d9a83c4ef5d7746bd6c97dba37d2b3ad73f5c658a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1680
aa62567a35bcefe5984cb2cd1dfa7e819af1cfe07ad8adc0faa9a7f1b7ec30bb  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2016
bd24f091f05b2ec89725a8be3add2ed938980c8960392bda6f2b19a3ef250631  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2352
c8c737f459bc8957888c675e1291221bbde171d338912ee3fc521515e30e355e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2688
629a8a501c28b8218b1c67ddf13c00e299a7119b4ebcb1acdacfca28f81f7f30  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3024
7a3f84aec7a67dff5715c69b15a3759a6cf9217d413e609223e04a2472750298  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3360
5d6bc080b10cd02318f245d3ead7271b8cb764b9e287353fe5c7465054f713c5  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-tail-result/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-tail-result-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
