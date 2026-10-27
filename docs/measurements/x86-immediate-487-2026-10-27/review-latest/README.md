# Latest-main integration qualification

Updated [Buster PR #561](https://github.com/buster14a/buster/pull/561) source:
`a7a4adf4469425cbc26a7a06119486a2af582515`.
Matched main baseline: `16226e01d59587fb26cbb6734b7b95982592f28b`.

This merge follows the compound-literal correction in
`03cb4d6441f1e0dc73af0c08047c86846e2ac502`. The new overlap was documentation:
the resolution preserves main's now-supported intrinsic `_Generic` controls
and the x86 range-diagnostic description. Main's updated intrinsic query
checker and checker text-section placement are integrated too. The x86
diagnostic walk, its 47 fixtures, program hook and driver reporter source files
are byte-identical to the reviewed correction. Their earlier qualification and
five-input screen are retained in [the review-fix record](../review-fe4daf9b/README.md).

## Exact-head checks

Locked Ryzen 7 9700X, Clang 23.1.1, the existing optimized build with
`BUSTER_DEBUG_INFO=0` and warnings as errors:

| Check | Result |
| --- | --- |
| Build | 41 sources, passed |
| `test-checker --seed 133` | 259,559 checks, 0 failures |
| `test-checker-driver --executable ./build/compiler` | 21,585 checks, 0 failures |
| `test-check-builtins-x86` | 5,607 checks, 0 failures |
| `test-checker-deferred` | 61 fixtures, 960 checks, 0 failures |
| `./build.sh check-call-graph` | 41 units, 23,838 functions, 142,611 calls, 0 unallowed cycles, 3 allowed cycles |

The four suites ran through `qualify.list` with a four-CPU budget and passed
in 18.5 s wall time. Build, qualification and call-graph logs are under `logs/`.
`head-source.sha256` and `logs/source-check.log` verify every tracked compiler
source/build file in the hardware checkout against this exact commit. The
zero-context `source.patch` applies to the pinned main with
`git apply --unidiff-zero`.

The local optimized build and all 47 direct source probes pass. The retained
negative control still shows the pre-review compiler accepting each of the
four live compound-literal cases, with the current compiler and Clang 23.1.4
rejecting all four. `negative-control.tsv` and its source, diagnostics and
binary hashes retain those results. The earlier local complete-suite run's
four known fpclassify oracle disagreements are retained in the review-fix
record; the current hardware suite passes in full.

## Matched cost method

`measure.sh` measures the current baseline and fixed compiler under one bounded
invocation of the existing `time-runs` tool on locked CPU 2. There are two
warmups, eleven measured rounds and three fresh executable copies per build,
with rotating order and two identical-main A/A tags. List 1 is the same 1,000
live compound literals with `-Wargument-outside-range` ignored that the review
record measures; list 2 is the same frozen SQLite source and headers. Both
compilers must accept the inputs. Each list/build has 33 measured process rows.

`summarize.c` selects list 1 or 2 and independently requires 33 zero-status
rows per build. Reproduce its analysis with:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror summarize.c -o summarize
./summarize 1 logs/cost-screen.log > compound-summary.tsv
./summarize 2 logs/cost-screen.log > sqlite-summary.tsv
```

The analysis tool was built locally. If running it on the approved measurement
host, take the normal shared lock per command. `measure.sh` takes that lock for
the complete bounded measurement itself. All source/binary/input identities,
host settings and tool versions are recorded in `logs/receipt.txt`; raw process
rows remain in the measurement log. Copies vary executable paths and do not
constitute a binary placement sweep.

Both independent summaries verify 33 zero-status measured rows per build/list
and no failed processes. The tool reports these wall-time results:

| Input | Main wall, ms | Fix wall, ms | Fix/main | A/A | Fix/main over copies |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1,000 live compound literals, range diagnostics ignored | 6.170 | 6.207 | +0.60% | -0.65% | -7.16% to +1.46% |
| Frozen SQLite | 128.192 | 127.472 | -0.56% | -0.08% | -0.81% to -0.24% |

The compound-literal baseline group has an 8.84% spread between copies; the
identical-main A/A control varies from -8.52% to +0.34% against it. That limits
the precision of this stress timing. The fixed stress case executes 65,102,884
median user instructions against main's 64,035,387, with peak RSS of
68,788–68,976 KiB against 66,784–66,904 KiB. SQLite executes 1,374,082,787
instructions against 1,373,272,699 and has overlapping resident-memory ranges
(596,264–596,516 KiB for the fix, 596,372–596,488 KiB for main).

These samples measure this pair of binaries and do not establish a general
performance gain or isolate code placement from semantic checking cost. The
separate review-fix screen retains its five workloads and timing variation.

Baseline executable SHA-256:
`59cf1c8e609a796f5834568ed972b55279f1b5c230d76cdc318664c5f5c0eb29`.
Fixed executable SHA-256:
`947b97b3a166f8cc664aaae4656df2fdfe990f3e61e9c261a92577711ad38629`.

These checks establish the stated driver regressions and cost screen only,
not full source-corpus, sanitizer or generated-program performance acceptance.
The repository's complete GitHub CI remains a separate qualification.
