# Large-function local capacity (#622)

Correctness qualification for [Buster #622](https://github.com/buster14a/buster/issues/622) and
[source PR #634](https://github.com/buster14a/buster/pull/634).

- Baseline: `92c025e71856d13eb34247477c5294d2cead139e`.
- Fixed source: `4ad2064ae7f141f40423f016bfd463cecf228fa8`.
- Target host: Linux/x86-64, AMD Ryzen 7 9700X, Clang 23.1.1.
- Local checks: Linux/x86-64, AMD Ryzen 9 7940HS, Clang 23.1.4.
- Baseline and fixed target builds use the repository's `./build.sh`, `BUSTER_DEBUG_INFO=0`, `-march=native -Isrc -fwrapv -funsigned-char
  -fno-strict-aliasing -Wall -Werror -O3`, and the selected `/usr/bin/wild` linker.

The fixed source raises `BUSTER_TIER0_MAX_LOCALS` from 65,536 to 16,777,216, matching the existing entry cap.
Local IDs, home indices and frame arithmetic already support the larger count. Entry/local limit failures and
insufficient lowering storage carry distinct reasons through rollback into the production diagnostic renderer.

## Inputs and checks

`generate-large.c` emits the reported shape: each block declares two locals, reusing 64 identifier spellings,
and updates a parameter. `generate-large N i` emits signed `int` code; `-fwrapv` defines its overflow. The emitted
`main` compares its result on four inputs with an independent unsigned loop. The sizes are 20,000 blocks
(40,001 locals), 32,768 (65,537), and 40,000 (80,001).

`check-large.sh` checks both scalar and vector paths against the exact baseline and fixed builds. It checks
ordinary 20,000-block object identity against the baseline; compiles all three sizes with `--verify -g`; links
and runs each object; compares scalar/vector objects; builds the 40,000-block program with Clang; and builds,
runs and compares both direct executables with debug information. The log includes input and binary hashes.
`head-source.sha256` checks every tracked fixed-source file before the reproduction runs.

The committed `test-checker-driver` regression generates 32,768 unsigned blocks, the first block count beyond
the former cap. It checks both objects, their native results and Clang's against an independent loop on four
inputs. Six small synthetic cases cover value locals, frame objects and entries, distinguishing hard limits
from storage exhaustion, preserving the first failure and rollback, and rendering each capacity name.

## Suite results

| Target command | Result |
| --- | --- |
| Baseline and fixed complete builds | Pass, 41 sources each |
| `test-checker-driver --executable ./build/compiler` | 21,631 checks, 0 failures |
| `test-checker --seed 133` | 265,523 checks, 0 failures |
| `test-tier0 --cross-check` | 234,706 checks, 0 failures |
| `./build.sh check-call-graph` | 41 units, 23,958 functions, 143,425 calls; 0 unapproved cycles, 3 allowed, 0 split variables |

The complete standalone run, `raw/reproduction.log`, passed at 20:34 UTC on October 27:

| Blocks / locals in `f` | Baseline, both paths | Fixed, both paths |
| --- | --- | --- |
| 20,000 / 40,001 | Accepted | Plain objects equal the baseline; verified debug objects link and match the model |
| 32,768 / 65,537 | Rejected at the old local limit | Verified debug objects link and match the model |
| 40,000 / 80,001 | Rejected at the old local limit | Verified debug objects link and match the model |

All three fixed scalar/vector object pairs are byte-identical with `-g`. The 40,000-block Clang executable and both
fixed direct executables match the independent loop on four inputs; the direct executables are byte-identical
with `-g`. The fixed source manifest passed before the run, and its binary hash remained the one built and tested
by the suites above. Baseline error files retain the exact failing source positions.

The corresponding complete outputs are in `raw/`. The Tier 0 command's incidental timing/size rows are retained
as printed; this qualification uses its correctness outcomes.

The first standalone reproduction completed the 20,000-block checks and then stopped because its `rg` command
was unavailable on the target (exit 127). `raw/reproduction-attempt1.log` retains that partial attempt. The
harness was changed to the installed `grep` for the diagnostic check; the corrected complete run passed. The
compiler source stayed at `4ad2064a` throughout.

## Recorded commands

Every target build and test uses its own shared host lock:

```sh
EXCLUSIVE_OWNER=codex-622 \
EXCLUSIVE_TITLE='Buster #622 qualification' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/634 \
~/buster-fast-bench/exclusive.sh COMMAND...
```

The source directories on the host are `~/buster-fast-bench/codex-622/base` and `head`.
Run `BUSTER_DEBUG_INFO=0 ./build.sh` in each. The fixed build's commands are:

```sh
./build/compiler test-checker-driver --executable ./build/compiler
./build/compiler test-checker --seed 133
./build/compiler test-tier0 --cross-check
./build.sh check-call-graph
```

Input preparation ran locally from the task workspace; the generated sources were transferred unchanged to the
host's parent directory:

```sh
clang -std=c17 -O0 -Wall -Wextra -Werror work/generate-large.c -o work/generate-large
./work/generate-large 20000 i > work/large-20000.c
./work/generate-large 32768 i > work/large-32768.c
./work/generate-large 40000 i > work/large-40000.c
```

The reproduction runs `bash ./check-large.sh` from the host's parent directory. Each target command was queued
separately through `exclusive.sh`; the reproduction is one short locked
run. Locally, each build and full driver suite used `cores -n 2`; the additional individual single-lane source
compiles, links and model runs each took less than 30 seconds. `raw/driver-local.log` records 21,631 checks and
zero failures, including all new regression checks.

## Scope and provenance

These are correctness and regression receipts. They establish compilation, diagnostic behavior, object identity
and native execution for the recorded inputs. The remaining configured caps and available arena/frame memory
still bound compilation. This record contains one qualification of each listed suite and claims no throughput
improvement or complete C-corpus acceptance.

The generator, fixture shapes, model, shell glue and report are original project material under
Apache-2.0 WITH LLVM-exception. The original issue supplies the example's structure; Clang runs externally as
a compiler and linker oracle. No compiler implementation, external fixture corpus or generated binary is included.
