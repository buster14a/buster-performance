# Independent source and evidence review

A separate read-only reviewer inspected final compiler source
`86a9bbdc58370706604f77794d4561e10febe4d3` and the preceding routing,
composition, scalar-sizing, immutable-table, independent-loop and sanitizer
guard checkpoints. No compiler build, execution, measurement, edit or public
post was performed by that reviewer.

Source review covered full candidate validation before direct sizing, bounded
checked/direct byte comparisons, mutable-state homes and borrowed directory
lifetime, const table linkage/visibility/alignment and standalone fallback,
projection assertions in declaration-only units, loop independence with valid
target/output overlap, and the diagnostic-only sanitizer guard. The original
deterministic Tier 0 refusal finding remains fixed. No actionable source defect
remains in this owned slice.

The reviewer independently recomputed the four performance campaigns and the
later counter controls, all raw/summary fields, round pairing, directions,
ranges and units. This includes 60 table/assembler runs, 40 whole drivers/
840 timed children, 18 hot runs, 6 assembler counter runs, 6 SQLite counter
runs and 6 isolated policy counter runs. Failed invocations and preliminary
screens remain distinct from final qualification.

All 46 post-campaign command/result entries match: 44 exit 0 and two intended
compile-negative exit 1 results. Every raw log was read. Source manifests match
474/477/477 unique paths; each compiler build has 42 unique compile entries.
Normal last -O3 and ASan last -O1 plus all required sanitizer flags match every
raw -MJ fragment. All six 220/220 corpus runs, two positive/two negative production
projection guards, auditor self-test, six 161-byte/50-instruction audits and seven
native outputs including fresh Clang agree.

Final generated-object/executable identities and sizes match the fresh snapshot.
Historical generated-runtime timing reuse is bounded by complete executable
SHA256 identity; it is not described as fresh final-head timing or a broad
runtime-neutrality result. Perf controls report 100.00% running; the isolated
C policy helper separately requires exact enabled/running-time equality.
Both-path warmups and the full 2048-function assembler counter scope are explicit.

Review findings addressed in the report:

- Correct 12 outer query/option cases versus 11 queried builtin names.
- Replace unsupported bimodal characterization with variable/overlapping ranges.
- Specify 21 one-table timings, one cold-init observation and 21 interleaved warm
  passes per process; distinguish 10,000-table bulk samples.
- Repair the split revision table and clarify lower-profile VEX/EVEX negatives.
- Preserve final-image size/disassembly/provenance rather than substituting 333.
- Record host source hashes, ASan executable SHA and all 42 instrumentation entries.
- Explain removal of the trailing comma before wrapping Clang -MJ fragments.
- State that resource medians are independent of the median-wall child's rank.
- Keep actual-command counters distinct from isolated source controls and
  displayed instruction-count precision distinct from exact counts.

The final review found no additional material requirement missing within the
owned scope. SQLite/scalar-backend/vector-assembly point estimates, assembler
RSS, minor-fault and text-size costs remain explicit and **unapproved**. Source
correctness review and evidence arithmetic are not a performance exception.
The PR remains draft and unmerged; the broader producer integrations remain
with their owners.
