# inc and dec against add and sub with an imm8 on Zen 5, Buster #181

Compiler branch: `claude/solve-181-inc-dec` of buster14a/buster, for
[this claim of a piece of #181](https://github.com/buster14a/buster/issues/181#issuecomment-6489451134), for #221.

The form choice (#221, `x86_semantics.c`) can take `inc` and `dec` for an add or sub of 1 or −1 where CF (and for −1
AF) is dead, a byte shorter than the imm8 forms, but leaves whether they cost more to its caller
(`BUSTER_X86_CONTEXT_INC_DEC`). Tier 0 asked for them always. The head asks where the Zen 5 model's observations
(`x86_zen5.c`) of `inc` and `dec` at 32 and 64 bits cost no more than `add`'s and `sub`'s with an imm8 of the same
width, in GPR latency, throughput and retired macro-ops, each known (`tier0_inc_dec`), and gives `measure-x86-zen5` a
seventh experiment: the twelve independent chains with a never-taken `jo` after each instruction (`branch`), whether
the pair retires as one macro-op. This record measures the eight cases on the 9700X and checks that Tier 0's code
doesn't change.

## Sources and host

Each tree is a `git archive` of its commit (`trees.txt`), extracted into a fresh directory on the 9700X and built there
by `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds (`logs/build-*.log`, each executable's SHA-256 in
`logs/all.out` and `logs/receipt.txt`):

- **main:** `6a713e5b61691751a18b1224dcd1f6ffbeb6e3aa`, the branch's base;
- **head:** `c2dafce20be8b66a1f6900e07937150e157be912`, the decision and the branch experiment.

The receipt (`logs/receipt.txt`): the AMD Ryzen 7 9700X, its kernel, clang 23.1.1, perf, CPU 2's governor and energy
preference (performance), and both executables' SHA-256. The input of `-c`, the 9700X job's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`), has SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

## Method

`scripts/all.sh` (with `scripts/env.sh`) ran everything, each build and run in a hold of the host's lock
(`~/buster-fast-bench/exclusive.sh`) of its own, pinned to CPU 2 where it measures:

- both trees' builds;
- the head's `test-x86-zen5` (`logs/test-x86-zen5.log`): every generated loop validated, both encoders agreeing, run;
- three processes, each one hold, of the head's `measure-x86-zen5 --only CASE --passes 11 --iterations 20000` for
  `INC_RM32`, `DEC_RM32`, `ADD_RM32_IMM8`, `SUB_RM32_IMM8`, `INC_RM64`, `DEC_RM64`, `ADD_RM64_IMM8` and
  `SUB_RM64_IMM8` on registers (`logs/measure-1.log` to `measure-3.log`): each case's seven experiments in rotating
  order over 11 passes, their median cycles, the passes' minimum and maximum, retired macro-ops (PMCx0C1, the empty
  loop subtracted), instructions and the generated code's FNV-1a hash;
- one hold of `-c` of `sqlite3.c` by each tree with the 9700X job's compile-time options (`-c
  -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite
  $sqlite/sqlite3.c`, with `SOURCE_DATE_EPOCH` fixed), the objects' SHA-256 in `logs/all.out`.

The lock's waiting messages, which name other sessions' and CI jobs' commands and links, are left out of the logs:
each locked log starts at its command's first line, and `logs/all.out` keeps only the lines `all.sh` prints
(`scripts/clean_logs.py`).

## Results

Medians of the three processes (each a median of 11 passes); every case and process agrees with the others, each
experiment to within 0.06% (cycles per instruction, or per pair in the mixes and before `jo`):

| Case | Independent | Six chains | Chain (written operand) | Chain (source) | Mix with ADD | Mix with IMUL | Before `jo` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `inc` r32, `dec` r32 | 0.1884 | 0.2144 | 1.0000 | 1.0000 | 0.3756 | 0.5003 | 0.3348 |
| `add` r32, imm8, `sub` r32, imm8 | 0.1884 | 0.2144 | 1.0000 | 1.0000 | 0.3756 | 0.5003 | 0.3348 |
| `inc` r64, `dec` r64 | 0.1884 | 0.2144 | 1.0000 | 1.0000 | 0.3756 | 0.5003 | 0.3348 |
| `add` r64, imm8, `sub` r64, imm8 | 0.1884 | 0.2144 | 1.0000 | 1.0000 | 0.3756 | 0.5003 | 0.3348 |

Over the 24 runs of each experiment (eight cases, three processes): independent 0.188312 to 0.188394 cycles, six
chains 0.214347 to 0.214475, both chains 1.000020 to 1.000023, the ADD mix 0.375570 to 0.375672, the IMUL mix
0.500257 to 0.500278 and before `jo` 0.334771 to 0.334807 cycles per pair. Each instruction retired as one macro-op
(0.999999 to 1.000000 with the empty loop subtracted), each mix pair as two, and each pair of an instruction and its
`jo` as one (1.000024 to 1.000025): all four fuse with the branch. The two chains are one loop for these
one-register forms (the same code hash).

So `inc` and `dec` cost what `add` and `sub` with an imm8 cost on Zen 5, before a conditional branch too, and match the
model's observations (GPR latency 1, throughput 48/256 = 0.1875 of a cycle, one macro-op). Tier 0 keeps asking for
them, as it did: the two trees' `sqlite3.c` objects are the same bytes, SHA-256
`9048dda48896c43fd071e610d050c465d05d141a23689669bf272f1b35bbdcd0`, so the head changes neither Tier 0's code size
nor its code's speed.

## Limits

These are the model's register fixtures (`measure-x86-zen5`'s loops of 240 instructions, their loop overhead
included), not whole programs: memory destinations, partial-flag consumers and other branches than `jo` aren't
measured. The decision reads the model's existing observations, which these runs confirm; it adds no case to the model.
