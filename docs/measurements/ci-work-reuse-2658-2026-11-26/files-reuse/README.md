# Issue 2658: file-test work reuse evidence

The extracted comparison and used-record helpers pass their controls under ASan
and UBSan. All nine deliberately broken variants fail those controls. Forced
first-allocation and bitmap-growth failures also fail safely, and a subsequent
successful growth preserves the existing marks. This is helper-level validation;
it does not replace a production compiler build or a hosted sanitizer run.

[PROVENANCE.md](PROVENANCE.md) records the source and generator inputs, retained
license/copyright notices, deliberate mutations, and agent attribution.

## Source and compiler

- Published candidate: `4d1f2024095f233cba19e8f8135dd99b17b9e264`.
- Candidate tree: `442ca4bfa8125782b97d5017aa17323f296f1d89`.
- Base: `8e4d32879e17b7d9548cad54257a2f8461328366`.
- Tested source: `src/buster/compiler/c_files_test.c`.
- Tested source SHA-256:
  `ad25f3fa47d6c4b13e14da4095d6ace7e3c322ccb2d99f77143211ab9d9efa22`.
- Clang: `23.1.4`, LLVM revision
  `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, target
  `x86_64-unknown-linux-gnu`.

The source hash is also that of the initial local candidate, before publication
changed its commit metadata. `run/checkout-head.txt`, `run/checkout-tree.txt`,
`run/base-revision.txt`, `run/compiler.txt` and `run/recorded-at.txt` record the
reproduction identity. `run/c_files_test.c` preserves the exact source snapshot,
and `run/source.patch` preserves its change from the base.

## Reproduce

From `/workspace/scratch/2f6ef0ccacba`, the recorded invocation is:

```sh
CC=/home/agent/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang-23 \
  ci-evidence/files-reuse/reproduce.sh \
  /workspace/scratch/2f6ef0ccacba/buster \
  /workspace/scratch/2f6ef0ccacba/ci-evidence/files-reuse/run \
  > ci-evidence/files-reuse/reproduce.log 2>&1
