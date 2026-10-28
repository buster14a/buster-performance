# Full private compatibility union on main321

Exact source: `d74d87366e2f7458bc7997b2314d94b0f5cdf96b`, branch
`codex/perf-compat-678-current`, clean worktree. This private union includes
main `321f5976d5af2b4c54fa45a639895739f2b8a8c9`, qualified next-main
`d3c1d45d087f5b9ac1e54e2ba66248efa623f3d8`, accepted optional ASM output
`dc15a18ed3ad273888ae1cb87e903969e876acfa` and pinned PR678
`a11d8065104f07ce8ab3e752404bb48f07df9d4c`, with the original six scalar
shims and host-correct preprocessor fixtures. Rejected include-directory
caching is absent. Earlier frozen candidates, measurements and negative
controls remain untouched. This is not main, and is not a performance claim.

Main321's new compact ISA requirements retained the generic host's scalar
eligibility guard. Both candidate builders are validated before plain-C
encode_one, so its new direct length query is shared. The hosted ISA coverage
fixture now uses x86_target_requirement(form), replacing the removed table.
The nullable ASM change applies without enabling the old parser size pass.

Native and generic syntax checks of checker/frontend/backend/x86/assembler
pass. Both builds pass all 41 units, debug info disabled, Clang23.1.4.
Generic uses `BUSTER_HOST_ARCH=x86-64` and PR678's pinned private runtime.
Each build and command used its own local two-core grant. Binary SHA256:

* native: bfa502a2a2934951fd2c26b9ee125daeb0d50fb8ba6cc57fea648c400414b5e8
* generic: c58e3432977a5e55cc5ce3922a5554b9735513aba3b4b1db04d23d2cff0b144a

| suite | native | generic |
| --- | --- | --- |
| checker seed133 | 488,846 /0 | 491,629 /0 |
| driver | 21,660 /0 | 21,660 /0 |
| deferred | 72 fixtures;1,147 /0 | 72 fixtures;1,147 /0 |
| source lanes seed172/programs8 | 3,399 /0 | 3,395 /0 |
| pinned c-testsuite | 220/220 | 220/220 |
| PP/Clang, both1500-case fuzz standards | pass | pass |
| parser/Clang | pass | pass |
| streaming units8 | 188 /0 | 188 /0 |
| tier1 schedule seed172 | 609,462 /0 | 609,462 /0 |
| x86 target + selection | pass | pass |
| assembler/GAS cross-check | 1,891,352 /0 | 1,891,352 /0 |
| x86 semantics cross-check seed172/runs1 | pass | pass |

Pinned read-only c-testsuite is revision5c7275656d751de0e68b2d340a95b5681858ed07.
The initial lane commands mistakenly supplied --count rather than --programs;
both refused that harness option. Their logs are preserved and excluded from
correctness coverage. Corrected commands pass and exercise worker ownership.
Initial syntax errors due the removed ISA table are preserved; final syntax
and compiler builds include the accessor correction. No compiler failure is
hidden by the rejected attempts.

Object/runtime controls compare native, native --scalar, generic and preserved
06150 union using the same absolute 257-element-table input. Object, output
and diagnostic bytes agree and linked checksums run0. A true qemu64 CPU runs
the generic compiler with the private baseline loader to compile that same C
input and an independent assembly function. The C object equals native; both
generic-linked programs run0 under qemu64. The preprocessing printer and its
diagnostics also match native bytes. controls.log records success. The worker
budget module/test source is unchanged from the earlier18/0 qemu64 lifecycle
adapter; that older result is retained as prior evidence, not a new-head run.

No remote performance run is attributed to this composition. This full union
is separate from the minimal five-file companion PR based on a11 and from
individual issue publication branches refreshed on main321.
