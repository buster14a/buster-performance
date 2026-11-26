# Exact mask round trips: cloud validation for Buster #1344

This record contains semantic checks and static generated-code observations.
It contains no execution-time measurements, hardware-counter measurements, or
new 9700X qualification. No benchpress access or hardware job was requested.

## Revisions and environment

- Base: Buster `8e4d32879e17b7d9548cad54257a2f8461328366`.
- Published change: Buster `eae745f7822b1cc15cf66063ce7cd991e9688928`.
- Local validation commit: `12253356af38fb7ea2c84788380f8723ec10f757`;
  the published commit has the identical Git tree
  `b43be7497e2d1934b96e67f5d98cdbec10e0baf3`. Publication used the GitHub
  connector because direct Git push credentials were unavailable.
- Host: cloud Linux/x86-64, Intel Xeon Platinum 8370C, with the compiler's
  required AVX-512 features.
- Toolchain: the repository's pinned Clang 23.1.4,
  LLVM `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`.
- Compiler configuration: Debug, `-O0`, native host ISA,
  `-fwrapv -funsigned-char -fno-strict-aliasing`.
- Baseline compiler SHA-256:
  `5eb1eb532f2a61dc1b8632ac17f0ad3a7f4535e1e7d38929b209e782a2760e04`.
- Changed compiler SHA-256:
  `b2abb7f25d22ec05d4b84836ef62fb9d6160931abfed886e8d5c82f9c1421932`.

The baseline executable was copied before the production source patch was
applied. Only the new external regression source and documentation differed
from the base at that point; `git diff --exit-code -- src/` passed. The new
regression was then run against that saved compiler.

Release and Develop build attempts exceeded the cloud memory limit. The
baseline Debug build succeeded with one job. The changed Debug build also
required omitting debug symbols (`-g0` instead of `-g`) for the checker and
backend units. This was a local generated-build-file adjustment only; the
repository's build description was unchanged. All other compilation flags
were retained. This configuration is suitable for correctness and emitted-code
inspection; no compiler throughput or generated-program timing is claimed.

The pinned compiler headers were selected explicitly with
`BUSTER_CLANG_RESOURCE_DIR=$(clang -print-resource-dir)`. A first attempt
without that variable stopped at missing `immintrin.h`; it was a setup failure,
not the baseline regression result retained below.

## What changes

The C intrinsic interfaces carry a mask as an integer. The existing identity
pass already recognizes a bitcast back to the original value's type, but its
caller admitted only integer and floating-point results. The fix also admits
mask-result integer bitcasts, allowing an exact `m8/m16/m32/m64 -> integer ->
same mask` round trip to forward the original mask. The existing helper's
same-type condition and DCE handle removal. Observable integer uses, actual
integer arithmetic, and changes in width remain meaningful.

## Regression evidence

`patterns-base.log` is the expected failing run of the extended
`tests/driver/tier1_patterns.c` against the unmodified compiler. All 38 existing
functions and all eight new mask functions compiled strictly through Tier 1,
with zero fallbacks; all eight mask bodies were certified. The native oracle
passed. Exactly the six positive mask shapes failed:

| Fixture | Base mask to integer | Base integer to mask | Changed mask to integer | Changed integer to mask |
| --- | ---: | ---: | ---: | ---: |
| `patterns_mask8_blend` | 1 | 1 | 0 | 0 |
| `patterns_mask16_blend` | 1 | 1 | 0 | 0 |
| `patterns_mask32_blend` | 1 | 1 | 0 | 0 |
| `patterns_mask64_blend` | 1 | 1 | 0 | 0 |
| `patterns_mask64_compress` | 1 | 1 | 0 | 0 |
| `patterns_mask64_shared` | 1 | 2 | 1 | 0 |

The shared case returns the mask's integer bits while two consumers use its
opmask value. Its one required mask-to-integer move must remain. The XOR and
narrowing cases retain independently checked changed-bit semantics; their
move count is not prescribed. The baseline stops after its expected default
shape failure and therefore does not claim a second scalar-path execution.

The native oracle checks 256 mask-pattern cases and 784 mask subject calls per
execution, covering all four widths, every single set/clear bit, high bits,
zero/all ones, alternating masks, unaligned input/output, and output guards.
Mask fixtures use a separate object targeted at `x86-64-v4` plus AVX512VBMI2;
the existing fixtures keep their original target. Both link to one Clang-built
independent byte oracle. The shape parser counts only GPR/opmask transfers,
excluding mask-to-mask and memory moves.

The IR regression covers all widths with identities off and on, repeated
round trips, live integer arithmetic, changed widths, truncation followed by
extension, and defined/undefined phi edges. Its independent interpreter checks
expected values and undefinedness before and after optimization.

`patterns-head.log` passes native semantics and every shape in both default
and `--scalar` modes: 38/38 existing and 8/8 mask functions compiled through
Tier 1 with zero fallbacks on each run; all eight mask bodies certified.
`patterns-head.asm` is a separate capture made with the same default compile
commands, because successful harness runs remove their temporary outputs.
Mask records decrease from 86 to 74, matching the twelve redundant moves
removed from these fixtures. XOR and narrowing each retain one transfer in
each direction and pass the native oracle.

`validation.log` records six passing suites, totaling 3,130,888 checks:

