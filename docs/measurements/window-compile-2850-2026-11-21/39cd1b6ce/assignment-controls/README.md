# Isolating assignment discovery and retained rows on frozen SQLite

Five diagnostic modes share one executable (b7686d7d2e096775ad6dd20fd46315102d7a290a). Two unchanged public releases provide external controls. In the diagnostic executable, narrow filtering retired a median 672,702 fewer user instructions than the legacy filter when both took assignments. The cycle change was −2.03348 cycles/token, with a seven-round range of −5.53664 to +2.19921. The instruction savings held in each round.

| Configuration | Expressions taken | Cycles/token | User instructions |
| --- | ---: | ---: | ---: |
| Public 227853575, reads | 2,214 | 933.0384 | 1,340,753,056 |
| Public 39cd1b6ce, assignments | 2,977 | 936.4416 | 1,340,045,344.5 |
| Diagnostic, retained rows and returns only | 2,214 | 933.4180 | 1,341,239,612.5 |
| Legacy filter, discover then ordinary graph replay | 2,214 | 938.1221 | 1,343,322,080 |
| Legacy filter, take assignments | 2,977 | 936.6508 | 1,339,991,872 |
| Narrow filter, discover then ordinary graph replay | 2,214 | 936.4209 | 1,342,651,355 |
| Narrow filter, take assignments | 2,977 | 934.5889 | 1,339,319,172.5 |

| Difference within diagnostic executable | Cycles/token, median [min, max] | User instructions, median [min, max] |
| --- | ---: | ---: |
| Legacy discovery/replay minus retained-only | +5.66964 [−5.34971, +8.80359] | +2,082,616 [+2,081,490, +2,083,510.5] |
| Legacy take minus legacy discovery/replay | −2.87912 [−5.57079, +0.37973] | −3,330,207 [−3,331,258, −3,329,223.5] |
| Narrow discovery/replay minus retained-only | +4.58044 [−7.84429, +15.86246] | +1,411,753 [+1,411,440, +1,412,669.5] |
| Narrow take minus narrow discovery/replay | −1.89239 [−15.72463, +2.68439] | −3,332,169 [−3,334,195.5, −3,331,065.5] |
| Narrow take minus legacy take | −2.03348 [−5.53664, +2.19921] | −672,701.5 [−673,762, −672,621] |

The discovery/replay modes select syntactic candidates and then replay the ordinary graph. With publication disabled, the compiler can drop side-effect-free final type checks. The measured differences capture these execution paths as compiled.

The retained-only executable used +486,545.5 user instructions versus public reads, with +1.88860 cycles/token (−14.33469 to +14.40097). Narrow take used −726,170 instructions and −3.12833 cycles/token (−34.09530 to −0.66743) versus public assignments. These cross-image comparisons include code layout and other binary differences. In the common-image comparisons, the costs of discovery and the work avoided when a row is taken are visible in the retired instruction counts. Every same-image cycle range spans zero.

Each seven-label round ran a rotated palindrome of 14 positions, assigning two timed compiles to every mode. All 98 PMU compiles reported 100% event time and fell in the low-fault band (5,665–5,674 faults per process). Seven separate stage compiles checked admissions and object SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. All modes took either 2,214 expressions (321,355 graph nodes) or 2,977 (319,066 graph nodes). The extra diagnostic executable has SHA-256 0a385fecbd44c83a64dc4585b07f52508abff1b8d2363a6504428b94c95c13b2. The patch reproduces its source from public 39cd1b6ce77f2289a56ec0d1de2f5044e1607979.

[Order](order.tsv) · [Event samples](pmu.tsv) · [Original PMU and stage reports](process-counters.tar.xz) · [Diagnostic source patch](source.patch) · [Exact flag selection](assign-control-b76-one.sh)

An independent GDB census observed 466,925 acted tokens and 55,955 terminators across 700 actual chunks. The legacy filter proposed 18,906 ends, while the four-action filter proposed 3,312 (82.48% fewer). Of the latter, 3,022 also had the exact token order. Both admitted the same 763 additional assignments. [Debugger probe](scan-census.gdb) · [Observed counts](scan-counts.txt)
