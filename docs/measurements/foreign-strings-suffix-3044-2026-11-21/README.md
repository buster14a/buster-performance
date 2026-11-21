# One-byte suffix sharing in foreign string merging, Buster #3044

**Cloud-container record, not a 9700X qualification.** Every timing here comes from Develop builds in a shared 4-CPU
claude.ai cloud container (Intel Xeon, about 2.3 GHz), run interleaved against main's build in the same container.
They compare designs and expose costs; they do not satisfy the repository's rule that a part staying scalar gives
9700X figures. Those figures are owed. Byte counts and object identity don't depend on the host.

Compiler issue: [#3044](https://github.com/buster14a/buster/issues/3044). Compiler branch:
`claude/brave-edison-99ysr5-3044`, one commit (`b9a1c58e2` on main `a3aa9ed9a`). Its tree equals the measured
build's (`42c30da18` on main `b86eadcbd`; the rebase moved no line of the six files it changes).

Builds (Develop, `./build.sh`):
- `compiler-main-b86`: main `b86eadcbd`.
- `compiler-r2`: the branch's first, scalar design (a hash index over every owner's suffixes), kept for comparison.
- `compiler-impl`, `compiler-final`: the sorted block-head design before and after its review fixes.

## The rule

A one-byte entry that equals no suitable owner tries one more place: the end of its block head, the earliest one-byte
entry of its group (owner or not) whose content ends with its own, where that offset meets its effective alignment.
At alignment 1 this equals the first earlier, longer owner whose end meets the alignment (the r2 rule, which walks
the owners). At alignment 2 or more the walk tries further owners and the head rule doesn't.

- `models/rules.py`: main's, the walk's and the head rule's pool sizes over the mergeable string sections of ELF
  objects, in link order. `models/cases.py`: the test's hand-worked cases and random trials under each rule.
- `models/model.py`, `models/stress.py`: an exact design that keeps the walk (not taken); it matched the walk on
  2,600 suffix-chain and 4,000 alignment-heavy trials.
- `models/filter.py`: the prefilter that flags contents with a proper extension in their group.
- `models/sortproto.c`: a C prototype of the sort, LCP and head passes. `models/harness.c`: the review's harness,
  which includes the branch's `foreign_strings.c` and checks it against independent head and walk models.
- `models/fastmodel.py`: a quick model the review used for the head rule.

## Bytes (host-independent)

242 generated programs (`scripts/genc.py`, `scripts/genlink.py`): 40 or 41 for each of clang and gcc at -O0, -O2
and -Os, each compiled to objects and linked by `link-foreign` (`scripts/relink-main.sh`). Each program's
`.rodata` in bytes, summed over its group (`results/rodata-main-final-nomerge.txt`):

| Programs | Main, `--merge-strings` | Branch, `--merge-strings` | Main, `--no-merge-strings` | Branch smaller / larger |
| --- | ---: | ---: | ---: | --- |
| clang -O0 (40) | 50,793 | 40,165 | 72,960 | 40 / 0 |
| clang -O2 (41) | 52,219 | 40,751 | 76,037 | 41 / 0 |
| clang -Os (40) | 50,793 | 40,165 | 72,960 | 40 / 0 |
| gcc -O0 (40) | 76,343 | 76,343 | 76,343 | 0 / 0 |
| gcc -O2 (41) | 54,261 | 49,507 | 78,942 | 41 / 0 |
| gcc -Os (40) | 50,793 | 40,161 | 72,960 | 40 / 0 |

Every program links and prints its expected output with all three. Against the walk rule (r2,
`results/relink-final.txt`): 201 programs are equal, and 10 gcc -O2 programs are larger, 49,507 bytes in all
against 48,731; none is smaller. That is the head rule's cost at alignment 2 or more. In the test's hand fixtures,
1004 and 1008 come out at 22 and 65 bytes, as main's whole-entry rule gives them, where the walk gave 16 and 33.

## Timings (cloud, Develop; medians in ms of the merge-strings stage, `scripts/stage.sh`)

`stage.sh RUNS SHAPE COUNT BIN...` times `link-foreign --merge-strings --time --lanes 1` over the benchmark's kept
objects (`benchmark-foreign-strings --keep`), with the binaries interleaved run by run.

- **No-benefit shape (`lengths`: several lengths, nothing to share):** `results/g5-*.txt`. The branch is 1.45 to
  1.55 times main's stage at 4,096 literals over n = 201 runs, with one n = 51 reading at 1.62 times, and 1.38 to
  1.46 times at 131,072.
- **One-length shapes (`results/dup-unique-final.txt`):** `duplicate` is 0.247 to 0.283 ms against main's 0.202
  to 0.214 at 4,096 (n = 51 and 201), and 7.355 to 8.226 against 6.665 to 7.365 at 131,072. The same holds for the
  minima. These inputs sort nothing and their outputs are byte-identical to main's, so this is a cost on main's
  existing path; its cause isn't attributed yet. `unique` reads within noise at 4,096 and about 7 % slower at
  131,072.
- **Sharing shapes (`results/g6-final.txt`):** main / r2 / final at 4,096: `suffix` 0.102 / 0.964 / 0.465,
  `repeats` 0.207 / 0.517 / 0.438, `tie` 0.099 / 0.476 / 0.520. A real clang -O2 object (`br.o`): 0.057 / 0.678 /
  0.240. Here main's pool saves nothing, so main skips the copy and the consumer; the branch pays both, and on
  `br.o` the consumer then declines its pool (PC32 references).
- **Ties (`results/g6-adv.txt`):** a shared tail's depth no longer drives the cost. On the deep tail the branch
  takes 4.651 ms, against 4.399 on the shallow one (main 2.193 and 2.222).

## Owed on the 9700X

For each part that stays scalar (listed in `foreign_strings.c`'s header and `docs/foreign-string-merging.md`), the
same `stage.sh` readings on Release builds under `exclusive.sh`, one run per lock: `lengths`, `duplicate`, `unique`,
`suffix`, `tie` at 4,096 and 131,072, and `br.o` (any clang -O2 object with `.rodata.str1.1`), against main.
