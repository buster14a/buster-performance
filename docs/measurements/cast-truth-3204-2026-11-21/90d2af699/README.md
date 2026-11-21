# Address-only branch-truth fix at 90d2af699

The candidate corrects the branch diagnostic on all 4,200 address-cast rows checked against Clang. Its ordinary and shadow results also match the reference on the four frozen corpora. The locked cost test misses T5 on musl. The first sweep's median rises by 1.77176 TSC ticks per record, exceeding the issue's +0.20 refutation threshold. SQLite and Lua meet the requested first-run bound.

| Paired C-loop change, ticks per swept record | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| First run median | −0.11934 | −0.15574 | **+1.77176** |
| First run range | −0.36719 to +0.25352 | −0.23757 to +1.22867 | −4.39510 to +11.38406 |
| Same-chunk repeat median | −0.09481 | −0.03873 | +0.04751 |
| Same-chunk repeat range | −0.22042 to −0.02205 | −0.08287 to +0.10182 | +0.01425 to +1.78319 |
| Records swept per invocation | 321,434 | 91,252 | 377,187 |

The reference is the [frozen #3213 Release executable](../../tests-holes-2850-2026-11-21/9700x/observed/README.md). The candidate is 90d2af69994b32784de39f00a4da3e4161c38b73. The included patch reproduces it from 0647d69ba8af4e466c89df2519dea0b382524d37 and hashes to f186273ffbe770e3ca746721f197499980d78dc67e5383429e954701b9420bcf. The candidate Release executable hashes to ff265146bd8ec0e13a5e0426ef5c6c97410194755479d41ac9fb9830843fdf52.

Clang 23.1.4 built the candidates. The original batch ran each executable twice in seven A–B–B–A rounds per corpus on CPU 2 of the Ryzen 7 9700X. Every invocation held the host lock and used a fresh executable copy for its round. The C-loop numerator and its divisor come straight from the compiler report. All 84 invocations exited zero and their shadow comparisons found zero differences. The archived baseline and candidate `node_contexts_window_loop` disassemblies contain 1,349 and 1,314 instructions, respectively. These function-wide static counts include branches and their side paths.

```sh
tar -xJf timing-runs.tar.xz
python3 ../intermediate/c-loop.py refcast90d cast90d -cast90d
```

## Diagnostic and shadow checks

The matrix in `corpora.tsv` compares ordinary syntax checks and window-shadow reports on SQLite, Lua, musl and the compiler's own source. Both binaries used the same frozen inputs under default warnings and under `-Wall -Wextra`. Each ordinary check exited zero with exactly identical stdout and stderr bytes. The table includes per-input diagnostic hashes and sizes. Every shadow comparison reported zero differences, including branch truth, and the numbers of C decisions, complete X tapes and entries agreed. `corpora.tar.xz` contains all sixteen shadow reports. SQLite's only pre-fix cast-mask hit was on an unplaced record, as the [separate trace](../trace/README.md) shows.

The exact-head Develop build matched Clang 23.1.4 on the original 805 cases and all 4,200 address rows, including both FP environment settings. Each 2,100-row environment fixed 407 former differences. The 4,800 builtin object-size query rows preserved the predecessor's behavior, including its own Clang differences. A separate 3,600-case mixed set fixed 164 differences and introduced none. The independent 7,636-row compiler matrix also introduced zero new differences. The source-mutation tests distinguished four of seven mutations through normal GNU17 and C23 inputs. One additional mutation was distinguished by replaying the implicit representation. Two mutations had no observed source-level effect and remain recorded as such. The scripts, provenance and exact outcomes are under [direct/](direct/). Set `BUSTER_QA_CLANG` to the pinned Clang binary for the mutation replay.

The frozen performance result and the diagnostic evidence belong to this source revision. Separate timing controls and subsequent performance candidates have their own receipts.

[Matched-binary and reversed-order musl controls](controls/README.md) quantify the variability of the first context sweep.

The [predecessor campaign](campaign/README.md) preserves all eight checker shards, eight driver shards, the fixture sweeps under three warning policies, and six seeds of 15,000 generated programs each. Its warning-trigger and fixed-probe stages stopped when 24c16e298 replaced this revision. The manifest and cancellation point identify the exact coverage of this run.
