# A profile-guided build and the direct path (buster#3582)

Measured on 2026-11-25 at buster main `20f3573e`, for
[buster#3582](https://github.com/buster14a/buster/issues/3582): `BUSTER_PGO=1` trains its profile on the compiler's own
compiles, and the direct path (`c_direct.c`, the compiler a plain `-c` of one file takes) never runs in them.

- **Host:** `benchpress` (Ryzen 7 9700X), every build and run under `~/buster-fast-bench/exclusive.sh`, runs on CPU 2,
  objects on `/dev/shm`.
- **Builds** (`scripts/build-tree.sh`): `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release` on the
  host, with its CI toolchain (clang 23.1.4), one build a hold of the lock.
  - `plain-main`: main, no profile.
  - `pgo-main`: main with `BUSTER_PGO=1` (213 s, the instrumented compiles and the training included).
  - `pgo-head-none`: the change (`scripts/head-as-measured.patch`, buster#3582's pull request) with `BUSTER_PGO=1`: the
    direct path's unit compiles without a profile, the others with the same profile as `pgo-main`.
  - `pgo-head-sqlite`: the same with `BUSTER_PGO_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658`:
    the direct path's unit compiles with a profile of the instrumented executable's plain `-c` of the corpus's
    `sqlite3.c`.
  The two head builds reused `pgo-main`'s tree: only `c_direct.c` recompiled (2.6 and 4.2 s, the corpus's training
  included). `results/builds.txt` has the builds' lines.
- **Runs** (`scripts/ab-pgo.sh ROUNDS NAME...`): six workloads a variant, `perf stat` around each, a process a unit,
  the variants in an order that rotates by round, medians of 9 rounds (`results/ab-2.txt`; `results/ab-1.txt` is an
  earlier hold of 7 rounds with the two main builds alone, which reads the same).

## Which compiles reach the direct path (`scripts/eligible.sh`, `results/bail-trace.txt`)

A cloud container's Release build of main, each of the build's 44 sources compiled `-c` with the units' flags as the
training gives them (no `-g`, no `-ffunction-sections`):

- **With `-Wall -Werror`, as the training compiles: none.** The driver sends any `-W` option to the full pipeline.
  #3582 counted `c_direct.c` as direct: its object holds the string `buster direct`, which the direct path writes in
  `.comment`, as data. `readelf -p .comment` says `buster-fast`.
- **Without them: one,** `c_check_target_feature_emission_test.c` (12 KB). The other 43 leave the direct path in its
  preprocessor at `semantic pragma`, before any token is compiled (`experiment-bail-trace.patch`, from
  `direct-reach-fixed-cost-2026-11-25`): `#pragma clang diagnostic push` in clang's `prfchiintrin.h`, which
  `<immintrin.h>` includes at every `-march`. A unit of `#include <immintrin.h>` and one function leaves the same way.

So no training of the compiler's own sources can reach the direct path today.

## What the profile does to each path (`results/ab-2.txt`)

User cycles, medians of 9 rounds; the change against `plain-main`:

| workload | `plain-main` | `pgo-main` | `pgo-head-none` | `pgo-head-sqlite` |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` `-c` ×5 (direct) | 406.36 M | 425.76 M (+4.8%) | 406.04 M (-0.1%) | **393.40 M (-3.2%)** |
| `sqlite3.c` `-c --no-direct` ×2 | 1,095.01 M | 1,053.77 M (-3.8%) | 1,055.83 M (-3.6%) | 1,054.47 M (-3.7%) |
| `sqlite3.c` `-fsyntax-only` ×2 | 923.09 M | 878.52 M (-4.8%) | 877.94 M (-4.9%) | 879.56 M (-4.7%) |
| musl's 1,336 units, `-std=gnu99` (663 direct) | 4,880.8 M | 4,643.3 M (-4.9%) | 4,508.2 M (-7.6%) | **4,453.2 M (-8.8%)** |
| Lua 5.4.8, 34 units without `-Wall -Wextra` (29 direct) | 284.11 M | 284.35 M (+0.1%) | 274.53 M (-3.4%) | **269.95 M (-5.0%)** |
| Lua 5.4.8 with `-Wall -Wextra` (none direct) | 505.64 M | 463.33 M (-8.4%) | 463.69 M (-8.3%) | 463.78 M (-8.3%) |

- **Today's profile makes the direct path slower.** Every count of `c_direct.c`'s code in it is zero, so clang treats the
  unit's code as never run: `sqlite3.c`'s `-c` takes 4.8% more user cycles and 5.1% more instructions than without a
  profile (4.6% in `ab-1.txt`). Lua's direct units lose what the profile gives their other parts.
- **Without a profile for that unit** (`pgo-head-none`) the direct path is where a plain build has it, and the units
  around it (the driver, the process's start) keep their gain: Lua's direct build -3.4%.
- **With the direct path's own profile** (`pgo-head-sqlite`) `sqlite3.c`'s `-c` falls 3.2% (instructions 1,108.2 M to
  1,005.6 M, -9.3%). `sqlite3.c` is the unit it trained on. Lua, which it didn't see, gains 5.0% in all, 1.7% more than
  without the profile.
- **The full pipeline is unchanged:** the other 43 units take the same profile in all three `BUSTER_PGO` builds;
  their instructions agree to 0.01%.
- Every build wrote the same objects (`== objects`), and the same units took the direct path in each.

## Not measured

- A profile of the compiler's compiles and the corpus's merged into one, which every unit takes: the change keeps the
  direct path's profile apart, so the full pipeline's profile is the same with the corpus as without.
- Other corpus units (musl, Lua) in the direct path's training.
