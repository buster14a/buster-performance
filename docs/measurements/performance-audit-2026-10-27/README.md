# Performance discovery audit — 2026-10-27

This record supports nine distinct findings in Buster at [`8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9`](https://github.com/buster14a/buster/commit/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9). It contains original synthetic reproducers, fresh-process measurements, and local attribution probes. It proposes no compiler change and establishes no before/after speedup or general corpus impact.

## Provenance and method

- Compiler source: the exact revision above, unmodified. The source archive was built separately on each host with `BUSTER_DEBUG_INFO=0 ./build.sh` (Clang, repository release flags including `-O3 -march=native`).
- Target: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, Clang 23.1.1. The build and each target measurement command used the shared `~/buster-fast-bench/exclusive.sh` lock. Timed commands used `taskset -c 2`; sibling CPU 10 was offline. Metadata, build log, executable and input hashes are retained in `9700x/`.
- Target timing: built-in `time-runs --runs 5 --warmups 1`, fresh child processes, rotating list order, one warmup for each argument list. Compile cases explicitly use `--lanes 1`; preprocess cases use `-E -P`. The table reports medians; raw logs retain all samples and ranges. Lock waits are outside child wall time.
- Instructions and user cycles come from the tool's hardware counters. Peak RSS is the process peak reported in KB by the tool. Medians of different columns need not belong to the same sample.
- `local-screen/` comes from a separate Ryzen 9 7940HS (Zen 4) development host. Those exploratory timings and sampled profiles are **not 9700X qualification**. They help isolate stages and failure conditions. Do not mix their timings with the target table.
- All measured accepted target samples have exit status 0. Deliberate refusal probes are identified separately. `time-runs` compares status with its warmup, so its final "0 failed processes" message alone is not an acceptance check.
- No full compiler test, sanitizer, corpus or generated-program runtime campaign was performed. Synthetic scaling is evidence of the mechanisms below, not of their frequency in real applications.

## Reproduce

The original, self-contained [C generator](generate.c) has no external dependencies. Build it with:

```sh
clang -O2 -Wall -Wextra -Werror generate.c -o generate
mkdir -p work/cases results
./generate overload 2000 > work/cases/overload-2000.c
./generate overload 4000 > work/cases/overload-4000.c
./generate overload 8000 > work/cases/overload-8000.c
export EXCLUSIVE_OWNER=performance-audit
export EXCLUSIVE_TITLE='Buster performance scaling'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues
~/buster-fast-bench/exclusive.sh taskset -c 2 source/build/compiler time-runs --runs 5 --warmups 1 \\
  --list --lanes 1 -c work/cases/overload-2000.c -o results/out.o \\
  --list --lanes 1 -c work/cases/overload-4000.c -o results/out.o \\
  --list --lanes 1 -c work/cases/overload-8000.c -o results/out.o
```

Here `source/build/compiler` is the pinned target build. Each family uses the same invocation pattern. Use `vla`, `generic`, `generic_const`, `nested`, or `chain` instead of `overload`; VLA also has 16,000 and 32,000 cases. For the isolated record-name test replace `-c ... -o results/out.o` with `-fsyntax-only ...`. For `macro`, `macro_unused`, and `macro_nested`, use 1,000/2,000/4,000 and `--list -E -P work/cases/KIND-N.c -o /dev/null`.

For zero-fill compare `./generate bss 268435456` with `./generate zero 268435456`, each using the compile invocation. For copy validation generate `copy` at 256, 512, 1024, 2048, 4096, 8192 and 16384; compile each under the target lock and inspect with `size -A`. Check the last case separately with `-fsyntax-only`. The comparison object uses `clang -O0 -c`. Source text and exact sizes are also evident in the generator and raw command lines.

## Target measurements

| Family / mode | N | Median wall, ms | User instructions | Peak RSS, KB |
|---|---:|---:|---:|---:|
| [chain](9700x/chain-time.txt) | 2,000 | 6.128 | 127,603,075 | 45,220 |
| [chain](9700x/chain-time.txt) | 4,000 | 14.145 | 415,513,482 | 54,192 |
| [chain](9700x/chain-time.txt) | 8,000 | 44.663 | 1,519,321,837 | 82,332 |
| [generic](9700x/generic-time.txt) | 2,000 | 15.716 | 450,744,259 | 54,088 |
| [generic](9700x/generic-time.txt) | 4,000 | 49.949 | 1,677,796,631 | 67,416 |
| [generic](9700x/generic-time.txt) | 8,000 | 183.516 | 6,507,867,991 | 110,228 |
| [generic_const](9700x/generic_const-time.txt) | 2,000 | 17.394 | 467,270,042 | 53,748 |
| [generic_const](9700x/generic_const-time.txt) | 4,000 | 56.945 | 1,746,871,912 | 67,128 |
| [generic_const](9700x/generic_const-time.txt) | 8,000 | 213.129 | 6,790,041,564 | 109,832 |
| [macro](9700x/macro-time.txt) | 1,000 | 0.972 | 12,038,041 | 12,344 |
| [macro](9700x/macro-time.txt) | 2,000 | 1.899 | 42,545,714 | 12,392 |
| [macro](9700x/macro-time.txt) | 4,000 | 5.428 | 161,317,225 | 18,792 |
| [macro_nested](9700x/macro_nested-time.txt) | 1,000 | 6.598 | 193,416,220 | 33,172 |
| [macro_nested](9700x/macro_nested-time.txt) | 2,000 | 22.772 | 769,814,099 | 80,344 |
| [macro_nested](9700x/macro_nested-time.txt) | 4,000 | 88.509 | 3,071,611,073 | 258,652 |
| [macro_unused](9700x/macro_unused-time.txt) | 1,000 | 0.781 | 8,166,296 | 12,220 |
| [macro_unused](9700x/macro_unused-time.txt) | 2,000 | 1.347 | 29,806,816 | 12,164 |
| [macro_unused](9700x/macro_unused-time.txt) | 4,000 | 3.562 | 115,842,194 | 12,248 |
| [nested](9700x/nested-time.txt) | 2,000 | 5.907 | 127,524,613 | 32,760 |
| [nested](9700x/nested-time.txt) | 4,000 | 15.679 | 424,436,104 | 51,728 |
| [nested](9700x/nested-time.txt) | 8,000 | 51.109 | 1,568,459,301 | 63,128 |
| [nested-syntax](9700x/nested-syntax-time.txt) | 2,000 | 2.866 | 21,818,200 | 27,416 |
| [nested-syntax](9700x/nested-syntax-time.txt) | 4,000 | 5.796 | 51,404,100 | 46,516 |
| [nested-syntax](9700x/nested-syntax-time.txt) | 8,000 | 13.930 | 132,776,078 | 57,884 |
| [overload](9700x/overload-time.txt) | 2,000 | 33.792 | 974,875,597 | 64,832 |
| [overload](9700x/overload-time.txt) | 4,000 | 119.015 | 3,734,049,621 | 99,000 |
| [overload](9700x/overload-time.txt) | 8,000 | 449.310 | 14,652,425,148 | 144,264 |
| [vla](9700x/vla-time.txt) | 2,000 | 13.506 | 70,455,268 | 41,688 |
| [vla](9700x/vla-time.txt) | 4,000 | 10.738 | 173,115,194 | 62,824 |
| [vla](9700x/vla-time.txt) | 8,000 | 27.899 | 522,515,207 | 84,760 |
| [vla-large](9700x/vla-large-time.txt) | 16,000 | 86.579 | 1,797,294,372 | 135,832 |
| [vla-large](9700x/vla-large-time.txt) | 32,000 | 234.294 | 6,650,980,640 | 204,200 |
| [zero / bss](9700x/zero-time.txt) | 268,435,456 | 1.766 | 15,716,558 | 21,676 |
| [zero / zero](9700x/zero-time.txt) | 268,435,456 | 18.194 | 69,203,145 | 281,824 |

All 170 timed samples in these rows exited 0. Warmups are additional. The separate [copy validation](9700x/copy-validation.txt) reports:

| Copied struct bytes | Buster .text bytes | Compile status |
|---:|---:|---:|
| 256 | 181 | 0 |
| 512 | 377 | 0 |
| 1024 | 765 | 0 |
| 2048 | 1541 | 0 |
| 4096 | 3093 | 0 |
| 8192 | 6197 | 0 |
| 16384 | — | 1: code output capacity exhausted |

The 16,384-byte source passes Buster syntax checking. Clang 23.1.1 at `-O0` emits 40 bytes of `.text` for the 8,192-byte source, with a memcpy relocation. This is a code-size comparison, not a measured runtime comparison. Locally, both 256 MiB zero-fill forms emitted 688-byte object files whose sole allocatable storage is `.bss`; see [section/file sizes](local-screen/zero-sections.txt).


## Findings and source attribution

### zero: explicit zero initializers materialize the entire BSS object in compiler memory

`char a[268435456] = {0};` emits a tiny BSS object but allocates, zeroes and scans a 256 MiB scratch buffer. The equivalent tentative definition `char a[268435456];` avoids that buffer.

`check_data_plan_object` allocates `plan->size` bytes whenever a nonempty initializer plan exists, clears them, replays the initializer (including a full-object CLEAR), then OR-reduces every byte to decide whether the atom is BSS. It discovers an already-known all-zero result only after touching the entire object.

Source: [c_check_data.c:424–443](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_data.c#L424-L443), [c_check_data.c:498–534](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_data.c#L498-L534), [c_check_data.c:623–639](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_data.c#L623-L639).

Suggested acceptance: Recognize a final all-zero, relocation-free initializer without allocating object-sized storage. Preserve source-order overrides, floating representations, bit-fields, TLS, readonly placement and fixups. Include large `{0}`/`{}` cases and the equivalent tentative-definition control; measure RSS and elapsed time as well as output bytes.

During measurement, an independent report appeared as [buster#596](https://github.com/buster14a/buster/issues/596). This record adds execution evidence there rather than opening a duplicate.

### copy: large struct assignments expand into thousands of instructions and exhaust code capacity

An assignment of an 8,192-byte struct produces 6,197 bytes of `.text`; the same operation compiled with Clang -O0 produces 40 bytes and a memcpy relocation. At 16,384 bytes, Buster accepts `-fsyntax-only` but `-c` fails with `code output capacity exhausted`.

`check_lower_copy` divides an aggregate copy into 256-byte COPY entries (`BUSTER_TIER0_MAX_COPY_BYTES`) and emits address/temporary operations for every piece. Tier 0 expands each piece inline. The lowering capacity is estimated from syntax/graph node counts, which do not grow when only the array bound changes.

Source: [c_check_program_lower.c:1247–1293](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_program_lower.c#L1247-L1293), [c_check_program_lower.c:5090–5101](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_program_lower.c#L5090-L5101), [tier0.c:330–330](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/tier0.c#L330-L330).

Suggested acceptance: Add a bounded-code strategy for large copies and count/allocate its actual lowered demand. Preserve exact tails, same-object assignment, alignment and ABI clobbers. Test 256 B through at least 1 MiB with bytewise execution oracles and measure `.text`, compiler cost and generated runtime before selecting a threshold.

During measurement, an independent report appeared as [buster#597](https://github.com/buster14a/buster/issues/597). This record adds execution evidence there rather than opening a duplicate.

### vla: each VLA declaration scans every earlier VLA record, making source checking quadratic

A function containing N simple VLA typedefs does N growing scans through the translation unit's VLA records, even though each declaration introduces just one bound.

`check_input_vla_declaration` loops from zero to `reader->output->vla_count` for every variably modified declaration. It searches old records to associate a new declaration and repeats body/scope updates. The related parameter path also starts at zero. For N one-bound typedefs, the declaration loop visits N(N+1)/2 records.

Source: [c_check_vla_input.c:291–319](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_vla_input.c#L291-L319), [c_check_vla_input.c:323–345](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_vla_input.c#L323-L345).

Suggested acceptance: Associate each declaration/parameter list with its new VLA record span or a direct index, preserving source-point evaluation, scope intervals, typedef reuse, nested dimensions and deferred-lane ownership. Add scaling coverage with 2k/4k/8k and 16k/32k simple VLA declarations.

### generic: _Generic duplicate-type checking performs every pairwise compatibility query

A valid `_Generic` with N distinct nominal struct associations performs N(N-1)/2 type compatibility queries. The ordinary expression and constant-expression readers both have this behavior.

Both selection implementations append each association to `seen` and compare it with every prior entry using `type_compatible_at`. Distinct struct tags already establish that these associations cannot duplicate one another, yet every pair still enters the general compatibility/merge machinery.

Source: [c_check_select.c:138–163](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_select.c#L138-L163), [c_check_constant.c:1540–1572](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_constant.c#L1540-L1572).

Suggested acceptance: Use canonical/coarse type keys to eliminate impossible duplicates before exact compatibility checks, retaining exact fallbacks where C compatibility is broader than TypeId equality. Preserve duplicate diagnostics, default handling, compatible arrays/functions where applicable, qualifiers, and transparent-union/source-point rules. Check both ordinary and enum-constant forms.

During measurement, an independent report appeared as [buster#602](https://github.com/buster14a/buster/issues/602). This record adds execution evidence there rather than opening a duplicate.

### overload: declaring a large overload set repeatedly scans its full active and linkage history

Declaring N distinct `__attribute__((overloadable))` prototypes under one name becomes quadratic before any overload call is made.

`check_overload_declare` walks every prior active candidate and compares signatures for each new declaration. `check_input_overload_declare` then walks the name's linked history and repeats signature comparisons. The reproducer uses distinct pointer-to-struct parameter types, so a signature index can reject almost every candidate immediately.

Source: [c_check_overload.c:149–177](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_overload.c#L149-L177), [c_check_overload_input.c:104–140](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_overload_input.c#L104-L140).

Suggested acceptance: Index declaration signatures and canonical/linkage records, keeping exact compatibility checks for matching keys. Preserve redeclarations, scope restoration, linkage, attributes, definitions and call ambiguity diagnostics. Measure declaration-only workloads separately from overload resolution at call sites.

### abi: ABI classification rescans the pending type list once per dependency level

A translation unit containing only a chain of nested-by-value record types incurs quadratic ABI preparation, despite emitting no functions or objects.

`abi_classify_levels` scans all pending types to collect one ready level, classifies that level, then scans the remaining types again. A chain exposes one record per iteration, for N(N+1)/2 readiness visits. `check_lower_prepare` invokes classification of all types even for this declaration-only unit. The `chain` generator uses separate top-level declarations, so this does not depend on deep parser nesting or record-name scratch clearing.

Source: [calling_convention.c:3074–3138](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/calling_convention.c#L3074-L3138), [c_check_program_lower.c:5173–5184](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_program_lower.c#L5173-L5184).

Suggested acceptance: Schedule dependencies with ready queues/indegrees or another work-efficient approach while preserving the scalar/vector semantic oracle and incremental type-table behavior. Avoid unnecessary ABI preparation for units without ABI consumers where possible. Measure 2k/4k/8k/16k chains and wide independent records.

### record: record name validation clears tables sized by the whole nested token span

For lexically nested named records, each record has only one direct member, but name validation clears a hash table sized for all tokens inside that record. Summed over nesting depth, those clears are quadratic.

The caller passes `frame->close - frame->token + 1` as `bound`. `check_input_record_names` rounds `2*bound+1` to a power of two and clears that many uint32_t slots on every call. Named aggregate fields do not expand the namespace (as the file's own contract states), so nested tokens are an especially loose bound. This is a definition-time namespace cost, separate from #591's member-access lookup.

Source: [c_check_record_input.c:7–32](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_record_input.c#L7-L32), [c_check_input.c:2330–2338](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_check_input.c#L2330-L2338).

Suggested acceptance: Size clearing/work to actual introduced names, or use a reusable generation-stamped table. Keep anonymous-member expansion, duplicate diagnostics, bounded scratch failures and layout behavior correct. Measure `-fsyntax-only` to isolate this cost from ABI preparation.

### macro: macro parameter validation and replacement indexing are quadratic in parameter count

A legal function-like macro with thousands of distinct parameters pays a quadratic duplicate-name scan even when never expanded; first expansion adds linear parameter lookup for every replacement token.

`pp_define_parameters` revisits all previous parameter-list tokens for each new name. `pp_parameter_index` subsequently scans the stored parameter list for each identifier in `pp_compile_macro`. A replacement mentioning every parameter therefore adds another triangular search. The measured sizes are 1,000/2,000/4,000, below Buster's 4,096-parameter limit.

Source: [c_preprocessor.c:5124–5133](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_preprocessor.c#L5124-L5133), [c_preprocessor.c:5290–5299](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_preprocessor.c#L5290-L5299), [c_preprocessor.c:5344–5352](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_preprocessor.c#L5344-L5352).

Suggested acceptance: Build a parameter-name index once and use it for duplicate detection and replacement compilation, with a cheap small-list path if measurements favor it. Preserve diagnostic order, variadics, #, ## and __VA_OPT__. Compare unused definitions with invoked definitions so the two costs remain distinguishable.

### macro_nested: nested identity macros consume quadratic work and argument storage for one output token

`#define F(x) x` followed by `F(F(...F(1)...))` produces one token, but nested argument collection repeatedly scans and copies the remaining invocation. The working set grows roughly quadratically.

Deep invocations exceed the fast collector's depth-63 bound and use `pp_collect_token`. Each outer argument is copied into `pp->arguments`; expanding the next nested F collects the shrinking suffix again while outer argument storage is retained. At depth 8,000 the local reproduction reaches the 67,108,864-token expansion limit although final output is `1`.

Source: [c_preprocessor.c:7472–7475](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_preprocessor.c#L7472-L7475), [c_preprocessor.c:7755–7788](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_preprocessor.c#L7755-L7788), [c_preprocessor.c:8213–8225](https://github.com/buster14a/buster/blob/8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9/src/buster/compiler/c_preprocessor.c#L8213-L8225).

Suggested acceptance: Represent nested argument slices without repeatedly materializing every suffix, and retain correct prescan/rescan, disabled-macro, origin and whitespace semantics. Exercise 1k/2k/4k depths, scalar/vector agreement, token limits and RSS. Do not merely raise the expansion limit.

## Interpretation and limits

- Small VLA wall-time samples were noisy (the 2,000 case ranged from 5.176 to 25.145 ms). Use its instruction growth and the separately retained 16k/32k run, not a wall-time ratio derived from that small case. The larger cases also varied: 16k ranged from 75.007 to 97.282 ms and 32k from 225.885 to 315.483 ms; their instruction growth is more reliable than the exact wall-time ratio.
- Full compilation of lexical `nested` inputs includes both record-name checking and ABI classification. The `nested-syntax` run excludes lowering; the `chain` input uses separate top-level type declarations and isolates the ABI problem from deep lexical nesting. Local sampled attribution on `chain-16000` put 94.36% of cycles:u samples in `abi_classify_levels`; this is local attribution, not a target percentage.
- Local `generic-8000` samples put 59.88% in `type_compatible_at` and 34.32% in `type_merge_shallow`. Local nested syntax checking mostly sampled libc zeroing instructions. Source review identifies the oversized clears; that profile does not by itself prove the caller of every libc sample.
- The 4,000-deep macro produces exactly `1\n` with both Buster vector and scalar preprocessing locally. Its 8,000-deep probe is a **refusal**, with "macro expansion past 67108864 tokens", not an accepted timing point. The local peak for that failed probe was about 1.5 GiB. Wide-macro 8,000-parameter probes exceed the supported 4,096-parameter limit and are excluded.
- Clang accepted the local 8,000-case VLA, ordinary/constant generic, overload and top-level chain sources. It accepted the 4,000-parameter macro inputs. Deep macro expansion needed a 64 MiB stack for the 4,000-deep reference; it then succeeded (Clang emits one leading blank line; both outputs contain the sole token `1`). Clang accepted lexical nested records at depth 256 but crashed at depth 8,000 even with the larger stack. Buster's accepted stress result is reported as such, without claiming an independent Clang pass at that depth.
- Exploratory parameter-prototype and enum cases did not establish a useful scaling problem in the tested paths and were not filed. Raw exploratory files remain for transparency; they are not additional findings.

## Validation of retained inputs

The retained generator was built with `clang -O2 -Wall -Wextra -Werror` and regenerated all 66 target input hashes exactly; see `generator-validation.txt`. No benchmark input depends on an external corpus. The `--version` probe at the end of `9700x/environment.txt` is unsupported by this compiler; identify it by the recorded source revision and executable SHA-256, not that probe.

## License

The generator and generated fixtures are original work for this audit, with no imported implementation or dataset. `generate.c` uses Apache-2.0 WITH LLVM-exception, consistent with the measured project. Raw logs are retained unedited; host paths and lock-owner lines identify execution context.
