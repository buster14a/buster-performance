# Inline assembly: naked functions, labels and names (#147), 2026-10-27

buster14a/buster's branch `claude/inline-asm-naked-147`, the second part of #147's inline assembly claim, against main
at its merge-base, on the 9700X (Ryzen 7 9700X, Zen 5). The branch compiles naked functions, makes the labels that
templates define into symbols, and resolves the other names templates use.

## Sources and binaries

- **Base:** main at `079af33a391de0d10740bc9768b6ece5f46b8740`, the branch's merge-base. That is #535's merge, the
  first part of the claim.
- **Head:** `c54b3cf33361d16ede07f852529f1e00769e9c06`. It merges that main into the branch's two commits:
  `fbbd26cd` (the assembler) and `f5e25df5` (the lowering).
- Each tree was sent with `git archive` into an empty directory. `manifest-079af33a.sha256` and
  `manifest-c54b3cf3.sha256` list every file. The trees on the host matched them file for file (635 files each),
  leaving out `build/` and `build.log`.
- Each tree was built with `LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh` under the lock. The executables' hashes, the
  toolchain and the inputs' hashes are in `identities.txt`.

Every measurement held the shared lock (`~/buster-fast-bench/exclusive.sh`) for itself. Each ran on CPU 2 unless said
otherwise, with base and head in alternating order. The logs leave out the lock's waiting lines, which name other
sessions' private links.

A first run measured #535's head `d9bd14be` against the branch's `f5e25df5`, before main moved on. It was stopped
after its drive check, when the branch merged main (`logs/first-pair/`). In that run both trees wrote the same object
as here.

## The default path: `-c` of sqlite3.c

The input is the frozen corpus's `sqlite3.c` (SQLite 3.53.2, `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`).
The options are `--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5
-std=gnu17 -nostdinc` with the corpus's three `-isystem` directories, and the output goes to `/dev/null`. The file has
no asm statement and no naked function. The run leaves out `--clang-features`, as #535's record did.

Both trees write the same object (`b4cc5868df7fafacd95cc01cef01066a`, `logs/queue.log`), which is #535's record's too.

