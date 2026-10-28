set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
e25339660c40dfd4912a636307e001e660acd5e0be68056d3af39a40f3f6ca8f  /home/david/buster-fast-bench/codex-421-prototype-isa-only-current/build/compiler
da05a9f6a640326ee9459b3edc343acebfb831a59fef462a86dd2d1984272c1d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-336
38e92fc8d2d74f95af4b8fe05e1812757af01e163196343b229034d0c46b5a94  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-672
1b13393324c2ac666ff93a37e58c3ff882af59e4c94410df9daf1487185b46e6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1008
07a3bf3862a32d2631975ffb6027c1d1ea975e9da9aa5a11032b58617491910f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1344
8257e369deeb8385e6943cd021a7a5876ff9f4815715a0b65a550d020d7ce736  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1680
8fd465e1e31bcde2833c91f52dd319874c89598f4b5747fc9757ba3fdf190680  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2016
23ea8fab8910a0237b71a35ba7ef55f79233629215d80191621653b8a1a11052  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2352
86c04ecfe7e35bfb1e5413fa7690d0e65fcc4182bf5dd8fa1860af8125169dc6  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2688
4df3bc6a91b1fad00e714ecafee5dd76d1e88334ce743a827feacb245e082ee0  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3024
d99917bb0b400a3fcb72d64329213c5e81973a740ccd00bf7a61b172a0228194  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3360
e78b71a3a55b144f2bf03d71ec65ad7a6a45829c849577ffac7559e314ad0e56  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-only-current/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-only-current/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
