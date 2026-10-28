set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
25e0ae7158270c5725dd278bfec252452354e59d67a52b745b339952f58f6efa  /home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler
c4427e9165adc1ad8ccf332b3e598890c5917c4766fc377854810373c971014d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336
78257599a66463b1f1d00d7e264a5c99d63910c24d22785d42a739683cbbddec  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672
02285aaed64a5204bcf04e4d523667e6c6c6626d7ad915ad915ef3bb20f175c4  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008
10aa8103d42bd093e31f03aa6b43f553bf2de8f4fb2eab0df93ec56885c288b8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344
ac736ec6a505fa3eaa7083f470a16701bbbc9ba366a90fc3cc41ba37a12c0c96  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680
7c188b026b3bb5b2dbad4b7feb1c7ce2524773c26c0f9bfb6635867922c3d595  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016
bfe5c4273d507e035fb94759076a9228831f7c3a10ae44f96596420f41eb19db  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352
064a052e2e8de850f20b258e9fd93a2c299a76d275ed66a66c371c26134ff48a  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688
c8a57aa4d4d9ceb0ba3c363ec53caec1372629cd05e0d23e20cd3428ab837f33  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024
f6981319ba1d13f43881f39c770f073db01ee138cd639ab2d9f14d9a0a7b418f  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360
91d1068e500f1b2b5b4bfa9438686c74ab47edfebb3e9ee0215581238777cdb5  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-base-main1c6/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-base-main1c6-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
