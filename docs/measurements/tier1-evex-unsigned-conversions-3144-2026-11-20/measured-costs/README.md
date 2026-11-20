# Measured Zen 5 unsigned qword conversion costs

PR #3144 at `60f281c77c0bbfe16706ffef8a373deff19e3e0d` contains direct measurements for the register forms of VCVTUSI2SS and VCVTUSI2SD. Four observations per form agreed on every required column and pipe classification. The [eight observations](calibration/) and [column comparisons](analysis/independent-checks.tsv) include the original data, the produced rows and six independent repeats.

All 25 configurations repeated 1,361,920 exact result and MXCSR checks. The 23 identical objects and the two changed AVX-512-capable post-scheduled objects appear in the [object ledger](object-recheck.tsv). Both differences reorder the same instructions; the [assembly comparisons](schedules/) show the conversion and independent load changing places. The 1,336 default-scheduled [musl objects](musl-objects.tsv.gz) were byte-identical. The [compiler suites](suites/) include 2,009 operand cases and 26,971 generated measurement programs.
