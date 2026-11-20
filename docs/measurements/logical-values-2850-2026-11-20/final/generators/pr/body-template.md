Part of #2850 (step 2). [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495), [its census](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-census-2850-2026-11-20), [the piece before](https://github.com/buster14a/buster/pull/3197), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-2850-2026-11-20).

> **It is exact and its faults are caught. Of its other four gates none is met in full, and none is refuted by its median.** It takes {{=d('sqlite3','more_taken')}}, {{=d('lua','more_taken')}} and {{=d('musl','more_taken')}} expressions more where 780, 355 and 950 were asked (L2: {{=d('sqlite3','short_of_asked')}} short on `sqlite3.c`, {{=d('musl','short_of_asked')}} on musl). A chunk's second run is within its gate for the rows, and C's reads +{{=f(float(val('sqlite3','(a second run) C, a record of the decided')))}} ticks a record of the decided on `sqlite3.c` where 0.35 was asked (L3). The rows' sweeps' cost a chunk is within its gate on `sqlite3.c` and musl by their medians and over it on Lua ({{=val('lua',"the rows' sweeps: a chunk's first run less its second, ticks a chunk")}}; 150 asked, 300 refutes: L4). The kernel, which the piece does not touch, reads a third of a tick less (L5). **And the cost no gate named is the largest: C's sweeps' first run over a chunk, less their second, rose by {{=rose('sqlite3')}}, {{=rose('lua')}} and {{=rose('musl')}} ticks a chunk.** Over all the records swept, a first run of the two sweeps adds {{=three('first_share','%')}} of what the reference's C and X read on the newly taken records; a second run, {{=three('second_share','%')}}. On musl a first run costs more than the reference's work it replaces. The piece runs in the shadow alone, so no compile reads a tick more.

## What it is

`&&` and `||` as values, `?:` and a comma were what C on the window listed most: C decided no expression with one, and X made no row of theirs. This makes them in both (`measure-node-machine --shadow --window-contexts` and `--window-rows`), in the sweeps that exist, each compared with the reference's answers and tape. **No compile takes any of it.**

- **A comma is a mask in C's loop** (`node_contexts_window_loop`): a wrapper's template with a key of its own, its first operand converted to void (a new source the targets' sweep writes) and its second to the comma's type, or to void where the comma is discarded. Its consumer says whether it is: a comma's first operand is; a wrapper's operand and a conditional's arm are where that record is of void's class, a byte's load a comma.
- **Each record says of itself whether it is evaluated as branches.** The loop said it by a record's consumer's class alone and listed every `&&` and `||` under a value. Now a branch operator is entered (the first operand of an `&&` or an `||`; an `&&`, an `||` or a `!` over one as a CONDITION's operand or a conditional's condition), chained (an `&&`'s or an `||`'s second operand, a `!`'s operand: it has its consumer's answer, and its consumer is the next record) or a value. The answers go down a run of chained records by two doubling steps of two masks, with a bit carried from the block after.
- **An operator's value has the template with two labels**: an `&&` or an `||` that is a value, and a conditional whose condition's truth is not known, with a key of its own (its arms are converted to its own type). A record at a time, for these records alone: `a ?: b`, and whether the tasks put its consumer's conversion into its arms (`node_contexts_sinks`), asked of a root in its expression's part. Each lists.
- **X's turns** (`node_rows_window_held`): the branches' loop takes an operator's value's turn too. Its condition has a tested value's segment with the operator's label; a conditional's first arm has its jump after its conversion's entries, by a table of the part's shapes; a logical operator's own row is four entries.
- **The numbering counts labels**, two an operator's value, and counts them apart from the calls' rows: an expression with one operator with labels has the labels 0 and 1 whatever calls it holds. It runs on {{=three('numbered_share','%')}} of the tapes.
- **Listed still:** a condition whose truth may be known, a folded conditional, a value whose first operand is a `!`, a `!` over an `&&` or an `||` under a CONDITION, a run of more than three chained records, `a ?: b`, what the tasks sink (and the little more the rule lists with it), a comma read for its address, folded or a comma's second operand, an arm converted to bool, a logical operator's second operand of a narrow class, and a selection.
- **The shadow's report** has a line for them: `window contexts valued=N (P% of the records swept) of-them-listed-for-their-target=N commas=N`.

## Measured

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks, seven readings; in each reading the build, the piece before's executable twice, and the build again.

{{file:table}}

Beside the gates, as the specification asked: what the reference's C and X read on the newly taken records against what the piece adds over all the records swept.

{{file:beside}}

How it came to its cost, a build a line (seven readings each; the first two against #3197's head `8a7427df2`, the third against main with it merged, `549613156`):

{{file:builds}}

## Against its gates

{{file:gates}}

## What stays a record at a time, and why

{{file:scalar}}

## What it means

{{file:means}}

## Tests

{{file:tests}}

## Checks

In the cloud container, on the code's commit `{{=v['derived']['checks']['revision']}}`, whose sources the first commit here has byte for byte:

- a native Release build; `test-checker`, all eight parts; the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra` ({{=d('cloud','runs')}} runs, no difference); the shadow's other modes on `sqlite3.c` and Lua ({{=d('checks','mode_runs')}} runs); the self-check, the self-parse, `test-call-graph` and `check-call-graph`; the ownership check;
- the complete driver's lists and parse: {{=d('checks','complete_passed')}} of {{=d('checks','complete_items')}} items pass. The one that does not is the preprocessor's comparison with clang, whose {{=d('checks','preprocessor_differ')}} differing units of {{=d('checks','preprocessor_units')}} differ by where their line markers place a token and by no token (each one's count is clang's), as on the pieces before in this container;
- the sanitizers' native rows (memory, address and thread: a Release build each, `test-checker`'s part 5, and for memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source): {{=d('checks','sanitizer_ok')}} of {{=d('checks','sanitizer_steps')}} steps with status 0, {{=d('checks','sanitizer_reports')}} reports.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
