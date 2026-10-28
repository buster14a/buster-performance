set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_MAIN_VECTOR_PINS'
728d79e73b5b82e4ab9a84fae13295b674f70756237f1a4a75e74c9bddc21950  /home/david/buster-fast-bench/codex-421-prototype-private-catalogue-checked/build/compiler
c8c2aca860fbf2c767826b71ba28a6426f2631e9d633920e9671866619461545  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-336
f77b09b62fc81b74c81722431a416cc053829cb2505bfa8d67831c4c0bb54c99  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-672
47b709376bd312bdd9608f12b90b20c986a99a3078928832767df8ad3ff63318  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1008
2dc65273333ea0b0342be74e661a2cd39d5ab231c31d0d15fd2aaef4b55cf459  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1344
395540b9799e6079de19aeb7bf81729f66f631b8b386e8b392951a361a5ea877  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1680
4731eca074c74723509279e46a33698d5f55c0e80e828575790d77d6cdffd109  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2016
a935eba44d90fc94d71d6b598b2fc27bbb0c718e8855665ee237f835bda732e8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2352
c37d637ef22cc5abc6a8bc4f5b2f774428acff4c234be0fffd75e04571265557  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2688
a0541ca10698efc720d2b4fa297526849c8ff21040610f6753545e94004bbf45  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3024
75f5b9aa579bb168c4ae7b5812eca22d5aea3896d8345c0ab31435eb920b7ea1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3360
68f5c6befa5093bcebf50c3237c36a3951b6d07286defeb19d5d5832c1f9fcbb  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3696
BUSTER421_MAIN_VECTOR_PINS
printf 'image	%s	%s	%s
' 'candidate' 0 '/home/david/buster-fast-bench/codex-421-prototype-private-catalogue-checked/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-private-catalogue-checked/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image	%s	%s	%s
' 'candidate' 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-private-catalogue-checked-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
