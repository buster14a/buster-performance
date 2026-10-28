set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_MAIN_VECTOR_PINS'
c3001cc8e0d66718d08172147219beebe4f4e8ef0838ed425d255410f0d5be04  /home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler
c8f67fb445e3eebba10e94db11d11bdbb58989e0cdd7b268e6e55a76cd1b0693  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336
c1b005986fa7721b359523f44ba33f6fa9cbef3e351de495764d5da4cea0e748  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672
785509957e95029caed12a63f895eb5433ec2fa6ae49e75cc42a714bff9bfb63  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008
c42ef8d686fddc8cb63a18d57fd5637928d6757d1190a6fd51d5b9e4cbe77580  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344
82de527e3aa6c2667e45fa142a67561a1d04077285b6383ceb429c724c1243d4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680
d966d6e1d65a63fe9de905eb78f252d9a0dc0adb2c0c7717234ba78beb19cbb3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016
b1a6cc9dd363c1f7a420b8410d20f1a3cc6e84cd87b74dc6b29ad07d6303d3ca  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352
e13332b8ef959dfb5268a87a9e9eb90bd4f2039fe94bb58c84d846b7b15e8409  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688
eb3b0e09f1662e7a799a5396e48e147a05b227505962f09c6dc1f434c3b2b36e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024
c5c76daca57f42b3fbf9d15614b5ce7d716df488b21d95e8081650f92fcd6a0b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360
ea9cc98b45f7a9e2c3d37b253df03cd17b702c45ef16ce73bcdc68b66110103a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696
BUSTER421_MAIN_VECTOR_PINS
printf 'image	%s	%s	%s
' 'candidate' 0 '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-main-vector/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-main-vector-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
