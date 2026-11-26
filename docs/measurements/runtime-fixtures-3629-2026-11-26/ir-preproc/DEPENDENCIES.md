# Runtime fixture build dependency controls

These controls test the production helpers in `tools/ci/build_regression.c`
against disposable Ninja graphs. They do not rebuild or run Buster. The exact
source hosted product run remains the evidence for Buster's actual build graph;
the checked-in producer now runs that gate before packing or starting suites.

## Commands and tools

Executed from `/tmp/buster-3629` on 2026-11-26:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror \
  -o /tmp/buster3629-validation/ir-preproc/dependency-controls \
  /tmp/buster3629-validation/ir-preproc/dependency_controls.c
PATH=/home/agent/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:/home/agent/.cache/buster/toolchain/4444af0bee44de2d/build-tools/cmake-4.4.3-ninja-1.13.2/bin:$PATH \
  /tmp/buster3629-validation/ir-preproc/dependency-controls \
  /tmp/buster3629-validation/ir-preproc/dependency-graphs-final-atime \
  > /tmp/buster3629-validation/ir-preproc/dependency-controls.log 2>&1
bash tests/ci/hosted-product.sh \
  > /tmp/buster3629-validation/ir-preproc/hosted-product-controls.log 2>&1
```

The harness includes the production C file, renaming its `main`. For a replay
from another checkout, define `BUILD_REGRESSION_SOURCE` to that checkout's
absolute `tools/ci/build_regression.c` path when compiling. Give the resulting
program a fresh absolute work directory. It creates every tiny source and
Ninja file itself. Clang 23.1.4, CMake 4.4.3 and Ninja 1.13.2 were used for the
disposable graphs. The `cc` invocation compiled only the regression harness.

## Results

Both ordinary Release and a parts-style Release graph accepted all four data
controls: input edit, expected-output edit, catalog edit, and a new source and
expectation pair plus catalog row. Each control required zero compile, link and
bake commands from both a dry run and an actual Ninja invocation, an unchanged
command log, and an unchanged compiler inode, size and modification time.

The positive runner edit scheduled BACKEND's compile only, then link and bake.
The parts-style graph includes bitcode compilation, a split, two native code
parts, a relocatable merge, the final link, and the bake; all compile commands
belong to BACKEND. The positive edit is restored without executing that plan.

Eight deliberately broken graphs failed for the expected reason: an input,
expectation, catalog or added-case directory as a compile dependency; a missing
runner dependency; a second runner owner; a missing bake; and a missing link.
The last control catches an apparent link inferred from separate compile and
bake command lines. The ownership parser's existing controls also passed,
including its new single-owner rejection of C, IR, expected and catalog files
under `tests/`.

For every accepted and rejected graph, the outer harness independently checks
original bytes, inode, access time and modification time for all four originals,
the fixture directory's access/modification times, and removal of both added
files. Original access times are first made two days old, so reading them really
changes atime on a relatime mount; early-failure restoration is exercised rather
than masked by a recent read. These are ordinary failure-path controls;
SIGINT/SIGTERM restoration was reviewed through the existing shared handler.

The hosted-product script's 48 checks passed, including recording the dependency
result, deleting an earlier success receipt after a failed dependency probe, and
refusing to pack afterward. Both C compilations used `-Wall -Wextra -Werror`;
shell syntax and scoped `git diff --check` passed.

## Evidence files

- `dependency_controls.c`: replay harness, with generated tiny graph inputs.
- `dependency-controls.log`: ownership parser and ten graph outcomes.
- `dependency-graphs-final-atime/*/probe.log`: exact production probe output for
  each graph, including zero-work markers and positive/negative owner/link/bake
  outcomes. `build.log` in those directories records the tiny graph's setup.
- `hosted-product-controls.log`: producer/shard script controls.

Do not package the harness executable, tiny compiled objects or compiler copies.
