set -e
set -o pipefail
printf 'image	%s	%s	%s
' 'candidate' 0 '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-tail-color512/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
