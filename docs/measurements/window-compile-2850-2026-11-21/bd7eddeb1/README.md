# Source-ordered assignment and arithmetic in ordinary native compilation

Buster `bd7eddeb1ed3ef404e3d365b0785f51a60513a3c` runs the integer, predicate and assignment checker during normal graph validation, warning finalization, lowering and native object emission when `BUSTER_CHECK_ORDINARY_ACTION_ROWS=1` is set. All comparisons use the same input paths and compiler flags. The two timed arms use the same native Develop binary on one Ryzen 9 7940HS core. [Source diff](implementation.patch) and [earlier source-local arithmetic stage](../81a0b26ad/README.md).

The source, native-object, warning-policy and dump oracle recorded 0 differences in 110 directed or real-source comparisons. Each result records ordinary compiler exit status, standard output, diagnostic streams and ELF hash. Two further scopes on each frozen input compare the specialized checker’s whole-unit checked results to independent reference fingerprints. [Oracle outcomes](oracle/comparisons.tsv), [differences](oracle/failures.json), [raw streams and ordinary checker coverage](oracle/raw.tar.gz) and [directed C sources](cases.tar.gz).

Frozen SQLite, Buster self, Lua and musl whole-workload invocations compared 4,116 object results over three warning policies. 0 of the 12 workload/policy invocations differed. [Whole-workload outcomes](four/comparisons.tsv) and [output and ELF manifests](four/raw.tar.gz).

| Input | Paired object wall change | Faster rounds | Paired user cycles | Paired user instructions |
| --- | ---: | ---: | ---: | ---: |
| sqlite | +0.531 ms | 2/5 | -11,161,233 | -22,546,306 |
| buster | +0.932 ms | 2/5 | +12,019,170 | -36,830,774 |

The function-local source checker recorded 0 differences across the two frozen inputs and the directed sources, including mixed integer assignments. [Source oracle](source-oracle/comparisons.tsv), [differences](source-oracle/failures.json) and [raw source streams](source-oracle/raw.tar.gz). The received arithmetic-operand count excludes store, initialization and implicit-conversion rows. The taken count includes both operator families. [Coverage](source-oracle/coverage.tsv).

Each fresh process compiled the full input to a native object. Five ABBA/BAAB rounds measured elapsed time and three separate rounds measured user counters through perf. Positive differences indicate additional candidate cost. [All paired metrics](stage/paired.tsv), [per-process samples](stage/samples.tsv) and [raw process output and perf counters](stage/raw.tar.gz).
