# The lowering without the controls' totals (buster#2536, step 2.2c.3, part 1, 2026-11-15)

Step 2.2c moves `check_program`'s per-body loop into the windows. A window is then lowered before the checker has
written the controls of the bodies after it. Today the lowering's preparation (`check_lower_prepare`) and each lane's
writer (`check_lower_writer_begin`) read the controls' totals in six places. Part 1 of step 2.2c.3 removes the reads that
size the writer's rooms and that decide the jump tables. It does this under a test option, `--deferred-lowering`, on one
lane and without `--tier1`:

- **Entries and label entries:** their rooms take the controls' room that the checker's setup reserves
  (`CheckProgram.control_capacity`).
- **Chains' destinations:** their room takes the stops' room (`chain_stop_capacity`).
- **Calls:** the calls' room leaves out the cleanups' calls. Before each part, its writer grows its calls' and ABI's
  columns to the part's cleanups (`check_lower_fit_calls`). A bound known before the loop would be quadratic, exits times
  records.
- **Jump tables:** each part's lowering decides the tables of every body up to the part's end
  (`check_lower_deferred_part`). An inline callee's part, which the windows lower first, therefore numbers them in source
  order, as before. A run again as one part decides them again.

The helpers, the runtime symbols, the initializers' pools and the asm plan, which also read controls, are parts 2 and 3.

The gate: with the option, every object is the same bytes at windows of 1, 2,048 and ∞ tokens, and every other object
is the same as before.

The executables are buster `eda17af70f657ca3f23744f32fe869997e30202f` (the pull request's head, buster#2849) and its
base, main's `972a95e47edbc9502d91687d3373f413aa194b5b` (`raw/9700x/COMMIT.*`). Both are Release builds made under the
9700X's lock (`raw/9700x/build.*.log`, each with its SHA-256).

**In short.** On all 1,592 units of the corpora and the checker's 1,069 fixtures, the head's object, stderr and exit
status are the base's, and the deferred lowering's are the plain path's at all three window sizes. On the 9700X the
compile's time and cycles are the base's. Its user instructions are 0.64 M more on `sqlite3.c` (+0.05%) and 3.69 M more
on `main.c` (+0.03%). Two earlier rounds narrowed that from 1.10 M and 4.94 M. The option itself costs 0.03 M.

## What was run

`scripts/run.sh` ran as a user unit on the host:

1. both builds;
2. one hold of the lock a corpus for `scripts/objects.sh`. Each unit was compiled by the base's `-c` and the head's `-c`,
   then by the head's `--deferred-lowering -c` at `--emit-window=1`, the default 2,048 and 0 (∞). Each pair's objects,
   stderr and exit statuses were compared;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds. Each round ran the base's `-c`, the
   head's `-c` and the head's `--deferred-lowering -c`, counted by `perf stat`, and alternated their order.

Every compile ran on CPU 2 with `--lanes 1`.

- **The corpora:** step 1's (`sqlite3.c`, Lua's 34 sources, c-testsuite's 220 programs, `main.c` (the head's) and musl's
  1,336 units), and the head's `tests/checker` fixtures.
- **What the fixtures add:** 744 of them are refused with diagnostics, which the comparison covers too. The other 325
  make objects, among them 34 units with `cleanup` variables, the only ones whose parts grow the calls' room.

## The objects

| corpus | units | the head's the same as the base's | deferred, the same as plain at W = 1, 2,048, ∞ |
| --- | ---: | ---: | --- |
| `sqlite3.c` | 1 | 1 | 1, 1, 1 |
| `main.c` | 1 | 1 | 1, 1, 1 |
| Lua | 34 | 34 | 34, 34, 34 |
| c-testsuite | 220 | 220 | 220, 220, 220 |
| musl | 1,336 | 1,336 | 1,336, 1,336, 1,336 |
| checker fixtures | 1,069 | 1,069 | 1,069, 1,069, 1,069 |

"The same" is the object (or both refused without one), stderr and the exit status. Each unit's line is in
`raw/9700x/NAME.txt`.

A cloud container's Develop build of the same code compared every unit plain and with the option. Every object, stderr
and exit status was the same:

- at windows of 1, 2,048 and ∞;
- with `-g` at 2,048;
- by `--scalar` at 2,048.

