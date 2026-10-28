# #451 local gates, before target measurement

Compiler source pin: `e7f89091648f68940b595aadd648841c1ffc3ec5` (tree
`4d76bb93e2950d437c834d289805c09a0e5b0eb3`). The private compiler worktree is
clean. No production change is proposed. Root advanced the original starting
pin from 296e5b05 to e7 before any edit; both shared baselines and all rejected
fusion/alias experiments remain untouched.

Shared local binary SHA-256:
`523ceb8df0435c089e10ba78dbc8e08be8062d7a2f10d96f4c3bbd734006865a`.
Clang is 23.1.4. Multicore work used two cores; long single-thread gates and
helper builds used one. Local timings are not target performance evidence.

## Existing completed work

The original issue's criteria already have retained source/evidence:

- #462, merged as ff7c983a, supplies the 840-process window/whole wall, RSS,
  fault and release record and explains why bounded scratch words/pages stay.
- #486, merged as 35f26f68, attributes the original directive overhead, removes
  its avoidable places/prefetch work, and documents the remaining line-page
  cost separately. Its bounded cut avoids most sparse logical-line replay.
- The later page-line fusion at 68e113ee was rejected: whole preparation was
  neutral within A/A controls and memory grew. It is not integrated, retuned
  or counted as a fix. The alias experiment was also reverted.

This record refreshes the completion map and current configuration costs. It
does not claim that these historical source changes happened at e7, or that
the current debug-enabled target baseline equals their old release builds.

## Exact-record gates

All command/status receipts and diagnostics are under `local/`:

- Preprocessor/Clang, fuzz disabled, seed 451: 240 generated sources and 1,833
  windowed preparations exact; cut 119,625/0; directive places 976/0; line
  boundaries 2,892,217/0 in 11 files. Twenty-four units, 93 windowed units and
  128,264 `__LINE__` values agree with scalar output.
- Refinement: 520 current source files, 26,584,594 bytes, randomized spelling
  and 9,600 guarded tails pass.
- File preparation on one/two lanes passes, including resource failures.
- SQLite `-E`/syntax preflights pass in both configurations. Full `-E` bytes
  match, SHA-256 ca5013f3ec563b3882f5465ad81fcc07fa94e8891965cbcc5b0eae5dee0bc025.
- Native-header main `-E`/parse preflights pass in both configurations.
  The 22,621,870 output bytes match, SHA-256
  9b28b96ab08aa120cf83ed53c91c61af790f51c42551a07286eb1beee4a5caea.
  Clang's 841-file dependency closure is hashed and verified.

The first four main preflights deliberately remain as negative configuration
receipts: the old SQLite header bundle lacks `linux/audit.h`, now included by
main's oracle cache. Both window/whole `-E` and parse exit 1 with that same
missing header. They are not performance samples or a compiler defect. Main
instead uses a current-tool predefine snapshot and actual native headers;
the target recipe explicitly binds the official tool's resource directory.

The four local phase commands (SQL/main, windows/whole) each complete the
benchmark's existing 21 passes. They validate the recipe and output format
only. Their values are not substituted for native results.

## Sanitized work counters

Original C generators retain source notices and copy the exact e7 algorithms.
The only generated edits empty module linkage, redirect the copied
preprocessor include and count lexer-call ranges/page-index ranges. There is
no fused lexer, changed cut or changed line-counting algorithm. The adapter
does not provide latency or RSS comparisons.

ASan/UBSan direct-file checks pass at 64, 4,096 and 131,072-byte windows for
SQLite, the current encoder and both exact historical generated inputs.
Scalar/whole/window records and every token's physical line query match.
At the production window size:

| Input | Source bytes | Requested lexer bytes | Replayed bytes | Page-index range bytes |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 9,507,037 | 9,530,200 | 23,163 | 9,507,037 |
| Current encoder | 586,005 | 593,769 | 7,764 | 586,005 |
| Historical long-lines | 8,002,841 | 8,247,914 | 245,073 | 8,002,841 |
| Historical spliced | 8,018,225 | 8,094,259 | 76,034 | 8,018,225 |

The two synthetic SHA-256 values exactly reproduce #486's retained inputs:
55a62aafa0bd4dccf48a33249e05599f37e737b9865e08288267802323ce33ad and
ba2c337903342149b227845e925334197aa9f7a5ca27d9dca064c2f706c53444.
Their default-window work counts are also the historical counts; this is a
confirmation of the existing cut, not a new reduction.

The ASan/UBSan full-inclusion command route passes for SQL/main in both
configurations. All complete `-E` outputs match each other and the unchanged
baseline. Current main's actual windowed files request 8,188,156 lexer bytes
and cover 8,173,523 bytes with page indices (14,633 replayed bytes). The latter
equals the independent size sum of all 18 dependency files at least 256 KiB;
this checks the byte accounting against a separate file inventory. Counts
are logical source ranges, not CPU load traffic. CR-containing blocks may
take the original fallback scan without changing the covered ranges.

Native staging/helper/preflight is approved under the shared lock. The
approved initial measurement stage is 12 one-input/two-role cohorts (A/A,
A/B, reverse B/A per original workload; 504 timed children), plus 16 phase
processes. `NATIVE-PLAN.md` contains the exact recipe and scope. No additional
rounds are automatic, and all native results will be reported separately.
