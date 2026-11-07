# #628's outcome as #518's step measures it (buster#628), 2026-11-07

buster#628 asked that `-c` of the frozen `sqlite3.c` have a lower peak RSS and system time on the 9700X, measured as
buster#518's `compile_time` step measures them. This record runs that step's own commands for two trees:
- the tree #628's numbers came from;
- main once #628's last change, buster#1695, had merged.

## Sources

| tree | commit | what |
| --- | --- | --- |
| `base617` | [`2a852f20`](https://github.com/buster14a/buster/tree/2a852f2072c909057d185a3ae3c479531ba3022f) | main once buster#617 merged, whose 393,140 KB #628 starts from |
| `main8` | [`94e166ec`](https://github.com/buster14a/buster/tree/94e166ec6cc8a57579d5f21cd1423124a9194371) | main once buster#1695 merged |

`run/receipts17.txt` has the host, kernel, CPU 2's governor and EPP, the transparent huge pages' setting, clang's and
perf's versions, both executables' SHA-256 and the input's: the frozen corpus's `sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

## Method

`scripts/chain17.sh` builds each tree with `BUSTER_HOST_ARCH=znver5` under one hold of the lock (`run/builds/`). It then
runs, as the step does, pinned to CPU 2:
1. `measure-compile --runs 11 --reference /usr/bin/tcc` with the step's options (tcc's SHA-256 checked as the step
   checks it);
2. `perf stat -r 11` of the compiler, with the step's events.

Each tree's pair ran under its own grant of the lock (`run/step17/*.owner`), in the order `base617`, `main8`, `main8`,
`base617`. Each run's object's SHA-256 is beside it.

## Results

| measure | `base617` round 1 | round 4 | `main8` round 2 | round 3 |
| --- | ---: | ---: | ---: | ---: |
| wall, `measure-compile`'s median | 135.157 ms | 134.956 ms | 119.813 ms | 119.710 ms |
| system time, its median | 16.484 ms | 19.608 ms | 13.257 ms | 17.038 ms |
| peak RSS, its median | 390,188 KB | 390,172 KB | 239,844 KiB | 239,840 KiB |
| minor faults | 2,220 | 2,221 | 6,760 | 6,760 |
| task clock, `perf stat -r 11` | 134.86 ms | 135.06 ms | 119.01 ms | 118.98 ms |
| kernel cycles | 107.68 M | 108.15 M | 82.99 M | 82.33 M |
| user cycles | 639.98 M | 640.54 M | 576.76 M | 577.24 M |
| user instructions | 1,418.28 M | 1,418.28 M | 1,288.53 M | 1,288.53 M |

`measure-compile` labels the peak `KB` in `base617` and `KiB wait4 peak` in `main8`. Both are wait4's `ru_maxrss`, in
KiB.

So the peak falls 38.5% and the kernel's cycles 23%. The system time, which `getrusage` gives at a coarse grain, is lower
in each order. The wall time falls 11%.

The two trees' objects differ: `main8` holds ten days of other changes to the compiler. Each of #628's changes kept its
objects the same bytes as its own main's, as its pull request records.

What the compile still holds, and what `-Wall -Wextra` and `-g` add, is buster#1701.
