# #450 affinity-check candidate: local validation

Candidate: `638442081ae1b9134ed2dee1ca0fcc8b3933e4b0`, branch
`codex/450-affinity-check-diagnostic`. Baseline/prerequisite:
`31c4ced26abcf0393e8c8f4f138e42dfe1952ee4`. Production
`c_check_deferred.c` is byte-identical to that baseline; the production
optimization is in `lane.c` only. The previous context/helper/outlined
candidates remain rejected history, not acceptance evidence for this one.

Source archive: `450-affinity-check-final.tar`, SHA-256
`98b16a865d35e9518fe4256b7babf6e67280d35f41086696365d510ff09a7902`.

All local multicore work entered the actual shared `cores` FIFO through the
coordinator's `limited-job.sh`, plus the shared one-heavy-job permit.
Compilation/capture role A requested two physical cores, quota 200%, memory
cap 8 GiB; test role A-test requested four physical cores/eight SMT CPUs,
quota 800%, memory cap 8 GiB. The owner's two interactive cores stayed
reserved. Queue-granted CPU lists appear in the raw logs. No fixed CPU pin
was used locally. The final compile waited 1m48s behind other owners, then
ran both compiler invocations sequentially; no full compiler relink or
duplicate corpus suite was performed.

Every granted job verifies exact HEAD and a clean source/build-script diff
before work and again afterward. The sanitizer harness and binary hashes
are recorded. The source stayed immutable through all of those jobs.

## Build commands

```sh
clang -O3 -march=native -Isrc -fwrapv -funsigned-char \
    -fno-strict-aliasing -Wall -Werror \
    -c src/buster/compiler/main_unit_checker.c \
    -o .git/450-affinity-final-checker.o

clang -O1 -march=native -Isrc -fwrapv -funsigned-char \
    -fno-strict-aliasing -Wall -Werror -Wno-unused-function \
    -fsanitize=address,undefined -fno-omit-frame-pointer \
    -ffunction-sections -fdata-sections -Wl,--gc-sections -no-pie \
    .git/affinity-sanitize-entry.c -lm -ldl \
    -o .git/test-affinity-final-asan
```

The focused harness includes `main.c` with its module definitions made
static, rather than unavailable external homes. It exposes only the
existing deferred and lane test commands; garbage collection removes the
unreferenced modules. Tests and production definitions are otherwise the
same source. The normal native compiler build and acceptance remain the
coordinator's independent gate.

Build log: `450-affinity-final-build.log`. Optimized object SHA-256:
`ce2a163ee83069da274f3309f42e3d408077dee9f1f963e500d9e8922b65065f`.
Sanitizer binary SHA-256:
`6a9441901fa4598650e0bc300fb7a6624cfda2bf25c2387fcf05e5a7b21bc0dc`.
Local O3 `check_input_run` is 0x13ae2 bytes with a 0x808 stack allocation,
matching the baseline's common-reader size/frame. `check_deferred_lane`
remains 0x65db bytes; `lane_run` is 0x921 bytes. These are local code-shape
observations, not timing evidence.

## Tests

Each invocation uses its own A-test grant with:

```sh
ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1 timeout 180 \
    .git/test-affinity-final-asan test-lanes

ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1 timeout 180 \
    .git/test-affinity-final-asan test-checker-deferred
```

`450-affinity-final-lanes-test.log`: passed, zero failures or sanitizer
findings. Includes 50 arena checks, 262 changing-count team operations,
protected singleton-mask tails, four forked affinity cases, and default
one/two/three/eight-lane checks with 10,000 rounds each. The forked cases
cover no affinity writes when already pinned, callback repin restoration,
forced restoration when the final query is refused, and callback mutation
of the caller-owned CPU-list slot. Existing invalid/nested, counter/context,
multi-lane, range, exchange and part checks remain enabled.

`450-affinity-final-deferred-test.log`: passed, zero failures or sanitizer
findings: 49 fixtures, 772 checks, 480 merged and 6,084 bodies read apart,
including #469's four GNU23 fixtures and the timed
400-body ordinary-one-lane, pinned-one-lane and eight-lane cases.

## Call graph

Separate two-core A grant:

```sh
BUSTER_DEBUG_INFO=0 bash -x ./build.sh check-call-graph
```

`450-affinity-final-call-graph.log` / `.trace`: passed, 42 translation units,
23,585 functions, 139,163 calls, zero disallowed cycles, three allowed cycles
and zero split variables. The
unchanged analyzer binary reads fresh exact-source IR from all 42
translation units; capture width is explicitly two, with the same O3 flags
and the inline-body-cycle regression gate intact.

Native timing qualification, native corpus acceptance, raw whole-reader
results and merge readiness are pending the coordinator's exclusive-host
sessions. Nothing in this note claims a performance win.
