set -e
set -o pipefail
sha256sum -c - >&2 <<'BUSTER421_CURRENT92_IMAGES'
26d9645e717bcc383b97d053399e87ec7b9ba620aca9119f46ba75233749a0e1  /home/david/buster-fast-bench/codex-421-prototype-isa-policy-scalar-only/build/compiler
ca6822a0319a409c2a663fec2dda15c4e95acd12f4e750b819981b517eead4f0  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-336
35d38db6888c39946e821122e14cefc2b5c3f80a398d31861d4cd7e2c4054d5b  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-672
70edf32246297fc60af0ff2ca7e354353c8ce34bd98642ba34c650d7ed1707e8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1008
255342fa0a9413f59773c3fb7b38660e8ebb9613bf511167a571c0ebfe609c20  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1344
225a91f484d240d198780eeb4878cd31004c6c1b9bedefccdfa4c422e3f09342  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1680
c661392ef37577db7ec99f41f351cac50f672f7ec5f10dab18180f17531cacf8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2016
cd1aa29709d9d7627d2a673dbd67ec0591665b3642713715f49e149e3cca9ac2  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2352
75aaf96e3b3def89efd43d3fc9246a72bdc45feff244d9acc6e22969fca358ff  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2688
5edc1ecb72fe47c488a4cca6b5b0c613ecd3a9eb4ec0b14d91a3c50f40de70bb  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3024
b87f5bba8ad858410bb98e497ebce0be1f7826f97593eb15236b66661de9cea8  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3360
d6260b671ed06627a967a922b54000183d7cdc25b77f731ac6e272cbf322b948  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3696
BUSTER421_CURRENT92_IMAGES
printf 'image\t%s\t%s\t%s\n' candidate 0 '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-scalar-only/build/compiler'
readelf -sW '/home/david/buster-fast-bench/codex-421-prototype-isa-policy-scalar-only/build/compiler' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 336 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-336'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-336' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 672 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-672'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-672' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1008 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1008'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1008' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1344 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1344'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1344' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 1680 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1680'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-1680' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2016 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2016'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2016' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2352 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2352'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2352' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 2688 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2688'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-2688' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3024 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3024'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3024' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3360 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3360'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3360' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
printf 'image\t%s\t%s\t%s\n' candidate 3696 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3696'
readelf -sW '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-scalar-only-checker-placements/compiler-3696' | awk '$4 == "FILE" { file=$8 } $4 == "FUNC" && ($8 == "x86_encode_16" || $8 == "tier0_benchmark_run" || $8 == "c_check_program") { print file, $2, $3, $8 }'
