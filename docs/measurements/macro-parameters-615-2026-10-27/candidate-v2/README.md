# Second candidate: ordinary-path cost still measurable

Source: Buster `034f1e0eb4da8f6ea7b5f7c97831d84b2d556270`.
Executable SHA-256:
`955b8fb21b019334d31ecc1fe0401c582f5c154e08c2fb553b231b26300c0578`.
The baseline, generators, inputs, list ordering and measurement method are
recorded in the parent report. These samples are not pooled with another
candidate.

This is a single-code-placement screen with two fresh executable copies.
Placement effects remain unresolved for this rejected candidate.

This candidate constructs indexes only above 16 parameters. Small definitions
use bounded source scans; first expansion uses the existing contiguous ids,
scalar at 0–4 and masked SIMD at 5–16. It fixes the large-list scaling and
reduces the first candidate's small-list overhead, but does not remove it.

Three large/ordinary rounds completed (126 samples per label and input), as
did three after-scalar rounds (42). One small-macro round completed (42);
the established four-parameter cost motivated another refinement. Every
measurement process exited zero and every completed sample is retained.

For 10,000 definitions and first invocations per input (`small-summary.tsv`):

| Parameters | Baseline wall ms | Candidate wall ms | Second baseline ms | Baseline cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: | ---: |
| 0 | 2.047 | 1.940 | 1.847 | 5,765,129 | 5,774,018 |
| 1 | 1.869 | 1.882 | 1.849 | 6,165,032 | 6,295,483 |
| 2 | 2.576 | 2.600 | 2.535 | 8,443,882 | 8,619,690 |
| 4 | 3.666 | 3.791 | 3.659 | 12,946,200 | 13,411,602 |

At this placement the four-parameter candidate costs 3.4% wall and 3.6% user cycles against
the first baseline label, beyond the two baseline labels' spread. The
zero-parameter wall comparison has a large A/A floor and supplies no gain
claim. Full instructions, RSS and sample ranges remain in the summaries/logs.

At 4,000 parameters the invoked case takes 161,316,160 → 8,217,157
instructions and 5.530 → 0.986 ms; the unused case takes
115,841,057 → 2,261,831 instructions and 3.572 → 0.652 ms. Those large-list
gains do not override the ordinary-path cost. SQLite timings show no resolved
gain: `-E -P` is 15.712 → 15.579 ms against a second baseline of 15.303 ms;
`-fsyntax-only` is 116.079 → 116.320 ms against 116.269 ms.

Local and native release builds, full Clang/preprocessor suites with 3,000
generated cases, call-graph checks, and the frozen SQLite oracle pass.
The oracle matches 706,237 output tokens. Focused ASan+UBSan checks pass.
The call graph has 23,977 functions and no unapproved cycles. Logs and source
hashes are retained here. These results qualify this source revision only.

The next refinement moves the large index descriptor and its construction
into cold scratch-backed helpers, keeps the small definition parser inline,
and caches the compiled parameter view and count.
