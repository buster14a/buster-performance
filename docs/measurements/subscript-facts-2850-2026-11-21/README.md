# Projected subscript facts on the Step 1 lookup kernel

Buster [#2850](https://github.com/buster14a/buster/issues/2850) measured a lean subscript at 44.6 cycles and 189 instructions on SQLite. This experiment starts from [232da75f9](https://github.com/buster14a/buster/commit/232da75f980c7ff9f01ffa3d849d655970bbed78), where SQLite still has 6,812 subscripts among 291,021 window records. It studies the real lookup, the normal fallback and all work that publishes the lookup's inputs. The patches are private measurement variants of `measure-node-machine`.

The canonical builtin TypeId range saves 0.0616 TSC ticks per original SQLite window record with identical inputs and a fully charged producer, 0.0404% of that measured path. Lua and musl’s process medians span zero. The more aggressive common-standing rule saves 23–32 instructions per subscript, adds about 0.14 branch misses per subscript, and the new row flags cost more to publish on SQLite and musl. These results keep the changes in the experiment and leave the normal compiler unchanged.

## Operands and implementations

The census records both operands, the source position, the type row and canonical pointer-decay information, output and admission for every attempted subscript. In SQLite the existing short rule takes 6,679 and sends 133 to its full rule. The full rule handles 128 and leaves five to ordinary T. The lean packed invocation with one timed pass runs each position six times. The three checked/poisoned passes and three measured passes account for the repeated records. All six observations are in the compressed receipts.

The new rule recognizes three ordinary base standings. They are a nonconstant rvalue, a nonconstant lvalue and an lvalue carrying an address. Other standings and wide values take the original short rule. A static array with a constant index still takes the full rule to fold the address. Volatile lvalues, register arrays, incomplete elements, forward or reversed operand forms, unusual types and unknown rows retain their existing conversion and fallback decisions.

Buster already publishes the exact checked type word in each operand record. For the index, the intersection of a valid plain scalar type and the integer classification consists of builtin integer types. This follows from `node_machine_plain_kind` and `check_action_is_integer`. The common rule can obtain that classification from the checked word. The whole variant still reads the index row's canonical value type and promotion and reproduces both conversion flags. The lean variant drops that row read. Signedness and width stay in the original type and its word.

- **Projected flags.** The existing 64-byte type row gains two flag bits for an exact eligible unqualified or const array decay. A valid pointer to an object sets both bits when its row is constructed. An array gains a bit only when the canonical pointer type has actually been observed. The rule checks the resulting element's source-completeness position.
- **Existing decay slot.** The alternate build uses the existing pointer/array and complete-object bits and the canonical array decay entry directly. Type-row creation and decay publication are byte-for-byte source-identical to the predecessor. No row or operand record grows.
- **Index word only.** This ablation changes only the lean index classification in the predecessor’s mask-based rule. Array and pointer conversion, constants and output construction retain the predecessor’s code. It isolates the row-load change from the earlier shortcut’s branches.

## Correctness

Each source run compares the new short rule with its predecessor before either falls back to the existing general rule. The strengthened observer restores the same previous output, checks the admission Boolean and compares the entire 64-byte result. This includes the untouched conversion and call-argument bytes in the lean variant and the entire record on a refusal. The normal shadow compares with T, repeats over poisoned records and checks list membership and fallback. The ordinary compiler's diagnostics and ELF, the forced scalar mode and reader-time T/C/X checks are separate observations.

The generated fixture includes signed and unsigned standard integers, 128-bit and bit-precise integers, enums, char variants and boolean values. Base cases cover volatile and const, local and static multidimensional arrays, register names, null and integer-valued pointers, function-returned arrays, aggregates, inactive union address use, dynamic and constant offsets, reversed subscripts, bitfields, side effects and completion positions. Six independent invalid translation units exercise the ordinary diagnostic path.

## Measurement

Release executables on the locked Ryzen 7 9700X use one identical binary for control and variant, pinned to CPU 2. Buster's host lock covers every compiler invocation. A round lock holds the pair together among related jobs and releases after each round. Odd rounds run control first and even rounds run the variant first. The producer timer surrounds the complete fact table creation and every call publishing a window's input from T. The kernel timer covers one full pass including given records, leaves, lookup dispatch and scalar fallbacks over all windows. The inclusive number is their sum divided by every original window record. The separate full command has producer timing disabled and includes frontend, checking, shadow verification and PMU harness overhead.

The isolated symbol profiles count unthrottled user-mode events from `node_facts_subscripts_lean`, including its loop and dispatch. Work in the out-of-line general rule appears separately in the full measured pass. Each profile runs 120 counted passes, two additional split-timing passes per counted pass and three correctness/poison passes. The denominator is therefore 363 times 6,812 attempted subscripts. The periods are 300,007 cycles and 800,011 instructions. Event statistics record losses and throttling. Initial higher-frequency cycles and instruction profiles exceeded the host's configured sample rate. Some 1,009-event branch-miss profiles also contain explicit hardware throttle records. The raw files retain those attempts and the summaries use the unthrottled periods above and 5,003 events for branch misses.

The prior project's loads-only control measured 14.0 cycles in the same lookup. Even recovering the whole previously measured difference of 30.6 cycles saves only 0.72 hardware cycles per original SQLite window record. Sampling and full-process changes must be read at their respective denominators.

## Locked results

Paired medians are candidate minus control. The first table is per attempted SQLite subscript over three unthrottled profiles.

| Private implementation | Cycles per subscript, paired range | Retired instructions | Mispredicted branches |
| --- | ---: | ---: | ---: |
| Projected flags and common standings | -5.460 [-9.949, +8.129] | -22.647 | +0.140 |
| Existing decay and common standings | +0.607 [+0.121, +1.092] | -32.029 | +0.144 |
| Index word in original rule | +3.154 [-0.485, +8.007] | +11.000 | +0.006 |
| Canonical builtin TypeId range | -0.121 [-4.004, +0.000] | -8.412 | +0.008 |

The next table is TSC ticks per original window record, including every given record. Full-kernel figures include leaves and other lookups. Inclusive figures charge all input publication.

| Private implementation | SQLite kernel | SQLite producer + kernel | Lua producer + kernel | musl producer + kernel |
| --- | ---: | ---: | ---: | ---: |
| Projected flags and common standings | +0.139 | +1.628 | -1.332 | +10.553 |
| Existing decay and common standings | +0.164 | -0.840 | -0.244 | -5.381 |
| Index word in original rule | -0.008 | -0.188 | +0.144 | -1.250 |
| Canonical builtin TypeId range | -0.015 | +1.184 | -0.265 | +7.074 |

### Identical inputs and the cost of their producer

Each process charges its measured producer to both labels and times complete adjacent sweeps of identical inputs, including the given records. It warms each label twice and alternates the order across nine measured pairs. The next process reverses the starting order. Seven processes per corpus and label give 63 paired sweeps. The table reports the median of the seven process medians in TSC ticks per original window record.

| Corpus | A/A median | A/B median | A/B process range | Candidate faster | A/B change as a share of the producer-inclusive control |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | +0.0110 | -0.0616 | [-0.0770, -0.0332] | 55/63 | -0.0404% |
| lua | +0.0000 | +0.0108 | [-0.0272, +0.0349] | 28/63 | +0.0060% |
| musl | +0.0041 | -0.0149 | [-0.0260, +0.1627] | 37/63 | -0.0029% |

The separate full public command used one pass and disabled the producer timer. Across seven SQLite pairs, the canonical range changed total cycles by −7.61 per original window record, with a paired range of −37.33 to +27.65. The shared-input result isolates a repeatable SQLite lookup-path effect in the same executable. The independent full-command measurements allow either direction. The signed patches, full four-variant controls, A/A observations and recorded command outputs are included.

## Reproduction

1. Check out the full compiler base SHA in `patches/base.txt`. Apply exactly one patch from `patches/` to that checkout. Stage the two changed compiler files and compare `git write-tree` with the corresponding tree in `patches/revisions.txt`. Build with `./build.sh --config Release`.
2. Use the compiler without environment switches for the control half. Set `BUSTER_SUBSCRIPT_PROJECT=1` for the experimental half and add `BUSTER_SUBSCRIPT_VERIFY=1` for the source oracle. The directed generator accepts an absolute compiler executable as its first argument. It writes each source and a JSON-lines result table.
3. Replay a frozen corpus with `compiler measure-node-machine --shadow --facts --facts-lean --facts-packed --passes 1 --list 1` and the normal corpus preprocessor arguments. Omit `--facts-lean` for whole conversion records, omit `--facts-packed` for body windows, and use `--scalar` to exercise the scalar fallback. The additional reader check uses `--shadow --window-rows --passes 0`. The registered reports retain the individual diagnostics, admission counts and discrepancy keys.
4. Each hardware folder stores the compiler SHA-256, source tree and the compressed raw measurements. Run `python scripts/measure.py RESULTS_DIRECTORY` on an extracted directory to recompute the paired summaries. Its profile calculation verifies the measured pass count and rejects any counted event file with PMU loss or throttling. Phase names beginning with `misses_clean` use the verified 5,003-event branch-miss period.

The profiled phase’s whole-process elapsed time includes the repeated shadow experiment. The separate `full` phase reports normal execution of the public diagnostic command with one pass. These timings apply to `measure-node-machine`. The correctness receipts cover ordinary `-c` diagnostics and ELF bytes.

The final canonical-index ablation recognizes the compiler’s 14 builtin integer indices, contiguous from 2 for `_Bool` through 15 for `unsigned __int128`. The compiler’s existing `type_code_is_integer` uses that same range. A qualifier changes only the low three bits. A batch lacking any of these rows takes the old lookup, as does any index outside the range. The row definition audit checks every canonical TypeId, every qualifier and all 65 prefixes through the builtin table. All 33,280 decisions agree. Widening the range to include `__bf16` yields 392 false admissions and omitting the guard for short tables yields 1,064.

The directed TU contains 2,189 functions. Its 1,549 subscript windows include 300 left to ordinary T through vector mode and 919 through the scalar mode. Both builds compiled it and rejected each of the six invalid TUs. Default and `-Wall -Wextra` output, exit statuses and ordinary ELF matched. The 12 corpus mode/layout cells retain 5, 5 and 151 total subscript refusals on SQLite, Lua and musl. The alternate reader reports 26 distinct discrepancy keys per corpus, all zero. Six independent directed faults change a disposition or record. The source-position control moves one real aggregate subscript from its accepted use at 160380 to 160361, the token before completion. Control and predecessor both refuse the earlier use. Removing the completion check incorrectly accepts it. A separate mutation limited to unsigned indices rejects the unsigned fixture while preserving the signed fixture.

The apparent second indirect lookup has substantial reuse. SQLite’s 6,812 positions use only ten index rows. The top four account for 98.14% and ordinary `int` alone accounts for 86.71%. The four most frequent indices account for 96.99% on Lua and 98.98% on musl. These frequencies quantify how often the same index recurs. A cache-hit-rate claim would require a separate hardware observation.

| Corpus | Original window records | All subscript positions | Short rule | Full rule | Ordinary T fallback |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 291,021 | 6,812 | 6,679 | 128 | 5 |
| Lua | 73,998 | 498 | 482 | 11 | 5 |
| musl | 130,291 | 3,033 | 2,707 | 175 | 151 |
