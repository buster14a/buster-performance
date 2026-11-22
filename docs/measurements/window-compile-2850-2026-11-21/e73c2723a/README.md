# Classify checked lowering reserve operands in masked batches

Production candidate `e73c2723afa2f0fb0ce6d2b11d401a94998ddf4e` follows `40ae34f9d77afc42face58eff3338b7b1d1ba469`. A translation unit with an atomic or transport-vector type uses checked result, conversion and left-operand types to identify which expressions need the full lowering reserve calculation. The ordinary cases are classified sixteen at a time. SQLite had 4,740 types and zero vectors or atomic types, so it kept its existing operator path. Buster had 10,849 types, including 61 GNU and two extended vectors, and took the new path. [Implementation](implementation.patch) and [Release binaries](builds.tsv).

The native output comparison covers 244 directed and real compiler invocations and 4,116 file/policy pairs across SQLite, Buster, Lua and musl. The process oracle includes status, stdout, stderr and object hashes. See [individual directed outputs](oracle/outcomes.tsv), [Clang observations](oracle/clang.tsv), [executable return values](oracle/executions.tsv), [corpus receipts](per-file) and [checker and driver suites](suites/status.tsv).

The GDB control recorded all seven capacity fields from 24 ordinary Release planner calls. Comparing with the parent's actual result and redirecting only the candidate planner to the existing explicit numeric calculation yielded 0 input differences. The tables include vector and atomic cases, mixed casts, wide vectors with scalar subscripts, and both complete workload objects. [All input outcomes](counts/outcomes.tsv), [reserve values](counts/tuples.tsv) and [type populations](counts/type-census.tsv).

## Local Release results

The two compiler revisions ran as alternating ABBA or BAAB four-call groups on one physical core of the development machine. Wall and PMU series are independent. Differences use the median within-round change. [Every measurement](stage/samples.tsv) and [paired summary](stage/paired.tsv).

| Workload | Counter | Parent | Candidate | Paired difference | Lower rounds |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite | ns | 280,245,885 | 279,844,211 | -1,372,841 | 7/12 |
| sqlite | instructions | 1,233,216,849 | 1,233,197,881 | -18,958 | 8/8 |
| sqlite | cycles | 800,606,342 | 773,737,837 | -18,922,739 | 6/8 |
| main | ns | 1,545,684,954 | 1,546,969,131 | 4,301,870 | 5/12 |
| main | instructions | 9,350,228,937 | 8,949,478,399 | -400,750,996 | 8/8 |
| main | cycles | 4,446,928,006 | 4,428,669,779 | -37,350,928 | 5/8 |

## Checked operand input controls

A debugger replaces one scalar addition conversion with the declared 128-byte vector type while the reserve function runs. For a real wide-vector subscript, its conversion also carries the vector type. Changing the left operand alone preserves the capacity. With those two conversion types temporarily cleared in both arms, the left operand independently changes the reserve from 1,088 entries and 24 locals to 544 entries and 12 locals. Each result matches the scalar calculation and restores the original complete object. [All twelve observations](operand-oracle/observations.tsv).

Clang and Buster returned the same success or failure on 29 of 29 directed sources. Their exact diagnostic messages agreed in 15 and their locations in 18. All directed parent and candidate outputs agreed. [Clang comparisons](oracle/clang.tsv).

## Ryzen 7 9700X

The exact parent and PR revisions each built in Release on benchpress. The shared exclusive lock covers each invocation separately. Five alternating ABBA or BAAB rounds used CPU 2 with one compiler lane. Five additional alternating rounds timed the compiler directly with the monotonic clock. The kernel software duration event in the PMU series returned zero. The direct process series supplies the reported wall times. Every measured result matched the preflight ELF and compiler streams. [PMU samples](target/samples.tsv), [direct wall samples](target/wall-samples.tsv), [compiler hashes and machine details](target/system.json), [hosted admission](target/target-admission.json) and [individual PMU logs](target/raw.tar.gz).

| Source | Metric | Parent | Candidate | Paired change | Lower rounds |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite | user-instructions | 1,235,202,200 | 1,235,185,784 | -16,374 | 4/5 |
| sqlite | user-cycles | 539,424,961 | 539,397,248 | +443,591 | 2/5 |
| main | user-instructions | 9,358,475,456 | 8,957,756,551 | -400,723,256 | 5/5 |
| main | user-cycles | 3,062,425,114 | 3,027,543,190 | -36,865,907 | 5/5 |
| sqlite | wall-ns | 112,138,730 | 112,327,770 | -138,645 | 4/5 |
| main | wall-ns | 611,146,266 | 602,003,971 | -9,142,295 | 5/5 |