| | main | head | |
|---|---:|---:|---:|
| Wall (`ab`, 5 rounds of 11 runs: the median and range of the rounds' medians, `logs/ab-sqlite.log`) | 187.15 ms (186.70–188.01) | 186.62 ms (186.12–187.48) | −0.28% |
| User instructions (`perf stat -r 11`, twice each, `logs/perf-sqlite-*.log`) | 2,189,610,811 and 2,189,610,815 | 2,187,800,096 and 2,187,800,097 | −0.083% |
| User cycles | 891.4 M, 888.5 M | 884.5 M, 885.3 M | −0.6% |
| Peak RSS (`ab`, the rounds' medians) | 662,960 KB | 662,024 KB | −0.14% |

Head runs 1,810,716 fewer user instructions, the same count in both `perf stat` runs of each tree: a code difference,
not noise. `scripts/step-profile.sh` sampled `instructions:u` every 200,003 instructions over 5 compiles of each tree
(`logs/profile-*.txt`), but the attribution it gives can't be trusted at this rate. perf's sample-rate cap dropped
samples: 48,214 and 48,516, where about 54,700 were due. The functions whose samples moved most between the trees are
of unchanged code. `check_driver_reports`, `check_graph_action`, `check_input_resolve_range` and `check_data_prepare` are
the same size in both executables (`logs/function-sizes.txt`), so their shifts are sampling noise. The functions this PR
changes are:

- `check_program_emit_lanes`, 7,373 bytes larger, with the names pass and the label definitions;
- `check_program_asm_plan`, which clang no longer inlines into `check_lower_prepare`;
- `check_lower_part`, 16 bytes smaller, whose loops run per entry.

On a unit without asm statements, the code the PR adds runs once per body or per function. That is a few instructions
each, about 2,700 times for sqlite3.c. So the reduction comes from how clang compiled the changed functions, likely
`check_lower_part`'s per-entry loops: about one instruction per entry would give it. This record doesn't attribute it
further. IBS, or a far longer sampling run, could.

## After merging main `78ec3f8a`

The branch then merged main at `78ec3f8a`, with #552, #536's jump tables and #557, as `81cec58f`. The merge numbers
the templates' own symbols after the jump tables' and adds no work to a unit without asm statements. `after-merge/`
has the same comparison against that main: base `78ec3f8a`, head `81cec58f`, each command under the lock on its own,
on CPU 2. `after-merge/scripts/queue-merge.sh` built base in the first try, and `queue-merge2.sh` built head and ran
the comparison. `after-merge/identities.txt` and the trees' manifests are beside them.

Both trees write the same object (`aa07c5e1c9468c495f50f704c2fb557d`, `after-merge/logs/queue.log`). #536's tables
make it differ from the object above.

| | main | head | |
|---|---:|---:|---:|
| Wall (`ab`, 5 rounds of 11 runs: the median and range of the rounds' medians, `after-merge/logs/ab-sqlite.log`) | 187.81 ms (187.15–188.23) | 186.69 ms (186.38–187.28) | −0.60% |
| User instructions (`perf stat -r 11`, twice each, `after-merge/logs/perf-sqlite-*.log`) | 2,191,975,215 and 2,191,975,216 | 2,190,834,683 and 2,190,834,683 | −0.052% |
| User cycles | 887.6 M, 887.5 M | 881.3 M, 883.3 M | −0.59% |
| Peak RSS (`ab`, the rounds' medians) | 664,040 KB | 664,040 KB | 0 |

Head again runs fewer user instructions: 1,140,532, the same count in both `perf stat` runs. #536's record
(`6328c266`) measured how much the placement of the same code moves this compile: up to 0.7% in cycles and about
2 M instructions between two builds of the same work. Both differences here are inside that, so this record doesn't
claim them for the PR's code.

Two tries before this one lost head's build to the host's `/tmp`. Its tmpfs had run out of inodes, so `mktemp` failed
with "No space left on device". Their logs are in `after-merge/logs/first-try/` and `second-try/`; their base runs
have no head runs to pair with. The third try ran once the tmpfs had inodes to spare again.

## After the review's fix (`e1dc5d01`)

The review found that a naked attribute on a later declaration than the function's first was missed. The fix,
`e1dc5d01`, makes `check_program`'s pass over the declarations test each function declaration's attributes. That pass
runs for every unit. `after-review/` measures it against main at `a66f8638` (#511, #568 and #517 after the last merge),
by `after-review/scripts/queue-review.sh`, each command under the lock on its own, on CPU 2, with `TMPDIR` on `/home`.

Both trees write the same object (`aa07c5e1c9468c495f50f704c2fb557d`, `after-review/logs/queue.log`).

| | main | head | |
|---|---:|---:|---:|
| Wall (`ab`, 5 rounds of 11 runs: the median and range of the rounds' medians, `after-review/logs/ab-sqlite.log`) | 155.60 ms (155.40–155.75) | 155.82 ms (155.51–156.12) | +0.14% |
| User instructions (`perf stat -r 11`, twice each, `after-review/logs/perf-sqlite-*.log`) | 1,724,011,571 and 1,724,011,570 | 1,724,634,978 and 1,724,634,982 | +0.036% |
| User cycles | 720.5 M, 722.4 M | 722.7 M, 724.7 M | +0.31% |
| Peak RSS (`ab`, the rounds' medians) | 618,804 KB | 618,896 KB | +0.015% |

Main's own `-c` of this file had dropped by 21% in user instructions and 17% in wall time since `78ec3f8a`.

A switch on one executable separates the fix's own work from the builds' placement. The switch,
`after-review/scripts/switch.diff`, isn't committed: `BUSTER_NO_NAKED_SCAN` skips the attributes' test, and
`queue-switch.sh` ran it. The two settings write the same object. Three `perf stat -r 11` runs of each, in turn (`after-review/logs/switch/`):

| | scan (the PR) | no scan |
|---|---:|---:|
| User instructions | 1,724,637,386, 1,724,637,395, 1,724,637,398 | 1,724,528,182, 1,724,528,177, 1,724,528,180 |
| User cycles | 722.3 M, 723.0 M, 722.2 M | 724.1 M, 721.9 M, 722.5 M |
| Task clock | 155.59, 155.60, 155.51 ms | 155.90, 155.43, 155.56 ms |

The test costs 109,213 user instructions (0.006%) and no time the runs can tell apart. The rest of head's 623,409
more instructions against main, and its cycles, are how clang compiled and placed the two builds, which #536's
record measured at up to 0.7% in cycles and about 2 M instructions for the same work.

## The assembler

`benchmark-assembler`, twice each (`logs/assembler-*.log`). The matcher admits more forms on head, and its parser
joins string instructions with their prefixes and chooses `movq`'s family by its operands.

| | main | head |
|---|---:|---:|
| Vector path, total | 1.485, 1.457 ms | 1.448, 1.453 ms |
| Scalar path, total | 3.655, 3.688 ms | 3.601, 3.570 ms |
| Match index | 419,496 bytes | 419,496 bytes |

## musl's symbols

CI's command (`--symbols-minimum 354`) ran on the frozen copy of musl's eight directories (`logs/musl-*.log`). Both
trees compare 354 files' objects with clang -O0's, with 0 different and 0 failures. musl's remaining inline assembly
refusals are x87 operand constraints, the matcher's SSE scalar instructions and explicit register variables. This PR
doesn't take those.

## main.c's three functions

`main_three.c` holds the three functions of `main.c` that #535 still refused, extracted as they are:
`interpreter_native_bridge`, `x86_semantics_test_enter` with its statics, and `x86_semantics_test_return_address`.
`scripts/step-three.sh` ran on it once under the lock (`logs/step-three.log`):

- head's `--verify -c` by the vector and the scalar paths: the same object;
- `nm`: clang -O0's symbols, `x86_semantics_test_return` among them, the naked functions at clang's offsets (0 and
  0xd0, the label at 0x1a4); ours adds `x86_semantics_test_return_address`'s helper, `.Lbuster_asm_2`;
- `interpreter_native_bridge`'s 203 bytes and `x86_semantics_test_enter`'s 437 bytes are clang's (the padding between
  functions differs: ours `int3`, clang's a multi-byte `nop`);
- their FDEs have no CFA instructions, over clang's ranges;
- with `-g`, their rows are at clang's lines (10 and 53), and `llvm-dwarfdump --verify` passes.

## Scripts

`scripts/queue.sh` built both trees and ran the drive check, the `ab`, the `perf stat` pairs, the assembler pairs and
musl's comparison. `scripts/step-three.sh` and `scripts/step-profile.sh` ran after it. `scripts/timed.sh` is the
wrapper `queue.sh` times musl's run with.
