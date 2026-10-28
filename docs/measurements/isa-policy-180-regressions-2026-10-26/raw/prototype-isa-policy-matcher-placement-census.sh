set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
f4395f1d2dad99852f29cfa4e0b8072f8767ed8b18134ff027c32365bf781ee3  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-matcher/build/compiler
0ed536b1242608a9fb4dff7b473d1d1f89d027b3e6ceca5902a2f72bcd940393  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-336
a46ea215d68b74273801534f531bc9fd6150a79bcff74b02597a7d129c7b4ebc  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-672
906cbc4a65fed9b08c02e26d47f4b45f90b70d3fac41a76e086b378a3a579203  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1008
923c8d6c250300d58ff39d4fd6267efe026c109b125ef42eda404fba393ff22e  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1344
08f23901975568cff1aa341c8e0737048934c0a47dca1a7449479f4c4d715548  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1680
c7bf6b568b85c43679446f9b7ebdb017c593f561cbaf55409555f2a7c48245a1  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2016
977ccdff396ea2d470914a742d5e17d143727723cd480a39897787c1165e8340  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2352
6b54b6e2be4896a36d33a8cd60f6c05ff0bfe42da52ee1d1fef696e0a79ba3f3  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2688
63d897a257b3aab2c633940b85c56e83524edbb18b956d9e84d66d74f8bd3491  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3024
aa3134c6490e6459e39342e857878ec4b0746c77a2bd34aeec5fe2faa7bd8224  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3360
38e3af7be78936557909b8a805f6cc09bbfda9263e7610acba6f471c34f3784d  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-matcher/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-matcher/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-matcher-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
