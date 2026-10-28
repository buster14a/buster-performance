set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
3cdc95ffcd0c6eb46d323b89055948d1f1fe2e6c1508cccbe3e98d0cb2102b0e  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-short-tail/build/compiler
f1a3b94e31a14e9c8c07fa174c3f60153d98d673c70d19dbc09015afacfb583f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-336
38b0778f19f3fff70b1cee16f318195d0cb476f0b8ed24c0bbe31b6708ced1c4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-672
e8dc94e4877e29951d0250973843e799dbb8d0e87f7618439e578d9c810c7f0a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1008
4c627aedeebb69352e64d6dba837713a30248b09aca073932683a486f80f22fb  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1344
1e1f70988bbf3a76ae30c52dec32aaf15c91e29e109820df04e108ceceac3b0c  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1680
0d0e5986a559d673019d22db451d124633982d334d193ee0f33c2e6af1fd94d3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2016
df63f490f225475c941f6ca8601a25eedfb65a2d107e3f57834f7a4dae4047ce  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2352
b51925c2f8d6a06e319b3e03ce1771247d7d023f301a93acf24ba3e617307b2d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2688
9246a2ebfaa80cdcfda464639d0bd5d8c5ca9ddfdf40ee0844b662db7858c223  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3024
ea18c726c5ee086d46ee676832b9c0c6cca8f6b5cc5f77f7a04e4fb3cd2b905b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3360
e27b9d25e747bfda923d58eb153b3c4d32d42925ea2db05141ca0f97e02e56f1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-short-tail/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-short-tail/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-short-tail-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
