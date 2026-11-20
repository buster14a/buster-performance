# #2924 handoff (2026-11-20)

The first session's campaign stopped after #3195 (C12c-3 core-3), on the owner's request; #2924's handoff comment links
here. Each finished piece has its own directory beside this one (`c-*-gate`, `c-*-deletion`), with its scripts, logs and
a README.

## Files

- `macro-uses.txt` and `macro-sites.txt`: every `BUSTER_SCALAR_PATH`/`BUSTER_VECTOR_PATH` use outside tests, benchmarks
  and measures, on `4debb2ae3` (#3195's head). There are 279 uses in 60 files, by file and then by line.
- `field-uses.txt`: lines that name a scalar flag field (`options.scalar`, `->scalar`, `.scalar`), by file. Some of
  these lines are macro uses too, and some, such as CheckSource's, only carry the driver's flag through.
- `parked-parser-docs.patch`: a docs follow-up that never went up. It makes `docs/commands/parser.md` say what vouches
  for a re-recorded parser digest.

## The 9700X

On `benchpress`, `~/buster-fast-bench/2924-c-df-claude/` keeps only what the records' scripts read:

- `c7gate/src`: the clone that every script clones `--shared`;
- `c3pr/inputs/lua-5.4.8`: Lua's sources;
- `c12w-census/logs-u/units.tsv`: musl's units with their preprocessed sizes, for the by-size runs.

The corpora are the machine's own (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`). Every run goes under
`~/buster-fast-bench/exclusive.sh`, as `AGENTS.md` says. Note `tailscale ssh host "cat > f && ... &" < f` copies
nothing: copy in one call, check `wc -c`, then launch.

## Lessons

**Gates:**

- Gate on real functions, not only on a module's synthetic benchmark (C3).
- Before blaming memory or placement for a loss, run both paths in one executable with a knob (C3, C12).
- The knob's mask comes from the executable's name, read once by a constructor. An out-of-line knob function cost 0.7%
  of instructions on its own (C12c).
- Gate where the flag's name is defined. A flag passed whole to another area's function leaks the knob into it, so check
  that the solo deltas add up to all areas together (C12c's second executable: 129%).
- A site that no list reaches reads 0.00%. Count the sites first (`census.patch`) in every mode that might reach them:
  `-Wall`, `-g`, `--tier1`, `--deferred-bodies` on several CPUs, and fixtures for features the corpora lack. One CPU
  reads every deferred body in source order.
- Per-unit runs need hard links of one fresh copy. Two files of the same bytes read up to 29% apart on musl's smallest
  units (C12c-2). Compare per-unit instructions against both no-bit runs' mean: the two runs differ by about 165 a
  musl unit.
- Warm per-function loops favour the scalar twins' branches; take verdicts from the pipeline (C9).

**Tests:**

- A twin comparison can be a module's only check of a count or a corner. Mutate those too (C1, C2).
- After deleting a twin, a test that toggles its flag and compares two calls compares the function with itself. List
  such tests before the mutation round (C12c-1).
- A per-fixture frozen digest table must let a fixture with no line pass, or every new fixture fails the next PR.
- When the definition oracle is too costly for large inputs, run its cheap parts on every input and freeze full-result
  digests for the default seed where both paths agreed (C4).
- Generated shapes miss paths: when a mutant survives, search small inputs with a transcription of the code for a
  minimal fixture (C4).
- A fixture that reaches one bit by two routes hides a mutant in either. Give each route its own fixture (C3).
- Lane sweeps kill a dropped-lane mutant only if the dropped item's result reaches the output. #3195's u2 survived a
  sweep whose roots were all assignments, because the `=` marked the root anyway.
- A survivor means dead code (remove it) or a missing test (add it, and see it fail on that mutant's build). #3195's d5
  was dead code.
- A failure of clang's own builds in a driver part is the environment's, not a kill.

**Builds and pushes:**

- Removing dead arms can change inlining and push a hot function out of `.text.buster_start`. Check `readelf` and the
  start order (C1, C5).
- A patch to code no list runs can move instructions by millions and cycles by tenths of a percent. Time a clean build
  of the parent beside base and head before attributing a difference to the change (#3195's record).
- One mutation runner per tree. Don't edit a worktree while a build of it runs, and before deleting a `build/`, check no
  worktree links into it.
- A queued PR's branch takes no pushes, so finish every check first. Before pushing a signature change, grep the open
  PRs' diffs for calls to it. In the merge queue a PR is built on the one ahead of it.
- Run every block of `tools/ci/correctness.tests` that names the area's tests, with the toolchain's clang 23.1.4, not
  only the area's own runners (C12c-1's first CI run).
