# Focused #702 compatibility with current #678 host headers

This is private functional qualification only. It adds no timing or performance
claim and changes no published branch. It does not duplicate or replace the
separate full twelve-change `4349d8fd` composition's suites.

## Exact source

- Private composition: `26364e88d61f34b3df635e24d85bed46a3333052`.
- Parent #702: `0e6967fd9cbc146ca4bc4f073ceb80f8aeed82c4`.
- Parent #678: `4b2a8a6f51cf8dee5a5833a8f32138d865d780b8`.
- Composition tree: `dab50e916b9ddd9bcd0403955fef651cfd4512ed`.

`host_isa.h`, `host_scalar.h` and `host_scalar_vectors.h` are byte-identical to
the #678 parent. Four pre-existing post-check/compatibility conflicts were
resolved privately in `c_check_asm_input.c`, `c_check_program.c`,
`c_check_program_emit.c` and `c_checker.c`. Their exact resolved files are
retained under `resolved/` for reproducing the private tree. This focused result
does not qualify those surrounding program/emission contracts as a full suite.

The fill helper and its caller merge without edits. The caller remains a direct
`if (parser->options.scalar)`: explicit requested scalar preserves the original
nineteen-store loop. Host ISA selection does not coerce that policy into
`BUSTER_SCALAR_PATH(...)`. The default uses the same thirteen plain C bulk fills
even when the host header selects scalar execution helpers.

## Adapter and results

The small adapter includes the actual merged reader, actual `CheckInput` type,
actual portable host headers and permanent `check_test_output_none` fixtures.
The standalone main copy supplies required home entry definitions in this adapter,
owns the unchanged canonical target data, and drops the unused renamed driver
with section GC. No full compiler release images were built.

`fill-host-checks.c` interposes source-level `memset` calls, forwarding each to
libc. With an active real reader, it counts all-one fills only when the address
and full `(token_count + 1) * sizeof(uint32_t)` extent match one of the thirteen
actual output columns. Empty and `int marker;` units exercise zero and three
tokens, respectively. Explicit requested scalar runs first and captures every
column and sentinel. Default execution must call one bounded fill per column
and publish identical values. The printed `bulk_calls` value is the first
column's count; the assertion checks all thirteen independently.

Both adapters use Clang23.1.4, `-O1`, ASan/UBSan, `-fwrapv`, `-funsigned-char`,
`-fno-strict-aliasing`, frame pointers and section GC. Builds and runs each take
a separate two-core `cores` grant.

| Build | Real header selection | Result |
| --- | --- | --- |
| `-march=native` | `BUSTER_HOST_VECTOR=1` | 214 checks, 0 failures |
| `-march=x86-64` | `BUSTER_HOST_VECTOR=0` | 214 checks, 0 failures |

`EXPECT_HOST_VECTOR` is only a static assertion of the real header's computed
selection; the adapter never defines or edits `BUSTER_HOST_VECTOR`. The generic
build uses #678's standard `-Wno-unused-function -Wno-psabi` **after**
`-Wall -Werror`. Both results include the permanent 206 dirty/guarded/copied-arena
checks and eight real-reader policy/value checks. Every requested-scalar case
records zero bulk calls, and every default case records exactly one per column.
Both actual parser options remain equal to their explicit requests.

The real-reader cases bypass `check_corpus_check`; they do not infer a parser's
actual scalar option from a separate corpus-wrapper loop flag. The separate
full-composition nullable-ASM test expectation is outside this record.

Independent read-only review found no source-policy or test-vacuity concern.
No concrete product defect was found, so #702 and its published ancestors remain
unchanged. No Benchpress operation, benchmark or performance extrapolation was
performed.

## Retained invocation errors

The first generic adapter invocation omitted #678's expected unused-function
warning suppression. The next placed that suppression before `-Wall`, which
re-enabled the diagnostic. Both failed invocations are retained. The corrected
standard flag order builds and passes. No production source was changed to
address these invocation errors. The initial and final adapter source copies
are byte-identical. The first native build also passed; final run records name
the completed final build.

`source-identities.sha256` identifies source inputs. `SHA256SUMS` identifies the
complete frozen local folder, including final executables and unsuccessful
invocation receipts. These binaries are functional test adapters, not measured
performance images.
