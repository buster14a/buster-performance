# Issue 647: streaming benchmark CPU placement

The change is based on exact main `4165454ebadf9b96c2b40ab99c55f4c0b28ba975`.
It remains local: no PR, push or GitHub comment was made by this agent.
The parent posted claim issuecomment-6468957481 before implementation.

The scheduled streaming command is separated from the single-CPU backend
measurements and given at most eight distinct allowed physical cores. Its
writer pair is selected from the same placement. The benchmark counts its
inherited logical CPU affinity, clamps direct-path lanes, and omits parallel
rows that cannot get the required CPUs. An explicit writer pair cannot widen
that inherited mask. All enabled rows retain the existing executable-output
and exact-byte oracles. There is no compiler throughput speedup claim.

Local validation uses separate `cores -n 2` grants for builds and runs:

- Full optimized 41-unit build, debug info disabled: pass, 112.4 s.
- Full syntax and whitespace checks: pass.
- Call graph: 25,304 functions, 150,544 calls, zero cycles beyond the three
  existing allowed cases and zero split variables.
- `test-streaming --units 8`: 188 checks, zero failures, including the 22
  permanent CPU configuration cases.
- Original adapter to the actual CPU helper and permanent fixture file:
  AddressSanitizer plus UndefinedBehaviorSanitizer, 22 checks, zero failures.
- Actual workflow shell extracted from YAML: syntax pass. An original C
  replacement benchmark verifies that one-CPU placement stays on that CPU,
  and that the allocator's four logical CPUs on two cores become two distinct
  physical CPUs with an allowed, distinct writer pair.
- Actual workflow command with the real candidate on two physical cores:
  all five variants validate and report, 100 units, 32 functions, five runs.
- Real candidate constrained to one CPU, requested eight lanes: selected one,
  three serial rows validate and report, both parallel rows print `not run`.
- The workflow patch applies cleanly to private compatibility branch #678.

Logs and original C adapters are beside this document. The isolated workflow
fixture directory contains a replacement executable only; it is never used for
performance measurements. The candidate's local image identity is retained in
`local-compiler.sha256`. The frozen source is b1975e3135b72705ef2b12c9804c2df4ce7c4149. Native target
validation is complete in target-README.md, with exact commands and raw logs. All target runs and packaging must hold `exclusive.sh` per
run, with acquisition-side start/end UTC stamps and unique output prefixes.
