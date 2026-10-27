# Third candidate: cold state removed, common cost remained

Source: Buster `a4618ec3df27036fa97c8e8c2d69c48d6164953a`.
Executable SHA-256:
`df0046ce9a4a54c7ec59e80dc5a89a1f3a8795603a831f85524ecb2865b1404f`.
Baseline, inputs and method are recorded in the parent report. These samples
are not pooled with another candidate.

This is a single-code-placement screen with two fresh executable copies.
Placement effects remain unresolved for this rejected candidate.

This version moves the large index descriptor into scratch memory and caches
the compiled parameter count/id view. Its small definition parser is inline.
One small-macro round completed (42 samples per label/input); every measured
process exited zero. No large or after-scalar timing campaign was launched for
this revision after its small-macro cost was established.

| Parameters | Baseline wall ms | Candidate wall ms | Second baseline ms | Baseline instructions | Candidate instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| 0 | 2.026 | 1.869 | 1.800 | 23,958,701 | 24,320,415 |
| 1 | 1.857 | 1.852 | 1.827 | 26,504,160 | 27,165,874 |
| 2 | 2.537 | 2.546 | 2.501 | 39,045,895 | 39,647,608 |
| 4 | 3.604 | 3.712 | 3.604 | 64,472,171 | 64,373,885 |

At this placement four-parameter wall time is 3.0% higher despite 0.15% fewer instructions;
user cycles are 12,942,504 → 13,527,748 (+4.5%). This is larger than the two
baseline labels' spread. The zero-parameter wall comparison again has a large
A/A floor and supplies no gain claim.

The retained assembly shows that taking the address of the caller's index
pointer adds a stack-protector prologue/epilogue to `pp_compile_macro`, absent
in the baseline function. The large table lookup was also inlined into it.
This observation motivates returning the descriptor directly and keeping
large construction/lookup in separate functions; it does not establish how
much of the measured cost each change causes.

Native and local release builds, full Clang/preprocessor suites (3,000 generated
cases), call-graph checks and the frozen SQLite oracle pass. The oracle
matches 706,237 output tokens. Focused ASan+UBSan checks pass. The call graph
has 23,989 functions and no unapproved cycles. All matching logs and the
assembly comparison are retained here.
