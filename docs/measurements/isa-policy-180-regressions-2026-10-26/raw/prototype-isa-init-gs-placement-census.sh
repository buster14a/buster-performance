set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
3d1de0c13a13e47ca17dd3bad52555e492a7cb19116d2459ffa617bf8d0aeb75  /home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler
64765ea5481fe4cdc606ecb6557c20563c550a0ae749474fe161ec01c9542031  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336
7d8c545a04cbebc891b5e3b5ae3f771e6b92f56a4aa6d5888aea1a0960459966  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672
f5ca45d409918f3edc3cba46457c2b9f43371efb41a3ffb453d0f06cabde4588  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008
e67627ef18e839169ea229acd266f368933fec30f4cfc5fe8cb8d6d312c3d6be  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344
fe1d97374bb5c0c707a97042c061cdfedb197b05629c920cef3196493974f743  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680
994c9358cff3aef1f160b40cf8e231dd3f09ccbb66d5d1a165b615e8002dbeef  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016
2a86705e41fdb14c086e85f236a8c86c25b037cc13593513681dfca54bb3f3ca  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352
a1df56b239d261ffa386fe100d13ffa107dcf050afe29db279c77a1952045b35  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688
9adbdc6aed063f73844abbc7d12b0c8008def1ea4eafbded69d2ace332647c6b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024
695c9e2ffa63e1f266f29aeee0f87ad730c859fe18b56816979c58f2cbb47db8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360
8e8142446cb7c85ecc461a712f52dedb976344ec4647f35ce042aea5de507540  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-init-gs/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-init-gs-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
