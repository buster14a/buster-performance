# Measured Zen 5 scheduler costs for signed conversion and FMA memory operands

The [48 raw experiments](calibration/) use the AMD Ryzen 7 9700X, CPUID 00b40f40, with 10,000 loop iterations and seven counter passes per observation. Twelve distinct instruction and addressing-mode pairs were measured four times. Each independent repetition reproduced its first measurement under the compiler’s comparison rule. All pipe classifications also agreed. The [per-form comparisons](analysis/independent-checks.tsv) include the measured, derived and architecturally absent column masks. The [selected rows](analysis/round-zero-rows.txt) are fixed-point values in units of 1/256.

The four indexed integer-to-floating conversions belong to [#3120](https://github.com/buster14a/buster/pull/3120). The eight base and indexed FMA factor forms belong to [#3122](https://github.com/buster14a/buster/pull/3122). Each PR checks cost coverage on emitted machine records for each operand width and addressing mode, with the base and 1, 2, 4 and 8 scale factors.

Local emitted-code checks retain the original scheduled and unscheduled leaves and the previously timed kernel object hashes. The [9700X comparison script](stage/confirm-float-costs.sh) uses short nonblocking leases and alternates form order across rounds. The original four calibrated samples per form were taken from a compiler with unfilled trial rows. The production checks below use --check with the measured rows compiled into the corresponding PR heads.

The [production convert runs](convert/production-checks/) passed 8 independent checks on the 9700X.

The [production fma runs](fma/production-checks/) passed 16 independent checks on the 9700X.
