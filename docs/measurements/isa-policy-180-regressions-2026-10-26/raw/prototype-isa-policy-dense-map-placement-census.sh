set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
75453a4536cc464c7c6d025e918fa67ce166ab4e5fc4645486b0b77f519fb505  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler
f26bfcca60a021b42bd7bae133b82a958885aebe58d3cafb82f94025d5809201  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336
12af2e5454a22cf8e6a2d933840f1d278a2a756a9a54249eea4b17931ce98b7c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672
d24bf45af63e8d50e4ab770dbf9bad6047dea914dcb893ec662641b2005dff48  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008
18ef15e31a5e9b400a35050a7864de3b545c9e250c74ec9a6a011bad1f7a1851  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344
cbd1feacaf9ea390ff13b0bede86936c5ecce8e2f3b3db4e526e45d1b6cf9df0  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680
8cde9b303ce13e62cbfd5c6001588953e1792c780cf0e8dd822ec8c8ecd67574  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016
91cd2c5f48856abdbc784b6a0c3f630a4cc21abd2cd6a65d6797648d547a09c0  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352
3e670f7b6d3dc98f3b70e80a14aff35b1b1fe301596cd04c77507c4c5e63312e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688
bbd0de033b3a5edadd7af337436ee880f2b0c6f12c59c4faa15296a9317fd147  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024
026f1a411fa565888a4cf68be4c42ac5eeb9146889175c9c2e84305aca52e78f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360
e9367ffad949d214b3280592c37ffa2bafe9e6a92309dab3ae6eb5e563a95dd5  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-map/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-map-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
