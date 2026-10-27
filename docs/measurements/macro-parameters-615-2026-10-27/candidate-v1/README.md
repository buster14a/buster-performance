# First candidate — rejected for ordinary macro regressions

Code: Buster `51cb587590dc938dc2dd6ab66b860bdf25257669`; head
`10f8407ea1fc0cdd9e2039d8245a777e35cfd1dd` adds documentation only.
Executable SHA-256:
`f3442c3919d75ff3a91fae8f3897d6b99ae94fed78d4c961e75b1db952321e55`.
The baseline and inputs are those recorded in the parent report.

This version constructed a temporary index for every function-like definition
and first compilation, including 0–4 parameters. It removed both large-list
quadratic scans, but its index construction and vector lookup overhead cost
the common small-list path. It was not accepted.

This is a single-code-placement screen with two fresh executable copies.
Placement effects remain unresolved for this rejected candidate; its wall-time
differences are observations at that placement, not a comparison over shifts.

Three large/ordinary rounds completed (126 samples per build/input). Two
small-macro rounds completed (84), as did two after-scalar rounds (28). The
waiting third small/after-scalar rounds were canceled after the regression was
established; their logs contain no measured process samples. All completed
measurement processes exited 0. Every completed sample is retained.

For 10,000 definitions/invocations per input, medians over both completed
small-macro rounds (`small-summary.tsv`):

| Parameters | Baseline wall ms | Candidate wall ms | Baseline instructions | Candidate instructions |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1.868 | 1.981 | 26,504,158 | 28,430,599 |
| 2 | 2.562 | 2.738 | 39,045,894 | 41,812,334 |
| 4 | 3.669 | 3.983 | 64,472,171 | 68,048,612 |

The second baseline label is within about 1% in these three wall controls.
Candidate user cycles rise by about 11%; the complete distributions and RSS
are retained. The zero-parameter wall comparison has a larger A/A spread and
is not used to claim an improvement.

Native and local full builds, the complete preprocessor/Clang/fuzz suite,
call-graph checks and the frozen SQLite oracle all passed for this version.
The oracle matches 706,237 output tokens. Focused sanitizers also passed.
Those correctness results do not override its measured ordinary-path cost.

The refined version avoids constructing an index for small lists and consumes
their existing parameter array directly. See the parent report for its own
matching qualification; these first-candidate timings are not pooled with it.
