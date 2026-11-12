# buster#2534's and buster#2522's cost, base against head, 2026-11-12

The 9700X (`benchpress`), CPU 2. Each comparison is one `time-runs` call (21 interleaved runs, 3 warm-ups) under a
single `exclusive.sh` hold. It times `-fsyntax-only` and `-c` of sqlite3.c and main.c. An identical copy of base's
binary sets the noise floor. The scripts are the same as in [e7b-2451-2026-11-12](../e7b-2451-2026-11-12):
`setup.sh NAME REVISION`, `build.sh NAME` (`BUSTER_HOST_ARCH=znver5`, Release), and `run4.sh BASE HEAD LINK`.

## buster#2534 (`-Wno-error=` for clang's default-error conversions, #1963): run-1963a.log

Base `base1963` is main `3ae9e65b`. Head `h1963` is `71980836`. Run at about 15:30 UTC, after the stray process in buster#2555 had gone.

| List | copy wall | head wall | copy cycles | head cycles | head instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1, `-fsyntax-only` sqlite3.c | −0.04% | −0.17% | −0.04% | +0.22% | −0.001% |
| 2, `-c` sqlite3.c | +0.69% | +0.61% | +0.06% | +0.07% | +0.000% |
| 3, `-fsyntax-only` main.c | −0.29% | −0.05% | −0.21% | −0.15% | +0.000% |
| 4, `-c` main.c | −0.30% | −0.10% | −0.32% | +0.03% | −0.000% |

Every head median is within the identical copy's spread. Without a demotion, the change adds one pass over the
options and one over the diagnostic pragmas per unit, and a mask on the system-token reads.

## buster#2522 (`-Wunused-local-typedef`): run-2522a.log

Base `base5f` is main `c5f0efb2`. Head `h2522` is `3115175f`. Run at about 11:50 UTC, during the stray process's window
in buster#2555, which sat on CPU 2 about one snapshot in ten. Medians are within the copy's spread on all four lists
(posted on buster#2522).