The comparisons are in `raw/local/` (`scripts/compare.sh`, `scripts/all.sh`). `test-check-lanes` passed its 8,786
checks. They emit its generated programs with the option at every window size, and by windows of 1 and 64 from a
writer that starts with room for one call, so that every part's fit pushes the columns again
(`CheckProgramLanes.deferred_call_room`).

## The compile

| file | build | task clock | user cycles | user instructions |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | 122.95 ms | 598.25 M | 1,363.697 M |
| `sqlite3.c` | head | 123.04 ms | 598.18 M | 1,364.335 M |
| `sqlite3.c` | head, `--deferred-lowering` | 123.02 ms | 599.04 M | 1,364.359 M |
| `main.c` | base | 692.29 ms | 3,512.72 M | 10,694.944 M |
| `main.c` | head | 692.28 ms | 3,515.25 M | 10,698.636 M |
| `main.c` | head, `--deferred-lowering` | 693.65 ms | 3,522.64 M | 10,698.665 M |

These are medians of 7 runs each (`raw/9700x/NAME.SIDE.N.csv`). The time and the cycles are within the runs' spread.
The objects of the last rounds are the same bytes by all three (`raw/9700x/NAME.*.same.txt`).

### The extra instructions, in three rounds

Neither the base nor the head without the option runs the deferred code, but the head counts more user instructions.

| round | head | on `sqlite3.c` | on `main.c` | what changed |
| --- | --- | ---: | ---: | --- |
| 1 | `c23f4b70` | +1.097 M (+0.080%) | +4.945 M (+0.046%) | the first commit |
| 2 | `fdebb207` | +0.422 M (+0.031%) | +3.063 M (+0.029%) | the per-part hook out of the part loop |
| 3 | `eda17af7` | +0.637 M (+0.047%) | +3.693 M (+0.035%) | the added fields last, the tables' setup out of line |

- **Round 1:** the hook at a part's start in `check_lower_part_body`, which every lowering's part loop inlines, grew
  `check_lower_part` by 160 bytes. Two instruction profiles of `sqlite3.c` (`scripts/prof.sh`,
  `raw/9700x-round1/prof/`, per-symbol samples of 100,003 and 100,019 instructions) put 6 to 9 more samples there in
  both, 0.6 to 0.9 M instructions. The profiles' other differences are within their own run-to-run spread.
- **Round 2:** the hook moved to the emission's caller (`check_program_emit_lower_half`). `check_lower_part` is then the
  base's size again, and the extra fell to 0.42 M on `sqlite3.c`.
- **Round 3:** the fields the change added in the middle of five structures moved to each one's end, and the deferred
  tables' setup moved out of line. The extra did not fall further.

What is left is in code the change hardly touches, and these profiles can't place it. `check_program_begin`, to which
the change adds two stores at its end, is 586 bytes smaller. The driver's argument loops (`main_information`,
`predefines_option`, `pp_clang_arguments`) are smaller too, beside the option table's one more entry
(`raw/9700x/sizes.txt` lists every uniquely named function whose size differs between the two builds). The time and the
cycles are the base's in every round.
The deferred lowering adds 0.025 M to `sqlite3.c` and 0.028 M to `main.c` over the head's plain path in every round.

### Rounds 1 and 2's objects

The two earlier rounds' objects are in `raw/9700x-round1/` and `raw/9700x-round2/`, and every unit was the same.

- **Round 1's comparison:** its first script (`scripts/objects-first.sh`) compared no stderr where neither compile made
  an object. Its checker fixtures were compiled again by `scripts/objects2.sh` (`raw/9700x-round1/checker.2.txt`): all
  the same.
- **Later rounds:** rounds 2 and 3 used that comparison for every corpus (`scripts/objects.sh`).

## Files

- `raw/9700x/`: round 3, the pull request's head: the objects' lines, the repeats' counts, the object comparisons, the
  holds' log, the builds', and the function sizes.
- `raw/9700x-round1/`, `raw/9700x-round2/`: the earlier heads' alike; round 1's with the profiles' per-symbol samples.
- `raw/local/`: the cloud container's comparisons and its `test-check-lanes` result.
- `scripts/`: every script as run.
- `SHA256SUMS`: every file's hash.
