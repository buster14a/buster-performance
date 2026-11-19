# A condition's branches on the window (buster#2850), 2026-11-19

The record of [buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850)'s
next piece of C on the window: C's answers for a statement's CONDITION over
`&&`, `||` and `!`, which C evaluates as branches and no value, made on the
reader's window by the loop's masks. In the shadow alone
(`measure-node-machine --shadow --window-contexts`): no compile takes C's
answers on the window.

- [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7016320819),
  with its four gates (N1 exact, N2 what it decides, N3 its cost by one
  executable with a switch, N4 nothing else moves).
- The design and what it measured: buster's `docs/node-machine.md`, "A
  condition's branches on the window".
- A fault of the compiler the probes found beside it, not this piece's:
  [buster14a/buster#3028](https://github.com/buster14a/buster/issues/3028).

Every timing below is a TSC tick count on the 9700X (benchpress), CPU 2,
Release, each run its own hold of the host's lock. The counts are the cloud
container's runs.

## 1. What is here

| Path | What |
| --- | --- |
| `patches/` | each measured build as a patch on main `bc66290c5`, the revision the build before (`upd4`, #3025's code) was built on: `contexts-br1.patch` (the first build measured), `contexts-br2.patch` (the code of the pull request), and each with the experiment's switch (`-br1x`, `-br2x`). `knob-branches.patch` is the switch alone on the first build's sources, and `knob-edit.py` makes it |
| `9700x/results/` | every reading's output: `brN/window-contexts-*`, `brN/window-tests-*` and `brN/window-*` the piece's, `upd4/*vs-brN*` the build before's in the same job, `brN/compile-*` the `-c sqlite3.c` comparisons; `brNx/contexts-on1`, `-off1`, `-off2`, `-on2` the switch's four runs a reading; `br1x/order-*` the switch's settings in the other order on musl; `br1x/instructions-*` whole runs' counters |
| `9700x/gate-table*.txt`, `docgen-br2.txt` | build against build (`gate-table.py results upd4 brN`, `docgen-call.py results br2 upd4`) |
| `9700x/knob-br1x.txt`, `knob-br2x.txt`, `n4-br2x.txt` | the switch's tables (`knob-table.py results brNx`) and the tests' figure on and off |
| `9700x/instructions-table.txt` | `instructions-table.py results` |
| `9700x/asm/` | the loop's disassembly in each 9700X build, `hot.py`, and its count `hot.txt` |
| `9700x/counters/` | an experiment's counters around the loop: its edit, its three builds' patches, the job, every run's output and the table |
| `9700x/job-*.sh` | the jobs: `job-br.sh` and `job-br2.sh` (build against build as the record `a-call-on-the-window-2850-2026-11-19`'s `job-call-final.sh` runs it, then the switch as `an-update-on-the-window-2850-2026-11-19`'s `job-upd-knob.sh` does), `job-br-order.sh`, `job-br-instructions.sh` |
| `probes/` | `probe-b.py`, four lists of statements (`branches1.txt` to `branches4.txt`), and each list's output on the pull request's code with the head's pointer to an int in a segment's space (`-spaced`) and with a plain one (`-flat`); the first build's outputs of the first three lists |
| `fixture/` | the fixture's statements (`lines.txt`, `blocks.txt`), `probe-f.py`, which runs each alone in the fixture's own function, and its output |
| `faults/` | the two rounds' lists (`faults6-round1.py`, `faults6.py`), `run6.sh`, and each round's results |
| `cloud/` | the checks before pushing, the sanitizer rows, and the counts before the piece |

## 2. The counts (N1, N2)

`sqlite3.c`, Lua, musl and the compiler's own source, the same with the
default warnings and with `-Wall -Wextra` (`cloud/checks/shadow/`); "before"
is #3025's compiler on the same texts (`cloud/before/`, `cloud/before-main/`):

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the kernel places | 50,996 | 10,839 | 43,415 | 51,908 |
| expressions that differ from C on T's columns | 0 | 0 | 0 | 0 |
| records evaluated as branches | 5,613 | 570 | 2,364 | 13,975 |
| of them a statement's CONDITION | 2,198 | 230 | 877 | 3,366 |
| expressions decided: before, with | 47,266, 49,313 | 9,877, 10,079 | 40,937, 41,759 | 38,064, 41,314 |
| N2 asked | 49,200 | 10,050 | 41,650 | 40,900 |
| of the expressions placed: before, with | 92.69%, 96.70% | 91.12%, 92.99% | 94.29%, 96.19% | 73.33%, 79.59% |
| listed for `&&`, `\|\|` or `?:`: before, with | 2,744, 674 | 493, 290 | 1,787, 964 | 11,237, 7,924 |

The own source's text has moved since the specification, where it read 38,020
before the piece.

## 3. One executable, the block on and off (N3, N4)

An experiment's build has a switch (`BUSTER_TESTS_SKIP=1`) that skips the
piece's block by a branch and lists every `&&` and `||`, as before the piece.
With it off the executable decides what the build before does: 47,263, 9,877
and 40,937 expressions on the 9700X's copies of the corpora. On, off, off, on
in each of seven readings; each reading's own difference, the two on's mean
less the two off's.

The pull request's code (`br2x`, `9700x/knob-br2x.txt`, `n4-br2x.txt`):

| the block on, less off | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the loop, a record swept | +0.24 (0.10 to 0.35) | +0.27 (0.05 to 0.50) | -0.12 (-1.11 to 1.93) |
| the same in a second run over the same chunk | +0.21 (0.19 to 0.26) | +0.23 (0.22 to 0.46) | +0.24 (-1.38 to 0.30) |
| C's three sweeps, a record of the decided | -0.36 (-0.66 to -0.31) | -0.20 (-0.56 to 0.15) | -1.91 (-3.06 to 2.76) |
| the kernel in place, a record | +0.09 (-0.19 to 0.21) | -0.04 (-3.59 to 2.00) | -0.02 (-0.12 to 0.08) |
| the tests on the window, a record | +0.15 (-0.23 to 0.41) | -0.91 (-2.53 to 0.61) | -3.46 (-12.06 to 1.15) |

The first build measured (`br1x`, `9700x/knob-br1x.txt`), which had two mask
operations the first round of faults then removed:

| the block on, less off | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the loop, a record swept | +0.21 (0.17 to 0.31) | +0.21 (0.06 to 0.29) | +1.59 (-0.60 to 3.10) |
| C's three sweeps, a record of the decided | -0.52 (-0.62 to -0.38) | -0.32 (-0.48 to -0.15) | +1.42 (-2.37 to 4.75) |

**musl's first runs follow the order, not the setting.** The same executable
with the settings in the other order (off, on, on, off; `job-br-order.sh`,
`br1x/order-*`): the loop on less off -0.29 (-1.34 to 3.74), C's three sweeps
a record of the decided -1.93 (-3.56 to 6.24). The tests on the window, which
the switch doesn't touch, read +1.76 (-0.65 to 3.68) on less off in the first
order and +1.57 (-4.09 to 7.08) in the other.

## 4. Build against build

The build before (`upd4`, #3025's code) and the piece in turn in each
reading; medians of seven readings, musl's of fifteen. The pull request's
code (`br2`, `9700x/docgen-br2.txt`, `gate-table-br2.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| C's sweeps with the records' bytes, a record of the decided: before, with | 8.86, 8.38 | 13.55, 13.78 | 29.58, 30.72 |
| each reading's own difference | -0.55 (-0.88 to -0.42) | +0.29 (-0.45 to 1.92) | -0.09 (-9.06 to 9.55) |
| C's three sweeps alone, a record of the decided: before, with | 7.92, 7.46 | 11.97, 11.92 | 26.42, 26.66 |
| the reference's C on the same expressions: before, with | 38.2, 38.7 | 36.8, 37.2 | 41.0, 41.4 |
| the loop, a record swept: before, with | 2.97, 3.19 | 4.82, 5.17 | 9.05, 9.55 |
| the targets: before, with | 1.36, 1.36 | 1.53, 1.51 | 2.21, 2.27 |
| an expression's part: before, with | 1.71, 1.73 | 1.50, 1.49 | 2.05, 1.99 |
| the kernel in place, a record: before, with | 17.66, 17.37 | 22.40, 22.40 | 20.50, 20.39 |
| the tests on the window, C off: before, with | 31.4, 31.3 | 49.7, 49.6 | 94.7, 94.7 |

`-c sqlite3.c` as whole processes, which runs none of it: wall -0.08% and
+0.10% in two comparisons, where the base again read -0.09% and +0.15%.

The first build (`br1`, `9700x/gate-table.txt`): 8.90 to 8.52 on `sqlite3.c`,
13.31 to 13.67 on Lua, 28.66 to 32.33 on musl.

## 5. The loop's frame, and whole runs' instructions

**By the layout of the loop's function** (`9700x/asm/hot.py`: the
instructions from the target of its longest backward jump to that jump; the
blocks the compiler moved out of line lie after it), `9700x/asm/hot.txt`:

| the loop's main body | instructions | with an operand in the frame | zmm written to the frame | mask written to it, read from it |
| --- | ---: | ---: | ---: | ---: |
| the build before (`upd4`) | 746 | 219 | 33 | 17, 27 |
| the first build (`br1`) | 818 | 247 | 38 | 21, 22 |
| the pull request's code (`br2`) | 819 | 256 | 38 | 22, 28 |

This is a count of the function's text, not of what a step runs: the main
body has loops of its own and jumps over parts.

**Whole runs' counters** (`job-br-instructions.sh`: `perf stat` of a run of
`--window-contexts`, five runs each in turn, the first build's executables;
`9700x/instructions-table.txt`). User instructions, medians, and the
difference a record swept (a run sweeps a chunk's records more than once):

| | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| the build before | 4,405,951,736 | 2,078,457,782 |
| the switch's executable, the block off | 4,406,517,471 | 2,078,615,528 |
| the same, the block on | 4,407,910,797 | 2,078,858,387 |
| off less the build before, a record swept | +1.76 | +1.73 |
| on less off, a record swept | +4.33 | +2.66 |

On less off has the work of the 2,047 and 202 expressions the block decides
too (their records' comparison with the reference among it). The cycles of
these whole runs differ by about their spread, a part in two hundred, and I
read nothing from them.

A `perf record` of the same runs gave no annotation of the loop to read, and
its output is not kept.

**Counters around the loop itself** (`9700x/counters/`: `counters-edit.py`
adds to an experiment's build one group of counters, read before and after
each of the loop's two runs of a chunk and around nothing: user instructions,
cycles, and the loads and stores the core dispatches, AMD's LS Dispatch;
`job-loop-counters.sh`, three runs each in turn; `counters-table.txt`). A
block of 64 records in the loop's second run of a chunk, medians, less the
reads' own share:

| a block of 64 records | instructions | cycles | loads | stores |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`: the build before | 610.8 | 188.7 | 178.4 | 81.8 |
| the pull request's code | 688.9 | 210.9 | 207.1 | 103.8 |
| the switch's executable, the block off | 666.1 | 198.3 | 212.4 | 97.0 |
| the same, the block on | 714.1 | 219.4 | 222.7 | 95.4 |
| Lua: the build before | 636.4 | 207.4 | 182.8 | 83.7 |
| the pull request's code | 718.1 | 230.7 | 213.5 | 105.5 |
| the switch's executable, the block off | 693.1 | 218.0 | 214.5 | 97.8 |
| the same, the block on | 741.1 | 240.3 | 225.1 | 96.5 |

- **The loop's own stores are nine a block** (four columns and five masks, by
  its source): the build before dispatches 82, the piece's 104.
- **With the block skipped the switch's executable still runs 55 and 57
  instructions a block more than the build before**, with 34 and 32 more
  loads and 15 and 14 more stores: what the piece's presence costs outside
  its block.
- **The block itself** (on less off) is 48 instructions a block, 10 and 11
  loads, and 21 and 22 cycles: a third of a cycle a record.

The first run of a chunk retires the same instructions within four a block,
in 255 to 289 cycles a block on `sqlite3.c` across the four, 384 to 453 on Lua
and 523 to 618 on musl.

## 6. Statements one at a time

`probes/probe-b.py` puts each statement of a list alone in a function and
runs the shadow with C on the window and its comparison on it, in a unit with
a type in a segment's space and in one with none. On the pull request's code:

| list | statements | the checker accepts | with a difference |
| --- | ---: | ---: | ---: |
| `branches1.txt`: each rule's cases | 90 | 90 | 0 |
| `branches2.txt`: vectors, decays, absolute addresses, folded operators, classes no truth tests, effects, objects | 93 | 85 | 0 |
| `branches3.txt`: each kind of record of a half-precision float, a `__float128`, a long double, a 128-bit integer, a complex value, a `_BitInt` | 71 | 71 | 0 |
| `branches4.txt`: complex constants, `constexpr` objects, a label's address, compound literals | 17 | 11 | 0 |
| together | 271 | 257 | 0 |

- The eight of `branches2.txt` the checker rejects are a vector's `!`, `&&`
  and `||` and a vector's condition: the int's class of those operators asks
  no mask.
- The six of `branches4.txt` are `constexpr` at the default standard. With
  `-std=c23` their conditions are not among the expressions the kernel places.
- Two of `branches2.txt` (`*(int*)4096` first and second) exit 1 with no
  difference of C's: the reader-time verify counts two nodes whose value is
  not the action's, on the build before too. Following that count led to
  buster#3028.

The update piece's two lists (251 statements, 250 accepted) have no
difference either (`probes/updates*-b7-*.txt`).

## 7. The fixture

`fixture/lines.txt` has the 82 statements the piece adds to C on the window's
fixture, a line a case of a term, and `fixture/blocks.txt` the six that are
there 64 times each. `fixture/probe-f.py` runs each of the 82 alone in the
fixture's own function; `fixture/lines-b7.txt` has each one's counts and
their sums, which with the blocks' are the fixture's pins' rise:

| | the 82 statements | the six blocks | the pins' rise |
| --- | ---: | ---: | ---: |
| expressions | 160 | 768 | 928 |
| decided | 126 | 576 | 702 |
| refused | 8 | 0 | 8 |
| listed for `&&`, `\|\|`, `?:` | 30 | 192 | 222 |
| listed for a comma, for a value's width | 2, 2 | 0 | 2, 2 |
| records evaluated as branches | 142 | 896 | 1,038 |
| of them a CONDITION | 68 | 320 | 388 |
| consumers and operands read by loads | 14 | 0 | 14 |
| updates asked and taken | 2 | 192 | 194 |

## 8. Faults

One fault at a time in a copy of the tree (`faults/run6.sh`): the Debug
compiler built, `test-checker`'s part 5 of 8 run, and for a fault the tests
don't fail, the first three lists of statements in both kinds of unit against
the base's lines.

| round | faults | caught | did not build | survived |
| --- | ---: | ---: | ---: | ---: |
| 1 (`faults6-round1.py`, `round1-all.txt`) | 116 | 96 | 12 | 8 |
| 2 (`faults6.py`, `round2-all.txt`), the pull request's code | 116 | 112 | 0 | 4 |

**The first round's eight survivors:**

- **Two terms another record says, removed:** a branched truth's second
  operand's test (`made-right-test-of-all`: a `!` and a CONDITION have no
  second operand, and its bytes read zero) and a truth's own class
  (`truth-any-class`: an int's, the checker's).
- **Two cases with no line, added to the fixture:** a complex constant first
  (`variable-two-kind-bits`: `0.0i || a`), and a bit-field of an object first
  (`placed-not-wide`, which the statements told apart by a count alone).
- **Four that give the same answers**, there in the second round too:
  - `not-condition-too`: a CONDITION taken for a `!` under a logical consumer.
    A statement's CONDITION is a root, with no consumer.
  - `placed-any-kind`: an lvalue first whose constant is of any kind, not an
    address's alone. A placed record's lvalue has an address's or none
    (`constexpr` objects' conditions are not placed: section 6).
  - `sources-made-only`: a branched record with no template keeps its row's
    target. Its expression is refused, and its records are compared with
    nothing.
  - `sources-no-roots`: a branched CONDITION keeps its row's target. A root
    has no consumer's row, and its target is its expression's part's.

The twelve that did not build left a variable unused; the second round has
them with a mask that is always true or always false in the term's place, and
all twelve are caught.

## 9. The checks before pushing

In the cloud container (`cloud/checks-call.sh`, `cloud/checks/progress.txt`),
on main `6427879e1` and the piece's sources before their last comment and the
design's text:

| | |
| --- | --- |
| a native Release build | status 0 |
| `test-checker`, its eight parts (`cloud/checks/test-checker/status.txt`) | 8 of 8 with status 0 |
| C on the window on `sqlite3.c`, Lua, musl and the compiler's own source, with the default warnings and with `-Wall -Wextra` (`cloud/checks/shadow/`) | 8 of 8 runs with status 0, no difference |
| the shadow's eleven other modes on `sqlite3.c` and Lua (`cloud/checks/modes/`) | 22 of 22 runs with status 0 |
| the self-check, the self-parse, `test-call-graph`, `check-call-graph` | status 0 each |
| the build's ownership check | status 0 |
| the complete driver's light list | 4 of 5 pass; "Test the preprocessor on the repository's translation units against clang" fails in this container as in every run before the piece (its clang spells its include directory another way) |
| the complete driver's heavy list, and its parse | 2 of 2 pass; exit 0 |

After them a comment of the window's file and the design's text changed. On
that build, the pull request's commit: `test-checker`'s part 5 of 8 (210,344
checks, 0 failures) and C on the window on the three corpora again, with the
same counts and no difference.

**The sanitizer rows a pull request's checks skip** (memory, address and
thread, native; `cloud/sanitizers-native.sh`, `cloud/san/progress.txt`), on the
pull request's commit:

| row | what | result |
| --- | --- | --- |
| memory | the build; `test-checker`'s part 5 of 8; C on the window on Lua, `sqlite3.c` and the compiler's own source | status 0 each; 210,344 checks, 0 failures; no report |
| address | the same | status 0 each; 210,344 checks, 0 failures; no report |
| thread | the build; `test-checker`'s part 5 of 8 | status 0 each; 210,344 checks, 0 failures; no report |

## 10. What the probes found beside it

`if (*(int*)4096 && a)` exits 1 in the shadow's verify (section 6). The
compiler's code for it has no load: a condition on an lvalue at an absolute
address is compiled as true where the address is not zero. Twelve of twenty
forms lose the load (an `if`'s condition, the first operand of `&&` and `||`,
a conditional's condition); `!`, the loops' conditions, a comparison and a
second operand read. It is the checker's truth rule's (`check_action_truth`:
an lvalue with no object reads as known), which the lowering asks of an
operand's record as it stands, and C's `known` and this piece's mask of a
first operand's object read the rule as it is. buster#3028 has the listing
and the forms.