```

For another checkout, set `CC` to Clang and pass the checkout and an empty output
directory. The default base is the commit above; `BASE_REVISION` can override it.
The script needs Bash, Git, a C compiler, and ordinary GNU file utilities. It
creates binaries in a temporary directory and removes those binaries on exit.
Generated C sources and all compilation/runtime logs remain in the output.

`extract.c` reads the source snapshot and extracts these seven function
definitions, preserving their bodies: `files_test_same_id`,
`files_test_same_value`, `files_test_same_stream`, `files_test_same_text`,
`files_test_mark_used`, `files_test_unused`, and `files_test_comparisons`. Its brace
scanner ignores braces in comments and string/character literals. Extraction
fails if a definition is missing, starts at a non-definition, or a mutation's
replacement string occurs other than once. The generated `main` calls the
source's `files_test_comparisons`; the harness does not reimplement its checks.

`plumbing.h` supplies small **stub** types, representative token constants, and a
small intern-table implementation. The production preprocessor, actual intern
implementation, source-command driver, threading and cache lifetimes are not
linked into this harness. In the compiler itself the same added controls use its
real types and intern tables. The independent source review below covers the
caller integration; hosted CI is the production validation.

The script builds the extractor and each mutant using
`-std=c17 -O2 -Wall -Wextra -Werror`. The unmodified helper harness additionally
uses `-fsanitize=address,undefined -g`; it runs with
`ASAN_OPTIONS=detect_leaks=0`. The allocation-failure check uses those same flags
and `-I OUTPUT_DIRECTORY -Wl,--wrap=realloc`. It includes the generated actual
helpers and intercepts only `realloc` to inject the two failures. These are small
helper builds at O2, not changes to the compiler product's required O3 settings.

LeakSanitizer was disabled only for this local helper run. An earlier default
run failed in LSan's infrastructure with `LeakSanitizer does not work under
ptrace (strace, gdb, etc)` and the accompanying `ptrace_scope` requirement. This
bundle makes no claim of local leak checking, TSan, MSan, a production compiler
test, or a measured speedup.

## Recorded results

`run/results.tsv` and `reproduce.log` are the raw result table. Both positive
executables exited 0; all nine negative executables exited 1. Compilation logs
and the ASan/UBSan harness log are empty. Each negative log contains:

```text
comparisons: a stream, diagnostic or used-file corruption escaped its check
```

| Case | Deliberate defect or condition | Expected / actual exit |
| --- | --- | --- |
| `harness_asan_ubsan` | Unmodified extracted helpers and source controls | 0 / 0 |
| `allocation_failure_asan_ubsan` | First allocation and later growth rejected; retry succeeds | 0 / 0 |
| `mutant_kind_column` | Skip kind-column comparison on the fast path | 1 / 1 |
| `mutant_flag_column` | Skip flag-column comparison on the fast path | 1 / 1 |
| `mutant_value_column` | Skip value-column comparison on the fast path | 1 / 1 |
| `mutant_location_column` | Skip location-column comparison on the fast path | 1 / 1 |
| `mutant_run_status` | Ignore the run-status difference | 1 / 1 |
| `mutant_opaque_spelling` | Compare opaque identifiers as ordinary numeric IDs | 1 / 1 |
| `mutant_diagnostic_content` | Ignore differing diagnostic bytes | 1 / 1 |
| `mutant_bitmap_growth` | Clear old bitmap marks while growing | 1 / 1 |
| `mutant_unprepared_mark` | Mark an unprepared entry as used | 1 / 1 |

The source controls check equal and differing streams in ordinary and opaque-ID
modes, corrupting each token column at positions 0, 1, 2, 15, 16, 63 and 64.
They check that two differences report the first position, and reject changed
status, error count, warning count, stream length, diagnostic content and
diagnostic length. Empty streams avoid null `memcmp` calls. Bitmap controls
exercise growth from 3 to 5 records, preserve earlier marks, skip missing and
unprepared entries, and reject both under- and over-marked unused counts.

The original one-off harness was
`/workspace/scratch/2f6ef0ccacba/files-2658-check.c`; its original mutant sources
were `files-2658-mutant-<name>.c` beside it. Exact copies are retained under
`original/`. The reproducible `run/` sources are freshly extracted from the
published candidate and include the additional forced-allocation check.

## Integration review

No remaining code blocker was found in the full `c_files_test.c` diff.

1. **Warm-cache coverage is preserved.** Every original lane and ID-order run
   stays. Each unit is still run with its own cache, then with the shared cache
   after all units and ID-order comparisons have run, using the original
   expansion-starts option. The removed extra warm replay collected only used
   record marks and compared no streams, status, errors, warnings or diagnostics.
   Those marks now come from the already-live compared warm replay. With the
   default four lane counts, this removes one of eleven preprocessings per unit.
2. **The bitmap grows without losing prior marks.** A successful `realloc`
   zeroes only the added suffix. A record ID is checked against the current
   cache count before indexing; `BUSTER_PP_NONE` and unprepared entries are
   ignored. The cache's final record array is read after the loop, so no record
   pointer is retained across its growth. Later computed-include records remain
   in the final count.
3. **Allocation failures cannot become passing results.** A failed bitmap
   allocation leaves its previous pointer/count unchanged and skips all marking
   for that call. The caller records a sticky failure. Any final count over the
   retained prefix remains within that allocation and is never accepted as a
   passing corpus result. The forced failure check verifies the helper's memory
   behavior under ASan/UBSan.
4. **Preprocessor data remains live while it is read.** Marking occurs before
   `pp_release(&cached)`. `pp_release_unit` ends by zeroing the complete
   `Preprocessor`, so a skipped initialization on a subsequent early failure
   cannot reuse the prior iteration's data pointer or count. The existing
   initialization/diagnostic failures still fail the unit.
5. **Comparison and reporting behavior is retained.** The fast path reads
   exactly the initialized token columns, with a zero-count guard. Opaque IDs
   retain their spelling comparison. A failed bulk comparison runs the original
   token loop, preserving the first differing position and field comparison
   order. Status and diagnostic counts remain mandatory even when token columns
   match. Temporary diagnostic quieting is restored after the controls.

This review and the small harness do not execute `files_test_alone` or prove
whole-corpus behavior dynamically. The standard and hosted sanitizer workflows
must provide that evidence. No full compiler build, hardware measurement, or
benchpress job was launched for this bundle.
