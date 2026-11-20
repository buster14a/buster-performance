# Changed-frame visits in the foreign linker

A zero ELF64 RELA addend and `R_X86_64_NONE` cannot trigger `foreign_link_unwind_references`'s unsupported-interior-reference diagnostic. The candidate screens both immediately after decoding the entry. Eligible entries keep their symbol lookup, frame walk and error assignments. Both callers continue to send the complete table to the ordinary relocation importer. [Compiler change](https://github.com/buster14a/buster/commit/b415bc34bbfbfa673ac0b4d403bd4177e3be20ed) · [Issue #3166](https://github.com/buster14a/buster/issues/3166)

## Measured work

Each count is the number of times the body examining a `ForeignLinkUnwind` node ran during one whole `link-foreign` invocation. Each size has one losing COMDAT object, one changed frame plan for its owner, *N* zero-addend pointers to its retained function, a zero-addend pointer into its frame, one nonzero-addend `NONE`, and a valid nonzero-addend reference to its code. The fixture links with one and three lanes. Both lane counts produced the same totals.

| Link | Ordinary pointers | Baseline nodes | Candidate nodes | Baseline zero-addend / nonzero NONE / eligible |
| --- | ---: | ---: | ---: | --- |
| Ordinary relocation section | 64 | 69 | 1 | 67 / 1 / 1 |
| Ordinary relocation section | 256 | 261 | 1 | 259 / 1 / 1 |
| Merged `__start_table3166` section | 64 | 68 | 1 | 66 / 1 / 1 |
| Merged `__start_table3166` section | 256 | 260 | 1 | 258 / 1 / 1 |
| Positive or negative interior reference first, ordinary section | 64 | 70 | 2 | 67 / 1 / 2 |
| Positive or negative interior reference first, ordinary section | 256 | 262 | 2 | 259 / 1 / 2 |

The remaining visit in each successful duplicate-COMDAT link belongs to `kept3166+1`. Making the second COMDAT signature unique gave zero visits on both builds. In the counter-free Release disassembly the baseline reads the frame's section at `0x1c97350` and follows its next pointer before the type and addend branches at `0x1c97380` and `0x1c97393`. The candidate branches on the addend and type at `0x1c97488` and `0x1c97495`, before the symbol-map lookup. [Disassembly, full work counts and fixture output](hosted-vector.log)

## Correctness

The two sizes, nine variants and two lane counts gave **36 comparisons**. All 12 successful pairs had identical ELF bytes and executed with status 42. The ordinary duplicate-COMDAT images were 6,168 and 7,704 bytes. The bound images were 6,208 and 7,744 bytes. The losing object began with two FDEs. The linked image retained three FDEs across both objects, or four with unique COMDAT signatures.

All 24 refusal pairs preserved the existing nine-byte output and returned status 1 with identical stdout and stderr. The trace also compared the internal object, RELA section, original relocation index, symbol, type and byte offset against the first interior expression decoded independently from GNU `readelf -Wr`.

| First interior expression | Object | RELA section | Index at 64 / 256 | Symbol | Relocation type | Offset at 64 / 256 |
| --- | ---: | ---: | --- | --- | --- | --- |
| `middle3166+4` | 2 | 9 | 67 / 259 | 5 | `R_X86_64_64` (1) | 1,608 / 6,216 |
| `other3166-4` | 2 | 9 | 67 / 259 | 6 | `R_X86_64_PC32` (2) | 1,608 / 6,216 |

The target symbols are at offsets 8 and 12 in the retained CIE. Each expression names an interior byte. Reversing the pair changed the symbol and type selected. The ordinary caller printed `in l.o` and the bound caller omitted that suffix on both sides. A short field with a zero addend and an unsupported zero-addend `R_X86_64_COPY` still failed downstream at offsets 2,600 and 8,744. Putting that unsupported record before an interior expression preserved the existing precedence. The adapter reported the later interior record at index 68 or 260 and offset 1,632 or 6,240.

## Builds and reproduction

The clean patch has parent `198a76539df21f444e4be4e968a14f06fb43531f` and commit `b415bc34bbfbfa673ac0b4d403bd4177e3be20ed`. The paired experiment used GitHub-hosted Ubuntu 26.04 on an Intel Xeon Platinum 8573C qualified for the repository's explicit vector target, with its pinned Clang 23.1.4 Release build, GCC 15.2.0 and GNU as 2.46. The normal `test-foreign --cross-check` route invoked the fixture. It passed, including 408 pruning and 72 C++ runtime checks. The draft's hardware decision was `skip (pull-request)`. [Paired hosted job](https://github.com/buster14a/buster/actions/runs/44699071660/job/136163377533) · [Clean candidate run](https://github.com/buster14a/buster/actions/runs/44700901794)

The paired job checked out `9972f8d61a17ba7ceda23a3ee0c038efe9a59ee7`, GitHub's merge of evidence head `3818889768050931dfce79d46b0ea5401b00a1dc` into `cc5c15033efe9f26af774fdacb223931b308fee8`. The intervening main change was confined to foreign string pooling and its test. Both sides used the same driver, explicit vector path, assembled inputs and default pooling options. Two counter-free copies of the actual helper were kept out of line for disassembly. Separate copies counted frame-node visits. Each traced invocation also had to match its counter-free one byte for byte. [Experiment source](https://github.com/buster14a/buster/tree/3818889768050931dfce79d46b0ea5401b00a1dc/tests/foreign-unwind-references) · [Production patch](candidate.patch)

From a checkout of this measurement repository, run the following on an isolated non-9700X Linux host with the required ISA. Supply an existing Buster checkout that contains the base commit and a new or empty output directory.

```sh
bash docs/measurements/foreign-unwind-references-3166/reproduce.sh /path/to/buster /tmp/unwind-3166-results
```

The script builds the paired probe from the base, then builds independent clean baseline and candidate executables using the repository's `./build.sh --config Release`. It runs `test-foreign --cross-check` on both clean builds and compares whole output files, diagnostics and exit status directly. It leaves the worktrees and captures under the output directory. To compare two existing builds on the assembly fixture alone, use the following command.

```sh
bash docs/measurements/foreign-unwind-references-3166/run.sh /path/to/baseline/compiler /path/to/candidate/compiler /tmp/unwind-3166-fixtures
```

`input.S` is specific to these adapter checks. The prior baseline-only experiment established the walk and exposed a test assertion that assumed both callers print the object name. The paired run compares the complete diagnostic separately for each caller. [Initial observation](https://github.com/buster14a/buster/actions/runs/44697909259/job/136159592832)
