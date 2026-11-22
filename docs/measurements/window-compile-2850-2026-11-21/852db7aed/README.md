# Integer transfer rows on the ordinary native compilation route

Buster `852db7aed11ddecd5294b62d16f4bb7fe74ce15f` runs the mixed integer and predicate checker during normal graph validation, warning finalization, lowering and native object emission when `BUSTER_CHECK_ORDINARY_ACTION_ROWS=1` is set. All comparisons use the same input paths and compiler flags. The two timed arms use the same native Develop binary on one Ryzen 9 7940HS core. [Source diff](implementation.patch) and [source-local stage](../81a0b26ad/README.md).

The source, native-object, warning-policy and dump oracle recorded 0 differences in 90 directed or real-source comparisons. Each result records ordinary compiler exit status, standard output, diagnostic streams and ELF hash. Two further scopes on each frozen input compare the specialized checker’s whole-unit checked results to independent reference fingerprints. [Oracle outcomes](oracle/comparisons.tsv), [differences](oracle/failures.json), [raw streams and ordinary checker coverage](oracle/raw.tar.gz) and [directed C sources](cases.tar.gz).

Frozen SQLite, Buster self, Lua and musl whole-workload invocations compared 4,116 object results over three warning policies. 0 of the 12 workload/policy invocations differed. [Whole-workload outcomes](four/comparisons.tsv) and [output and ELF manifests](four/raw.tar.gz).

| Input | Paired object wall change | Faster rounds | Paired user cycles | Paired user instructions |
| --- | ---: | ---: | ---: | ---: |
| sqlite | -0.967 ms | 3/5 | -28,384,182 | -16,518,452 |
| buster | +2.073 ms | 2/5 | +58,309,928 | -31,273,978 |

Each fresh process compiled the full input to a native object. Five ABBA/BAAB rounds measured elapsed time and three separate rounds measured user counters through perf. Positive differences indicate additional candidate cost. [All paired metrics](stage/paired.tsv), [per-process samples](stage/samples.tsv) and [raw process output and perf counters](stage/raw.tar.gz).
