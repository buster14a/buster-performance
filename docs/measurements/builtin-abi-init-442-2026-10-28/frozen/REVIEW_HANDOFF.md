# #442 review handoff — functional gates passed, whole-CLI benefit unqualified

Exact source: `73b6ba60604ca3da7494375f2468b23ae7d4c258`, one commit on
`e7f89091648f68940b595aadd648841c1ffc3ec5`, clean worktree. Eight paths.
No PR yet. Source payload and qualification raw receipts are retained locally in
`work/evidence-442`; `TARGET_REPORT.md` carries the target results and stop boundary,
and `REPORT.md` the local method and negative evidence.

The initializer currently recomputes42 canonical builtin ABI rows per table.
This patch copies immutable original-project facts into all seven columns and
the merge table, after existing bounds/width validation, and patches plain-char
extension flags when required. Logical prefixes below64 and requested capacity
remain independent. Derived/incomplete types, dependency scheduling, tail clears
and caller ownership keep their existing rules. The generated projection is2752
bytes per including translation unit (five copies in the local final ELF).
The remaining paths are its independent scalar tests, regeneration tool,
documentation/provenance and CI consumer coverage.

| Gate | Result and retained receipt |
| --- | --- |
| Exact local build | Clang23.1.4/native/debug1; c10cb3b4; `frozen-native-build.log`, `frozen-local-compiler.sha256` |
| Builtin prefix/capacity contract | 51,259 checks/0; every column, both char modes, widths16/32/64, holes, small/refused requests, tails and first derived; `abi-native.log` |
| Output guards/allocation failures | 67,536 cases/0 each native and generic/signed-host-char under ASan+UBSan; `abi-init-guard*-san.log` |
| External ABI | Exact frozen source cross400 passes Clang/GCC and both char modes; `frozen-abi-cross400.log` |
| Objects/behavior | All220 scalar/vector baseline/head objects byte-identical; c-testsuite220/220; SQLite allfour paths identical; `frozen-four-path-objects.log`, `c-testsuite-pinned.log`, `frozen-sqlite-objects.log` |
| Frozen Zig-vendored musl gate | 354/354 compared;0 differences/unexplained/failures; `frozen-musl-symbols-exact.log` |
| Checker/callgraph/CI selector/regeneration | 497025/0;41TUs/0 forbidden cycles;1171/0; byte-identical regeneration; corresponding named logs |
| Target source/SDK/baseline | Staged exact archive;710 hashes pass; official23.1.4 and immutable baseline06132c96 verified; `target-stage.log`, `target-verify.log` |
| Target exact native build | Official23.1.4/native/debug1; be00af5b;41sources30.1s; `target-build.log` |
| Target native gates | ABI cross400, guard67536, checker497021/0, c-testsuite220/220, four-path220+SQLite bytes, frozen symbols354/354 all pass; corresponding target logs |
| Target mechanism | Isolated initializer486.55–503.23→18.18–19.42ns; allwidths/char; `target-init-first.log` |
| Target whole-CLI controls | First-image outliers retained; one all-image-primed repeat complete; no whole-CLI gain/neutrality bound established; `TARGET_REPORT.md` |

Performance evidence is deliberately narrow. The matching standalone helper
screen removes repeated initializer work (capacity64 local means885–918→36–41ns;
target486.55–503.23→18.18–19.42ns).
That is a hot isolated loop, excludes allocation/type construction/lowering and
does not establish whole-compiler gain. Local whole-path/fresh-exec screens are
rejected for debug0/debug1 mismatch and retained as negative method evidence;
their RSS differences do not show that ABI-copy allocation grew. Target passes
match native/debug1/toolchain. The first-image pass mixed priming states and is
retained; one warm-image repeat primes all three copies and includes all samples.
Function cohort medians move−0.53% against A/Amean with0.32%A/A drift; no-body
medians move+0.01%. These do not separate a small CLI effect from layout/noise.
No broader timing expansion was performed after the prescribed stop boundary.

**Review focus:** confirm the TypeTable builtin immutability boundary makes the
full seven-column projection valid at every accepted logical prefix/capacity,
including plain-char return flags and untouched derived/tail state. The current
peer source audit found no blocker; inspect the scalar oracle rather than trusting
generated constants alone. Regeneration must compile first and write temporary
output, since compilation includes the current generated file.

**Remaining publication decision:** root must choose a prototype/closure record
or a draft limited to the measured initializer mechanism. Functional gates pass;
a general CLI gain or neutral equivalence bound remains unqualified. Later main
composition is also untested. No broad whole-compiler headline or demand-scheduler
claim is justified. #517's historical acceptance and evidence remain credited;
this bounded patch is not blanket closure of #442 or separate #641/demand work.
