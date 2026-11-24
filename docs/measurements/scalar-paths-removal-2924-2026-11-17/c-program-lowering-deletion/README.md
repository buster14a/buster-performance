# #2924 C12c-4 (a): the lowering keeps its vector paths alone

PR [#3457](https://github.com/buster14a/buster/pull/3457). Base: the tests commit `0fd0634cb` (the twins present).
Head: the deletion commit `74924852e`. The later commits change only tests, `tools/ci/correctness.tests` and docs.

The gate was C12c's ([7014944772](https://github.com/buster14a/buster/issues/2924#issuecomment-7014944772)): the
lowering's bit read +1.9% to +4.1% of user cycles with the scalar arm forced, on sqlite3.c, Lua and musl.

## The 9700X deletion run (`run.sh`, `chain.sh`, `chain2.sh`, `logs/`)

The run was trimmed for the shared lock's queue to four modes and three timed lists.

**Objects:**
- 1,373 of 1,373 byte-identical in `-Wall -Wextra`, `--scalar` and `--tier1`, over sqlite3.c, Lua, musl, buster's
  `main.c` and `--deferred-bodies` sqlite3.c.
- The `-g` mode's objects differ only because each tree compiles in its own directory, which the DWARF records.
  Compiled in one directory, `lvm.c` and `sqlite3.c` with `-g` are byte-identical (`gsame-README.md`).

**Stderr:** the same, but for the lock's report of other processes (a `git` row in base's Lua and musl lists).

**User cycles,** head against base (base again for scale):

| List | Head | Base again |
| --- | --- | --- |
| sqlite3.c | −0.78% | −0.50% |
| Lua | +0.04% | +0.03% |
| musl | −0.47% | −0.29% |

**Placement:** `.text.buster_start` holds the same functions in both.

## Mutants (`mutation/`)

Mutants of the vector code on the deletion, run through test-checker's parts with `--fail-fast` (`run-mutants.sh`,
`mutants-a.py`, `mutants-a-batch.py`). Results are in `results.txt`.

- **Killed by the existing tests:** m1 to m5 (the entry classes' VECTOR compare, the labels' kind span, the builtin
  rows' plain char, the volatile scan's last lane, the named rewrite's last lane).
- **Survived, then killed after new fixtures:**
  - m7 (the named result's 16th control lane) and m8 (the eighth returns-twice name), by `24a4b8f52`;
  - m6 (the forwarding check's 16th lane), by `50e2ebbe6`. m6 changed the code (`m6-default.diff`, `m6-tier1.diff`:
    `g13`'s last call then passes its hidden pointer on) but no run's values. `50e2ebbe6` checks the lowered calls
    themselves (`BUSTER_TIER0_RESULT_HIDDEN`).
- **m9,** in the batched fragments' writer: killed by the restored batch comparison (`13fd695ec`).

## Local checks (`local/`)

Run in a 4-core AVX-512 container, CI's toolchain, Release:

- test-checker's 8 parts on every commit;
- the 34 checker blocks of `tools/ci/correctness.tests`;
- UBSan, ASan and MSan through test-checker's 8 parts: 24 of 24 passed;
- `test-lowering-templates` on main.c, with no difference across its 1,535 functions.
