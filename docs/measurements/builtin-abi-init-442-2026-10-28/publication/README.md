# Publication composition checks

Exact head: `ec96e1a07703a63a88246a2939d04dce15e0e32c`.

The frozen candidate `73b6ba60604ca3da7494375f2468b23ae7d4c258` was preserved. A new publication branch normally merged freshly verified main `c9a433b5558d07af180dba00486f805e355b61f9`, yielding `c21b72d18b049932eb7bd11dd3dd3b615a294348`. The final commit only adds the evidence link, measured scope and costs to the ABI guide. There was no history rewrite, source conflict or altered ABI mechanism; the automatic documentation merge retained main's additions. The original development worktree remains at the frozen candidate.

| Current-composition gate | Result |
|---|---|
| Normal release build, Clang23.1.4/native/debug1, `cores -n 2` | All41 sources pass;171.8s after the fair queue wait. |
| `test-calling-convention` | All default ABI groups pass, including51,259 independent builtin-prefix checks, both char modes and widths16/32/64; no failures. |
| Current generator compile/run and `cmp` | Byte-identical projection; both hashes retained. |
| CI consumer selector |1,173 checks,0 failures. |
| Source whitespace and worktree | Clean. |

The focused commands are short serial single-threaded runs (the ABI command took0.063s; generator compilation/regeneration0.356s), covered by the repository's shorter-command rule. An initially unnecessary queued two-core generator/selector request was cancelled while still waiting, using that wrapper's supported SIGTERM/EXIT cleanup; no other job was cancelled. The full41-source build used its granted two cores. No native target action or new timing campaign was performed.

These gates qualify this local publication composition. The frozen cross400/guard/sanitizer/corpus/object-equality/native timing records remain attributed to `73b6ba60`/`e7f89091`, not relabeled as publication-head results. A new local external cross400 was not run, and full required PR CI remains separate.

Commands, from the publication checkout:

```sh
BUSTER_DEBUG_INFO=1 BUSTER_HOST_ARCH=native cores -n 2 -- ./build.sh
./build/compiler test-calling-convention
clang -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wno-unused-function -pthread tools/generate_builtin_abi.c -o /path/to/scratch/generate-builtin-abi
/path/to/scratch/generate-builtin-abi > /path/to/scratch/builtin-facts.c
cmp src/buster/compiler/calling_convention_builtins.c /path/to/scratch/builtin-facts.c
cc -std=c17 -O2 -Wall -Wextra -Werror tools/ci/changes.c -o /path/to/scratch/changes
/path/to/scratch/changes --self-test
git diff --check
```

The adjacent receipts retain exact binary/toolchain/source/blob identities and output. None establishes a current-main CLI throughput improvement or neutral equivalence bound.
