set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
c8e4ffd91f9e4cb8d2fc207db419c8916e0708ae0a7cce911f6cc16c1a88b3e4  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler
e377ba633adbafdffecec75ddfcc211035c180ce766586273792e32b920d3040  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336
ea8a6bd8d1a508d40d3f7bcde0cb959799f148ea3461b3b57fb828d422afcb6a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672
d73e7b0b6908d7821c49a020094c45943e8732b979901ab93c0dbe39bedaf4e3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008
28a34bc65e5f248b26c02a4337b3be414df2b00a57cddd9e35fbe56614738afd  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344
269428430c66a5700a1581bd739cd83d6cd0ae98c803d2ed397bd7d661b15545  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680
9e8973c76d8eacea939e3cbf5d033177776ce9a3330b23322ba8cb8cf745284a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016
5386fbbbfc288bf1c861d63c4e4ff87b3f5c06c4a0c0d3eec3144ad9a4af4722  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352
77e1a5cd12eeaa5ef5a5aa31b1e7d74f15d0fd497123aba716bcd2256c71d4b1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688
b04dff093083b6a32441f90969729232e30246bece054f6fd2d691ec134d7023  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024
fb4f36afca3d0f08e5ef9a6cfe8b324ff93a831e1273298ab85b98cb2c09dbe0  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360
711ddb0f1acdba112cfbb7320de8feef0008a0493f11de0532234aec93ba23a9  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-main1c6/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-main1c6-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
