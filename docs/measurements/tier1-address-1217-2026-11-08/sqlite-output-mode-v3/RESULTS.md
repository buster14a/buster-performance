V3 completed all 42 checks (six warm-ups and 36 measured observations) on the historical 846/b48 compilers. This is executor recomputation; independent review and root acceptance are separate records.

The reused-output head median elapsed was 21.5781% above base; the fresh-output difference was +0.1020%. Every reused head publication shrank 2333400 to 2331800 bytes. Binary and shrink-transition effects are coupled, so this does not identify an I/O cause.

| Output mode | Base wall median ms | Head wall median ms | Head/base | Base-again/base |
|---|---:|---:|---:|---:|
| reused | 112.919141 | 137.284960 | 1.215781123 | 0.997563252 |
| fresh | 112.741013 | 112.856063 | 1.001020480 | 0.999950497 |

| Output mode | User time H/B | User cycles H/B | Instructions H/B | Task-clock H/B |
|---|---:|---:|---:|---:|
| reused | 0.994153775 | 1.000635806 | 1.000015596 | 0.998556105 |
| fresh | 1.017173615 | 0.997906059 | 1.000015608 | 1.000964875 |

The six round-matched wall ratios are retained individually:

| Mode | Round | Head/base | Base-again/base |
|---|---:|---:|---:|
| reused | 1 | 1.279235562 | 0.997116270 |
| reused | 2 | 1.166446863 | 1.001054115 |
| reused | 3 | 1.168527890 | 0.995900979 |
| reused | 4 | 1.284404352 | 1.054087099 |
| reused | 5 | 1.213340331 | 0.991806870 |
| reused | 6 | 1.215729820 | 0.941678728 |
| fresh | 1 | 1.004233965 | 1.001169648 |
| fresh | 2 | 0.965237067 | 0.965623854 |
| fresh | 3 | 1.002979522 | 1.002228196 |
| fresh | 4 | 0.947909843 | 0.996482393 |
| fresh | 5 | 0.997835877 | 0.991063860 |
| fresh | 6 | 1.028086094 | 1.023268601 |

Ratios above use medians of six raw values per mode/role; paired rows compare the same round. Warm-ups are excluded. User/system medians and all seven software/hardware counters, ranges, zero-denominator cases and individual values are in recomputed-summary.json, paired-ratios.tsv and individual-observations.tsv. Repeat-base ranges are observed controls, not confidence intervals.

All 42 guard/process checks passed, with no interruption or retained descendants. All 588 raw rows reconcile by event/family/value and exact positive enabled==running; all 294 normal summaries pass. All 42 mixed stderr files exactly match the 4451-byte reviewed perf fixture, and mixed stdout is empty. This is byte identity of a combined stream, not a broad separate compiler-quietness claim.

All 84 CPU2 policy snapshots show performance governor/EPP, sibling list 2/core 2/package 0; all 42 preceding affinity probes show 2. Snapshots do not prove policy continuity inside each timing. Seven reused grows, seven shrinks, seven writes of equal size and 21 fresh creates passed the state/reference gates. Earlier reused bytes were overwritten; contemporaneous state/hash/reference comparisons remain, alongside 21 fresh objects, two reference objects and final reused head bytes.

No failed attempt1 object, timing, warm-up or per-compiler reference was reused. Only its explicitly approved formatter byte fixture was adopted. No trace/profile/candidate or new Buster build ran. These command-wall measurements are separate from CI release-to-wait4 and do not qualify later main or satisfy formal issue acceptance.
