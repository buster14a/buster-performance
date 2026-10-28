# Lowering review and integration correctness, 2026-10-28

Additional correctness evidence for Buster #656/#660/#661/#667/#675 and the
#635 interaction. There is no new timing claim. Earlier measurement records
remain evidence for their pinned source/binary/workload identities.

## Retained payloads and bounded bit fields

Buster `6c0428b145fa5e9043d663880e1a89a8c68b82e9` integrates #660 with main
`31fab239744091de6b0f43c23e8fd60edf3960ba`, including #656 retained payloads,
#661 memory recipes and #675 packed lowering. The checked-plan test now passes
the retained-byte arena and restores both arena suffixes per case.

`pr660-focused.c` passed **49,992 checks, zero failures** on the Ryzen 9 7940HS
laptop, Clang 23.1.4, ASan/UBSan. It covers guarded bit-field widths/offsets
through packed128, ordered overlaps, adjacent/wide relocations, metadata-only
scratch, retained payloads and late binding/capacity rollback. Executable SHA-256:
`cd7c48bdb1cb3810d40f7fc53c93f3893ecc3f12ef7cf2f77cc6971492537ed0`.

From the pinned compiler source:

```sh
clang -O1 -g -march=native -fwrapv -funsigned-char -fno-strict-aliasing \
  -ffunction-sections -fdata-sections -fsanitize=address,undefined \
  -Wno-unused-function -Isrc /path/to/pr660-focused.c \
  -Wl,--gc-sections -lm -ldl -o /path/to/pr660-focused
/path/to/pr660-focused
```

## Initializer pools and errno identities

The original reproduction `repro667.c` combines a pooled local initializer with
`__builtin_sqrt`. The old local executable rejected `-c --lanes 1` with `code
output capacity exhausted`; the fixed executable accepted the same source.
The old-source failure was also observed through the shared 9700X lock. This
was a symbol collision, rather than an actual output-capacity shortage.

Fix `16bff5263f0bc9ea8ac326af4b2acaa9baa53d79` reserves every initializer-pool
identity before synthesizing `__errno_location`. New source tests exercise
both synthesized and explicitly declared accessors with pools, scalar/vector
lowering, emitted Link/native behavior and an external Clang oracle.

The optimized local build (`BUSTER_DEBUG_INFO=0 ./build.sh`) passed **711 focused
initializer checks**. Full checker seed598 ran **267,875 checks**, with only
the four documented laptop Clang `fpclassify` oracle disagreements. Those
failures are retained in `raw/pr667-checker.log`, not represented as a pass.

Local executable SHA-256:

- Before: `a977a3f2d88f75774a0318d896363a0b97a919833b61a979261f614b67f30d8a`.
- Fixed: `6296879718047dfe3ed4e244d349c8a88374e3db14cc8aa51add5df2630ddf45`.

The before source checkout was at
`d59ff8e08f8ecd4b31ae758af5212071d14260d5`, whose last commit only documented
the implementation. These local executable identities differ from the
9700X benchmark binaries and do not authorize reusing their measurements.

## Packed tasks, volatile copies and runtime domains

Buster `0cc92d9f1a20a6fcbfa5a6c38c3def8962b93872` integrates #635's corrected
volatile containment, destination initialization qualifiers and converted return
sources with main31fab239. Packed task bit43 retains copy volatility; the private
forwarding worklist uses spare packed-control slots. Containment facts are
computed before the packed type lookup. Combined ASan/UBSan/native-Clang and
batch/packed-task checks passed **35,030/0**.

Intermediate Buster `13ace0e53c46cf7a678c35f4c67b5df2864631ae` combines that head
with #667. It retains distinct MEMMOVE/MEMCPY names and identities, reserves all
initializer pools before runtime symbols, and preserves packed FILL, CLEAR byte
offsets and INITIALIZER_COPY payloads. A new 513-byte local-record fixture
combines pooled initialization, assignment, sqrt/errno and omitted zero tails.
This head subsequently received the preparation-cost correction below; these
results remain its named intermediate evidence.

The focused adapters use the pinned main.c include prefix with module-home
linkage made static solely for a standalone test executable. Build against the
corresponding compiler source:

```sh
clang -O1 -g -fsanitize=address,undefined -march=native -Isrc \
  -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror \
  -Wno-unused-function -Wno-unused-variable -Wno-undefined-internal \
  /path/to/ADAPTER.c -o /path/to/ADAPTER -lpthread -ldl -lm
/path/to/ADAPTER
```

At 13ace0e5, the joint adapter passed **35,884/0** under ASan/UBSan, including
native Clang comparisons. Its full 41-unit release executable also passed:

- Driver **21,632/0**; function workers/fallback **2,695/0**.
- Deferred checker **1,113/0**, 70 fixtures and 6,492 separately read bodies.
- c-testsuite pin `5c7275656d751de0e68b2d340a95b5681858ed07`: **220/220**, with
  external Clang cross-checks. No corpus source is included.
