# Issue 2553: frozen corridor candidate CFG validation

This record validates the frozen corridor experiment's allocator and targeted regressions. It does not measure generated-program performance or establish issue completion. No tracked compiler source or existing test expectations were changed for these runs. No benchmark hardware was accessed or queued.

## Exact sources

The compiler checkout and existing tests are from initial candidate `d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167`, based on `8e4d32879e17b7d9548cad54257a2f8461328366`. The frozen experiment replaces only `tier1_cfg.c` using `BUSTER_CFG_SOURCE` in the standalone drivers. The source was copied to a separate file before compilation to isolate these runs from later edits.

| Item | SHA-256 |
| --- | --- |
| Frozen `tier1_cfg.c` | `60c6040975e8a7332e989a68a96776e27785f37ae4283f2b46eda31003586314` |
| `candidate-source.patch`, relative to `d3d8ad3` | `c7c0e010ce1d7bee2dca89d4a9bc4bbacac5af8f7278782365e0ed0f4f6e978c` |
| Existing `src/buster/compiler/tier1_cfg_test.c` | `12cbadb6c0680799b892eb1c4871719005fc182640899b25bc62f625ff7c686e` |

The patch digest matches the corridor measurement patch published by the root agent. Reconstructing the source from `d3d8ad3` plus this patch produced a byte-for-byte match to the frozen source used for all three runs.

The resolver has four arguments: `tier1_cfg_latch_model(input, firsts, latch, models)`. Its successful bounded path publishes a handler model for the latch, forward header route, dispatcher, and permitted no-phi unconditional backward trampoline. It keeps the graph's `firsts` and existing `siblings`/continuation contract separate. These tests do not modify that source.

## Results

All three commands exited zero.

| Run | Checks | Failures | Evidence |
| --- | ---: | ---: | --- |
| Existing full CFG suite, O3; seed 140, count 2000, oracle every 16 | 107,813 | 0 | `logs/full.log` |
| Focused original, same-operand, direct-default, trampoline, and resolver tests, O3 | 731 | 0 | `logs/focused.log` |
| Same focused tests, O1 with ASan and UBSan | 731 | 0 | `logs/sanitize.log` |

The full suite reported 1,884 allocations and 188 constraint refusals. All 1,884 allocation certificates passed, including 171 also checked by the slow oracle. All 2,072 sparse/dense allocation comparisons matched, and all 2,003 sparse live lists matched the independent walk. The unchanged continuation expectations passed. The raw log retains the allocation, move, spill, certificate, mutation, dominator, fixed-sequence, call-argument and two-problem-order counts.

The focused 731 checks comprise:

| Component | Checks |
| --- | ---: |
| Original focused regression variants and carried-predecessor guarded scan | 304 |
| Every incoming operand is the same SSA value, but the cold predecessor changes its register | 112 |
| Separate later dispatcher, with the header's direct default edge to the latch | 114 |
| Shared earlier default trampoline, including an explicit header-convention assertion | 114 |
| Resolver graph cases, publication checks and protected successor rows | 87 |

The 26 named resolver graph cases are validated as CFGs before their expected model is checked. They include both successor lane orders, two forward alternatives that each lead to a valid dispatcher, self/backward edges, no-phi unconditional trampolines, phi/branch/incorrect-destination/terminal exclusions, repeated guards, ineligible latches, missing earlier handlers, and the eighth versus ninth inspected block. Each case also checks exactly which output entries were updated; invalid paths and unrelated entries must preserve an already populated model column.

Three further valid CFGs put their final successor row immediately before a protected page, with zero, one or two entries. The zero-entry row points into the inaccessible page. These exercise the masked-load bounds. The publication assertions check that masked scatter does not update inactive/unrelated blocks. ASan and UBSan reported no diagnostics. Leak detection was disabled because this environment runs under ptrace, as in the earlier validation record; address and undefined-behavior instrumentation remained enabled, and UBSan was configured to stop on error.

The shared-trampoline allocation fixture places a no-phi default block before the latch, entered from both the later header and dispatcher. Its carried interval can merge with the cold block's displaced interval. The fixture requires the header and latch to retain the hot handler convention and their hot edges to avoid repairs, while permitting repairs on the default path. The existing semantic verifier and certificate/oracle checks run on the allocation fixtures.

## Reproduce from the source revision

Use the compiler checkout at `d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167`. The observed compiler was Clang 23.1.4 from the project's cached toolchain, targeting the available Linux/x86-64 host via `-march=native`. The flags below match the recorded runs. All test/driver files in this directory retain their original license and copyright notices.

```sh
cd /workspace/scratch/dfc32981403d/buster
cfg_cc=/home/agent/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
cfg_support=/workspace/scratch/dfc32981403d/validation/cfg-model-vector/frozen-validation
cfg_work=/dev/shm/buster-2553-model-vector
mkdir -p "$cfg_work"
git show d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167:src/buster/compiler/tier1_cfg.c \
    > "$cfg_work/frozen-test-tier1_cfg.c"
patch "$cfg_work/frozen-test-tier1_cfg.c" "$cfg_support/candidate-source.patch"
sha256sum "$cfg_work/frozen-test-tier1_cfg.c"

"$cfg_cc" -march=native -std=gnu17 -fwrapv -funsigned-char \
    -fno-strict-aliasing -O3 -Wall -Werror -Wno-unused-function \
    -Isrc -Isrc/buster/compiler \
    '-DBUSTER_CFG_SOURCE="/dev/shm/buster-2553-model-vector/frozen-test-tier1_cfg.c"' \
    "$cfg_support/cfg-validation.c" -o "$cfg_work/cfg-frozen-full" -lpthread -lm
"$cfg_work/cfg-frozen-full" --seed 140 --count 2000 --oracle-every 16

"$cfg_cc" -march=native -std=gnu17 -fwrapv -funsigned-char \
    -fno-strict-aliasing -O3 -Wall -Werror -Wno-unused-function \
    -Isrc -Isrc/buster/compiler \
    '-DBUSTER_CFG_SOURCE="/dev/shm/buster-2553-model-vector/frozen-test-tier1_cfg.c"' \
    -DBUSTER_CFG_FOCUSED_ONLY "$cfg_support/cfg-focused-propagation.c" \
    -o "$cfg_work/cfg-frozen-focused" -lpthread -lm
"$cfg_work/cfg-frozen-focused"

"$cfg_cc" -march=native -std=gnu17 -fwrapv -funsigned-char \
    -fno-strict-aliasing -O1 -Wall -Werror -Wno-unused-function \
    -fsanitize=address,undefined -fno-omit-frame-pointer \
    -Isrc -Isrc/buster/compiler \
    '-DBUSTER_CFG_SOURCE="/dev/shm/buster-2553-model-vector/frozen-test-tier1_cfg.c"' \
    -DBUSTER_CFG_FOCUSED_ONLY "$cfg_support/cfg-focused-propagation.c" \
    -o "$cfg_work/cfg-frozen-sanitize" -lpthread -lm
ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 \
    "$cfg_work/cfg-frozen-sanitize"
```

`SHA256SUMS` covers the complete record except the manifest itself. The original run binaries and isolated source copy remain in the scratch execution directory; the patch and original C drivers here are sufficient to reconstruct them.
