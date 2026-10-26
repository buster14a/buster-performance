# #450 existing cold-call candidate: local proof

Exact head: `1d2b12c658807f466b989bcdfe2cdf548c1812d5` on
`codex/450-cold-call-diagnostic`. Exact integrated baseline:
`35f26f68d7caa9bf5f6248822100a51c06e2c878`, merged once as `74a9dc49`.
Later unrelated main changes are outside this comparison.

Candidate source archive SHA-256:
`f06f28af6609c2676b8f82125c098527d32548047a9a2dfcbfe4d5e8cbabec73`.
Baseline full archive SHA-256 (coordinator):
`750688147e900e09e5b25920cbc3129a3b14bb882302d1987d6d2a37961499bf`.

The production diff is the choice of existing launcher in
`check_deferred_bodies`: active one calls
`lane_run_cold(1, check_deferred_lane, &run, 0)`; more than one keeps
`lane_run(active, ..., deferred->cpus)`. No new lane function, field,
attribute, affinity query or API behavior is introduced. The generic lane
implementation and its original refusal tests are byte-identical to main.
MIT notices are consequently retained unchanged. The checker and its tests
remain original project C code.

The private cold utility creates no worker or affinity calls at count one,
saves/resets/restores Lane/taken/running, and uses a fresh group without
touching any installed team. This checker-only path can run within an
existing operation; generic lane_run's pinned-team/nesting/refusal contract
is not relaxed. The test explicitly checks that separation and continuity.

## Local O3 code shape

Only the checker object was compiled for each exact source, using the
existing O3/native flags without debug info. Baseline source was extracted
from the exact Git tree into private scratch; no full compiler build was
duplicated. The final object repeats the direct probe's shapes:

| Function | Baseline text | Candidate text | Baseline stack allocation | Candidate stack allocation |
| --- | ---: | ---: | ---: | ---: |
| check_input_run | 0x12dce | 0x12dee | 0x808 | 0x808 |
| check_deferred_lane | 0x65fb | 0x65fb | unchanged | unchanged |
| lane_run | 0x74e | 0x387 | 0x2380 | 0x138 |
| Existing lane_run_cold | inlined into lane_run | 0x428 | inside wrapper | 0x2380 |

The compiler naturally outlines the existing cold function after the new
call site; no noinline or alignment directive is used. Combined lane_run +
cold text grows 97 bytes, and the common reader grows 32 bytes without frame
growth. Stack allocations exclude register pushes and dynamic alignment.
These are local 7940HS code-generation observations, not native timing or
whole-binary text/RSS claims.

Baseline checker object SHA-256:
`310660ebbfb5cb6f14c38fae3d72491cbec79357f44670d6ae45dcdd24f82458`.
Final checker object SHA-256:
`d890434f0f667adc2e7767f61fadf2efb94ce95f533f7e7ff387fd3d63d30d75`.
Logs: `450-cold-direct-object.log` (baseline/probe),
`450-cold-distinct-build.log` (final O3, followed by the failed scratch
sanitizer macro attempt described below).

## Successful sanitizer harness reproduction

The final successful entry is `cold-sanitize-entry.c`; its included main
copy is produced from exact source as follows (all paths relative to the
source checkout):

```sh
sed -e 's/#define BUSTER_ELSEWHERE inline __attribute__((noinline))/#define BUSTER_ELSEWHERE static/' \
    -e 's/^int main(/static int buster_unused_main(/' \
    src/buster/compiler/main.c > .git/cold-sanitize-main.c
```

The equivalent two-hunk patch is `450-cold-harness.patch`. Module homes are
made static so the focused harness can link directly; the unused root
dispatcher is renamed/static to avoid generating unrelated commands. No
global `main` macro is used. Production definitions and test assertions are
otherwise unchanged. The entry exposes the existing deferred and lane
commands, with unused sections discarded at link time.

Successful build command, through the coordinator's A budget:

```sh
clang -O1 -march=native -Isrc -fwrapv -funsigned-char \
    -fno-strict-aliasing -Wall -Werror -Wno-unused-function \
    -fsanitize=address,undefined -fno-omit-frame-pointer \
    -ffunction-sections -fdata-sections -Wl,--gc-sections -no-pie \
    .git/cold-sanitize-entry.c -lm -ldl -o .git/test-cold-distinct-asan
```

| Successful harness artifact | SHA-256 |
| --- | --- |
| cold-sanitize-main.c | `6c2b45fcbd2398a3785a7540aaebfce01e1bb37e6fd85ac4d8d00938c37e188e` |
| cold-sanitize-entry.c | `dfa5ef0276e217af0d89046c77a2ba72c9bc739fc8ff6c7009f417024e3581e4` |
| 450-cold-harness.patch | `cf7f628cb5465929eadbb58bf1afd45470927f8ad21c75d7c31cc8960a2307b8` |
| test-cold-distinct-asan | `8e80e23640dfbdf4fe52202c5f4ce56fafe0adaa61cc43c77d005c9303950153` |

The successful log is `450-cold-distinct-sanitize-build.log`. The earlier
global `main` macro optimization failed because it also replaced ordinary
local identifiers; that unsuccessful harness attempt is retained in
`450-cold-distinct-build.log`. No production source was changed to address
the harness error, and no test ran with that failed version.

## Test and graph results

Under its own A-test grant:

```sh
ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1 timeout 180 \
    .git/test-cold-distinct-asan test-checker-deferred
```

Passed: 56 fixtures, 891 checks, 564 merged, 6,228 bodies read apart, zero
failures or sanitizer findings. The new 400-body case runs inside a live
pinned two-lane team's first lane with an unfinished take and impossible
inner CPU target. It verifies saved Lane/taken/running/team, immediate inner
singleton affinity, then reuses both original worker TIDs in another team
operation and checks the caller's final mask. The two workers use distinct
allowed CPUs; unavailable capacity fails explicitly. The earlier same-CPU
test variant was compiled but never executed. All current-main fixtures,
one-/multi-lane comparisons, timing gates and generic refusal tests remain.
Log: `450-cold-distinct-deferred-test.log`.

Fresh source IR, unchanged analyzer, A budget:

```sh
BUSTER_DEBUG_INFO=0 bash -x ./build.sh check-call-graph
```

Passed: 42 translation units, 23,931 functions, 141,897 calls, zero disallowed
cycles, three allowed cycles, zero split variables. Capture width is two.
Logs: `450-cold-distinct-call-graph.log` and `.trace`.

## Resource and identity boundaries

Every compile, capture and test used the actual shared cores FIFO plus the
coordinator's single-heavy-job permit. A requested two physical cores,
quota 200%, memory cap 8 GiB; A-test requested four physical cores/eight SMT
CPUs, quota 800%, memory cap 8 GiB. Granted CPU lists are logged. No local
fixed pin, unrestricted parallel default or performance-host command was
used. Source-frozen jobs finished and their scopes closed before any edit.

Each exact-final job checks HEAD and clean source/build-script diff before
and after work; successful harness/binary hashes are logged around the test.
The checkout remains clean at 1d2b12c6. Native source/image identity,
full-native acceptance, paired measurements and performance acceptance remain
the coordinator's independent gate; this local proof does not establish a
timing win.