- Full checker seed598: **336,552 checks, four failures**, solely the retained
  laptop fpclassify oracle disagreements.
- Source call graph: 41 units, 24,912 functions, 147,215 direct calls, zero
  disallowed cycles, three existing allowed cycles and zero split variables.

The first parallel-list invocation omitted required headings and exited before
running tests. Its usage error is retained separately from the corrected list's
successful four-command run. Run the list from its compiler checkout, replacing
the corpus path with a checkout at the exact pin. The call-graph command is
`BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph`.

## Preparation work and permanent mutation check

The independent work-count adapter constructs distinct, one-member char[131]
record types through the production TypeTable API and compatible typed
initializer plans. It intercepts memset
only during pool preparation, counting calls whose size equals the frozen
type-table count T. The selected-column and image sizes differ from T for all
four cases. Both versions prepare P complete pools successfully.

| P records | T types | Before clears | Before bytes | Revised clears/bytes |
| ---: | ---: | ---: | ---: | ---: |
| 32 | 97 | 32 | 3,104 | 0 / 0 |
| 64 | 129 | 64 | 8,256 | 0 / 0 |
| 128 | 193 | 128 | 24,704 | 0 / 0 |
| 256 | 321 | 256 | 82,176 | 0 / 0 |

The old per-prefix walker therefore adds P*T clearing work, apart from the
record walk and the unavoidable payload construction. The revised planner uses
the existing unit-wide contained-volatile facts computed once before pooling;
each prefix uses a bounded lookup. Runtime numbering still follows final pool
counts, and packed expression templates consume the same completed facts.

The permanent regression has 32 record plans, hundreds of unrelated types,
and only 256 bytes of pool-planning scratch. It checks exact byte images and
that every result is a complete-prefix pool (`part == BUSTER_CHECK_NONE`), not
a per-literal fallback pool. The fixed snapshot passes **2/0**. Restoring only
the old traversal in the same snapshot passes setup but fails that assertion:
**2 checks, 1 failure**, exit1. The patch and both logs are retained. This pins
the intended path even though the old walker could fall back to a BYTES pool
after its type-sized scratch allocation fails.

These are deterministic work and correctness results, not target timings.
The old counter uses frozen 13ace0e5. The revised counter and permanent pair
used an isolated reordered source snapshot, not a claim of an additional run
at the later final commit. Its production hashes, also verified to match the
final commit, are:

- initializers.c: `74f5a48fa90a5eab8eec0601555aa5fa1eeb9c68b758c1556bda12f1387bd19e`.
- lower.c: `dffbab6450981bde7d6d257e21052d17ae40d4eae78b5811e912d8bcca428da4`.

Counters compiled with Clang23.1.4 at O1; the permanent fixed/mutant pair compiled
at O0 with debug information. `commands.txt` retains the original invocations.

## Final source validation

The final preparation correction is Buster
`0b20949929bbc864f38b4804e8fda61f51cca9c6`. The shared class/fact columns are
prepared once after helper/asm planning, before pool planning. ABI preparation
and packed expression templates remain later. The old pool traversal and its
type-sized per-prefix scratch are removed. The type table stays frozen.

Final laptop validation at this source:

| Check | Result |
| --- | ---: |
| Joint ASan/UBSan, packed tasks + volatile copies + pools | 35,886 / 0 |
| Release checker seed598 | 336,554 checks; four known fpclassify oracle failures |
| Driver | 21,632 / 0 |
| Function workers/fallback | 2,687 / 0 |
| Deferred checker | 1,113 / 0 |
| Pinned c-testsuite with Clang | 220 / 220 |
| Call graph | 41 units; 24,913 functions; 147,214 calls; 0 bad cycles, 3 allowed, 0 split |

The complete 41-unit release build and the source call-graph check passed.
`raw/pr667-final-*` contains the original final outputs. A draft of the new
low-level test initially left TypeMember.bit_width at zero, which denotes an
invalid named zero-width field rather than a normal member. That setup failed
before testing scratch behavior; the two draft outputs are retained separately
under `raw/draft-fixture/`. The final and both mutation snapshots use the
correct `BUSTER_TYPE_NOT_BIT_FIELD` sentinel. No draft result is counted above.

The mutation patch's archived working copy has normalized a/b paths and passes
`git apply --check` against the final source. Its original auditor-generated
headers are retained separately in `raw/original-mutation.patch`.

## Provenance and scope

The new runners and reproduction inputs are original project material. Focused
runners call existing independent project tests; Clang is an external semantic
oracle. The work-count adapters and generator are original. No external
implementation or corpus source is imported. Laptop
sanitizer/native checks do not substitute for target CI or establish performance.
