# Guarded discarded pointer calls on frozen SQLite

The prototype saved about 1.32 million user instructions in each pair. Total cycles differed by +80.34, −1.01 and +0.79 per token, leaving the speed effect unresolved. The largest individual observation, round 1 position 2, used 138.66 ms task-clock and had eight context switches. The other prototype observation in that round used 126.39 ms. Both remained in the low-fault range. The full first round is retained below.

The prototype admitted 673 additional calls to a void function taking a local object pointer. It replaced 2,692 ordinary nodes and cut the final graph by 2,019. The three-round comparison used one Release executable from `1b616e18bb785ab4fc9f4f3b3ea2e33ae5e58222` with SHA-256 `1d7b6bcb17b7ffafc43fd8b60fc8c0244fe5fbf75c79416d90a79811a3ebfe82`.

| Prototype minus baseline | Round 1 | Round 2 | Round 3 | Median |
| --- | ---: | ---: | ---: | ---: |
| Cycles/token | +80.3416 | −1.0124 | +0.7901 | +0.7901 |
| User instructions | −1,319,506.5 | −1,319,587.0 | −1,319,548.0 | −1,319,548.0 |

Both modes used `--node-window --lanes 1 -c` and left all `BUSTER_CALL_*` and `BUSTER_PTR_*` controls unset. The baseline also left `BUSTER_DISCARD_PTR` unset. The prototype set it to 1. The baseline captured 2,977 expressions, replaced 7,534 ordinary nodes and left 319,066 graph nodes. Enabling discarded pointer calls raised admissions to 3,650, replaced 10,226 ordinary nodes and left 317,047 graph nodes. All 14 objects were 2,061,192 bytes with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`.

Each round used two observations per mode in symmetric order. The middle round reversed the order. Cycles include user and kernel time and use 716,136 preprocessed tokens. All PMU counters ran at 100% enabled time, with 5,665–5,670 process page faults. The [measurement commands](callptr-screen-one.sh), [order](order.tsv), [raw perf and qualification reports](measured-runs.tar.xz) and [frozen input](../paired-driver/README.md) accompany the [portable differential evidence, source patch and adversarial controls](correctness/README.md).
