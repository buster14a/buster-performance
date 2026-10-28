# Reproduce #665

Use an isolated Linux/x86-64 Zen 5 machine for the native comparison. On the
shared benchpress host, wrap every extraction/build/test/cohort/capture/package
operation in `EXCLUSIVE_OWNER=... EXCLUSIVE_TITLE=... EXCLUSIVE_LINK=...
~/buster-fast-bench/exclusive.sh COMMAND...`. Hold per run, never a whole series;
make no machine-setting changes. Elsewhere use the local core allocator where
available. These commands describe the archived method, not a claim for a new
toolchain or placement.

## Sources and builds

Check out Buster separately at:

```
241fcb3e9a5a55d8ccc3dfffc7d9d0efd56bdda7  base
a207fcd7e742c517f0d5bac6ff1bd5ac2772c360  head
```

Both commits are public; the candidate is retained at
`codex/665-frozen-native-candidate`. Use exact git archives plus SOURCE_COMMIT
receipts or detached checkouts, never a mutable CI compiler. Build each with
`BUSTER_DEBUG_INFO=0 ./build.sh`, preserving the actual compile commands,
toolchain output and binary hashes. The recorded toolchain is Clang 23.1.1;
build flags are in the archive's base/head compile_commands.json. Build times
are provenance only, not compiler-build performance qualification.

From a working directory containing `base/`, `head/` and these original helpers:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror method/make_cases.c -o make_cases
clang -std=c17 -O2 -Wall -Wextra -Werror method/qa.c -o qa-check
clang -std=c17 -O2 -Wall -Wextra -Werror method/many_qa.c -o many-check
clang -std=c17 -O2 -Wall -Wextra -Werror method/measure.c -o measure
clang -std=c17 -O2 -Wall -Wextra -Werror method/stats.c -o stats
clang -std=c17 -O2 -Wall -Wextra -Werror method/object_check.c -o object-check
mkdir cases qa qa-many roles results
./make_cases cases
taskset -c 2 ./qa-check ./base/build/compiler ./head/build/compiler cases method/runtime.c qa
taskset -c 0-7 ./many-check ./base/build/compiler ./head/build/compiler cases/many-bodies.c method/runtime.c qa-many 8
taskset -c 0-7 ./head/build/compiler test-checker --seed 665 --clang clang
```

`qa-check` compiles/links/runs all 30 cases and requires all 143 complete
input/output rows, Clang agreement and scalar/vector object equality.
`many-check` does the same for the eight worker-body control. Keep the per-run
lock around each command on the shared host.

## Cohorts

Copy immutable binaries to fresh equal-length paths such as `roles/b000` and
`roles/h000`, and make separate fresh `b001`/`h001` copies for confirmations.
For A/A, both `aa00` and `aa01` contain the exact baseline bytes. Preserve
hash receipts. Never reuse an existing result prefix; the supervisor refuses it.

Example instrumented cohort (wrapped in the shared lock on benchpress):

```sh
taskset -c 2 ./measure results/stage-add8000 ./roles/b000 ./roles/h000 6 --time-stages --lanes 1 -std=gnu17 -c cases/add-8000.c
./stats results/stage-add8000/samples.tsv
```

The supervisor runs three full-size primers followed by six ABBA cycles:
12 timed samples per role. Repeat for add2000/add4000 and
popcount2000/popcount4000/popcount8000. Plain fresh-copy confirmations omit
`--time-stages`. Small add1/popcount1 and matched popcount1 A/A use 32 cycles,
64 timed samples per role. Each invocation is one homogeneous input and one
separate lock hold.

SQLite's exact shared-input arguments are below. Supply them after the
supervisor's paths/cycle count; it appends a fresh `-o` output for every child.
Its source/predefines hashes are in `native/corpus-identities.sha256`. Headers
and SQLite remain external frozen runtime inputs; none are incorporated here.

```text
--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines ../corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem ../corpus/headers/usr/lib/clang/23/include -isystem ../corpus/headers/usr/local/include -isystem ../corpus/headers/usr/include -I../corpus/sqlite ../corpus/sqlite/sqlite3.c
```

Use six cycles for plain, A/A, instrumented and independent-copy SQLite
cohorts. The final audit independently compiles scalar SQLite with `--verify`
and compares its bytes with the candidate vector object.

## Audit and replay

Before omitting bulk artifacts, run `stats` on every complete samples.tsv,
then `object-check results/*/samples.tsv` to compare every warm/timed object
within its input/role and both A/A roles. Save SHA256 for every object and
for all compiler/method/input files. Retain failures/faults; do not trim rows.
The recorded audit reports 717 objects, all equal, plus an 843-object SHA manifest.

To inspect the published lean record:

```sh
mkdir replay
tar -xzf native/evidence-a207.tar.gz -C replay
cd replay
../stats results/*/samples.tsv
```

The published archive deliberately excludes object/executable payloads.
Its stats reader can replay rows and complete phase logs; byte payloads must
be regenerated to rerun `object-check`. Their recorded hashes and the actual
target byte-audit receipts remain available. The local and generic source
adapters require the matching compiler source: frozen a207 for native scratch
checks, publication `25783a29` (including #678) for baseline x86-64 source checks.
The generic source adapter was built from the matching compiler checkout with:

```sh
clang -O1 -g -fgnu89-inline -march=x86-64 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wno-unused-function -Wno-unused-variable -Wno-psabi -ffunction-sections -fdata-sections -fsanitize=address,undefined /path/to/record/method/source_checks.c -Wl,--gc-sections -lm -ldl -pthread -o source-checks
ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 ./source-checks
```

For native scratch API checks use `scratch_checks.c`, `-march=native` and omit
`-fgnu89-inline`; other sanitizer flags are the same. These adapter flags are
not production flags.
