# Stack protector: pin `-fno-stack-protector`, Buster #916

[Issue #916](https://github.com/buster14a/buster/issues/916) found that a
distribution's Clang enabled `-fstack-protector-strong` by default while the
official release staged by CI did not, so the host's configured default decided
the compiler's code and its measurements. The owner chose no stack protection
for now, with the policy allowed to change later. The change pins
`-fno-stack-protector` in `build.sh`, checks the linked executable for the
canary, and keeps the compiler's predefined `__SSP_*` macros following the host
driver's configured default through `BUSTER_HOST_SSP_DEFAULT` (so the host
oracle still matches `clang -dM`).

This record covers the canary count and the whole-process `-c sqlite3.c`
measurement the issue's "Done when" asks for. The earlier independently claimed
FENV_ACCESS call-guard slice is PR #919 and is not part of this record.

## Sources and host

- Base: Buster `f04ca03e8789aa9bc2fc34e4e222eda85a225a8e` (`origin/main`,
  2026-11-01).
- Head: Buster `4a5ce1fd6f99c6aff2dc4440bb8d701b13f29891`, the
  `-fno-stack-protector` change rebased onto that base.
- Both trees built on the 9700X with `BUSTER_DEBUG_INFO=0 ./build.sh shifts
  shifts main_unit_checker.c 0 4096 8192 12288`, Clang 23.1.1, Wild 0.10.0,
  `-march=native` (znver5), `-O3`.
- Host: AMD Ryzen 7 9700X, 8 physical cores, Linux 6.18.50-2-lts. Each build,
  count and measurement held `~/buster-fast-bench/exclusive.sh` for its own
  run; `time-runs` ran pinned to CPU 2.
- Input: the frozen `sqlite3.c` from the 9700X job's preprocessor corpus,
  SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

## Canary count

`objdump -d <compiler> | grep -c __stack_chk_fail`:

| Build | Calls | Binary SHA-256 | Size |
| --- | ---: | --- | ---: |
| Base `f04ca03e` | 4,008 | `dc789eabcd1b7acb963bd7839ba6d15ca967868c3ea17274123f14028b33ec81` | 43,927,534 |
| Head `4a5ce1fd` | 0 | `0bae4ad6020dcdf22d64eb0fd18fd0261bb5fc4e9c8c674787cb1f3e4ffb2ac3` | 43,629,566 |

The head's `build.sh print-compile-flags` includes `-fno-stack-protector` and
`-DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_STRONG`; the base's includes
neither. The compiler's `-dM` output still defines `__SSP_STRONG__` on this
host, as the host Clang does.

## `-c sqlite3.c`

`time-runs` ran one list per slot, 2 warm-ups, 9 measured runs, 2 fresh copies,
4 effective placements per build, all pinned to CPU 2. The command was the
compile-time record's:

```sh
build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE \
  -I<corpus>/sqlite <corpus>/sqlite/sqlite3.c -o <out>
```

Medians over 72 runs per build (8 slots × 9 runs):

| Measure | Base | Head | Head against base |
| --- | ---: | ---: | ---: |
| Wall (ms) | 124.806 | 124.451 | −0.28% |
| User cycles (millions) | 583.400 | 580.555 | −0.49% |
| Instructions | 1,373,987,470 | 1,360,159,295 | −1.006% (13,828,175 fewer) |

The wall change ranges over placements from −0.60% to +0.13%, and over
placements and copies from −0.99% to +0.62%. The cycle change ranges over
placements from −0.69% to +0.28%, and over placements and copies from −0.91% to
+0.76%. The base's placements spread 0.19% in wall and 0.24% in cycles; the
head's spread 0.54% and 0.74%. The exact canary removal is the reliable result;
the whole-process wall and cycle changes are small and mixed, and this record
makes no general throughput or universal no-regression claim.

The same base and head compilers produced byte-identical objects for that
command:

```text
72942492c786b042959006488a8c6a8da6d1e3028489dc1ddf02c0cea178fd37  /tmp/sqlite-base.o
72942492c786b042959006488a8c6a8da6d1e3028489dc1ddf02c0cea178fd37  /tmp/sqlite-head.o
```

## Files

- `time-runs.log`: the complete `time-runs` report, including every run line,
  the per-slot medians and the build comparison.
- `canary-counts.txt`: the exact count commands, flags and object hashes.
- `commands.txt`: the build and measurement commands.