| Command | Checks | Failures |
| --- | ---: | ---: |
| `test-ir-optimize` | 338,394 | 0 |
| `test-ir-inline` | 125,243 | 0 |
| `test-ir-gvn` | 2,195,108 | 0 |
| `test-ir-licm` | 3,805 | 0 |
| `test-tier1-emit` | 257,194 | 0 |
| `test-tier1-masks` | 211,144 | 0 |

The mask suite also executes 1,280 native runs against the interpreter.

One broader test did not pass in this environment:
`test-tier1-pipeline --cross-check` reports three failures, with identical
full diagnostics on the base and changed compilers (`pipeline-base.log` and
`pipeline-head.log`, verified with `cmp`). Two failures are deadline/subreaper
cleanup assertions. Those gate the Clang cross-check in
`tier1_pipeline_test.c`, so the third assertion reports its absent results.
The run still reports 1,088 native results and 320 native boundary pairs.
This is an unchanged local limitation, not a passing cross-check claim.

## Small probe and lexer object

`mask-probe.c` is the exact input for `mask-base.asm` and `mask-head.asm`:

```sh
export BUSTER_CLANG_RESOURCE_DIR="$(clang -print-resource-dir)"
"$compiler" --tier1 --tier1-strict --verify -march=znver5 \
  -fno-asynchronous-unwind-tables -c mask-probe.c -o mask.o
objdump -dr -Mintel mask.o
```

Its blend and compress functions each have two GPR/opmask moves on the base.
The changed compiler emits neither transfer in either function; the original
comparison's opmask feeds the blend/compress directly.

The same probe confirms a separate construction issue, tracked in
[Buster #3641](https://github.com/buster14a/buster/issues/3641): `lane0` has eight
zero stores plus one scalar store, and `distinct` has eight zero stores plus
eight scalar stores, followed by a 64-byte vector reload from the temporary.
Those constructors are outside this mask identity fix.

The real lexer benchmark unit was compiled with:

```sh
"$compiler" --tier1 --tier1-report --lanes 1 \
  -fno-asynchronous-unwind-tables -march=znver5 -Isrc \
  -fwrapv -funsigned-char -fno-strict-aliasing \
  -c src/buster/compiler/c_lexer_benchmark.c -o lexer.o
objdump -dr -Mintel lexer.o
```

`lexer-base.log` and `lexer-head.log` record actual Tier 1 selection. The
compressed assembly captures and `lexer-*-moves.tsv` retain static GPR/opmask
move counts by function. These are instructions present in an object, not
executed instructions per byte. Both revisions compile all 33 functions at
Tier 1 with zero fallbacks. Each of the nine `tokenize_c*`/`tokenize_cpp*`
variants loses five transfers in each direction, 90 instructions in total:

| Whole object | Mask to integer | Integer to mask | Total |
| --- | ---: | ---: | ---: |
| Base | 951 | 223 | 1,174 |
| Change | 906 | 178 | 1,084 |

Tier 1 records decrease from 57,619 to 57,529; spill, call-save and frame
counts remain unchanged in the retained reports. The changed unit's one-lane
and four-lane objects compare byte-for-byte equal, with all 18 expected
`memmove` relocations (`lexer-lane-check.log`). The `znver5` lexer objects
were inspected, not executed as a benchmark.

The TSV counts were derived from `objdump -d --no-show-raw-insn -Mintel`:
group by each function label, count `kmov[bwdq]` whose two operands are a GPR
and a mask register, and retain the transfer direction. Memory and mask-to-mask
moves do not match. The complete disassembly is retained for checking these
counts independently.

## Historical #1344 disposition

The original issue measured the `e6c4fc3c` self-host at 43.795 instructions/B
against Clang `-O3`. The later investigation used `ca2bd994` and subsequent
revisions: an exact instruction census of one synthetic 9,076-byte call,
plus aggregate source-tree counters against Clang `-O2`. It did not reproduce
the archived binary's exact breakdown or the original comparator.

The constant-construction fixes and their historical measurements are retained
in these exact records:

- [#2742's SROA and quadword splats](https://github.com/buster14a/buster-performance/tree/6a1fcbc6beb4e842ef4a16510049d94477e145f6/docs/measurements/tier1-vector-lexer-breakdown-1344-2026-11-14).
- [#2790's default vector/mask GVN and LICM](https://github.com/buster14a/buster-performance/tree/4f15eeec141802cb74089fd2d4827bce3562a131/docs/measurements/vector-passes-2781-takeover-2026-11-14).
- [#2794's literal pool](https://github.com/buster14a/buster-performance/tree/75246dbea988fac28270f1aaa3f0bdce053fae88/docs/measurements/tier1-literal-pool-2744-2026-11-15).

Remaining constant-operand work is tracked by #2744; vector allocation above
register 15 by #3625; runtime-scalar vector construction by #3641. The new mask
fix adds structural and semantic evidence only. Historical improvements are
not multiplied together or presented as a current-main speed ratio.

## Attribution

Agent session: `6b07efae-73e4-83ed-af93-f13051120044` (OpenAI session ID;
no share URL exposed). Model: OpenAI / GPT-6 Astra Pro. All contributing
agents share that session and model. Their child thread identifiers are:

- `/root/implementation_audit`: `6b07f0c3-e05c-83ed-926c-5a5b81d3b043`.
- `/root/followup_audit`: `6b07f0d1-ade0-83ed-a8dd-212e47183054`.
- `/root/acceptance_audit`: `6b07f0b0-2520-83ed-8afc-6972fca00040`.
