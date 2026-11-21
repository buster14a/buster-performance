# Sparse program control markers in the production compiler

The [production implementation](implementation.patch) applies directly to public main 325883abf. Both binaries used ordinary artifact-generating commands. The [historical three-arm diagnostic](../7353e4074/README.md) compared its earlier experimental mode against two separate baselines.

| Source | Rounds | Total cycles/token | Paired true wall ms | Faster wall rounds |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/README.md) | 7 | −3.1413 [−13.4066, −1.9337] | −0.7810 [−1.3965, +0.2425] | 6/7 |
| [Lua lparser.c](lua/README.md) | 3 | −7.6554 [−23.6861, −2.4262] | +0.0795 [+0.0475, +0.1315] | 0/3 |
| [musl vfprintf.c](musl/README.md) | 3 | −21.7205 [−51.8951, +6.5734] | −0.0370 [−0.1760, +0.1055] | 2/3 |

The SQLite [regular-window](sqlite/admission-production.admissions) and [assignment-window](sqlite/assignment-production.admissions) paths also retained the same admissions and emitted the same complete object.
