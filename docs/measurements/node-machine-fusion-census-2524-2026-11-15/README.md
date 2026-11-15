# buster#2524: the fused sweep's census (2026-11-15)

Claimed in [buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6892917544): the first
measurement that [the recovered design exploration](https://github.com/buster14a/buster/issues/2524#issuecomment-6892875893)
asks for before C is fused into T. T would classify each record's operands, as C does, at the record's own visit up the
postorder. Neither batching ([record](../node-machine-batches-2524-2026-11-14)) nor a layout
([record](../node-machine-layout-2524-2026-11-15)) leaves headroom on `sqlite3.c`; the gap to step 1's gate is
instructions, and C's are about 170 of the three sweeps' 585 a taken node.

**The result: a fused T would settle later 3.0% of `sqlite3.c`'s taken expressions, 12.3% of Lua's and 7.2% of
musl's. Every context a consumer's own context gives was a plain value, as T's visit would assume.** The census
counts; it doesn't time. Whether a fused T's code and predictions cost less than C is the prototype's measurement.

## What it counts

`measure-node-machine --shadow` at buster `92fdf308` (main `d356f725`, buster#2836's two commits and this census),
whose report's `node-shadow: fusion` line is `node_shadow_fusion`'s, over each taken expression after the machine's
three sweeps:

- **Inherited contexts:** an evaluated record whose context and target its consumer's own context gives:
  a `SELECT`'s operand, or a comma's second operand (check_lower_template_classify's two cases). Its consumer's
  consumer gives that context, after T's visit of the record's consumer. "Not a value" counts those whose context was
  an address or a discard.
- **Unevaluated records**, and of them those under an unevaluated consumer: a fused T classifies a record at its
  consumer's visit, so a record whose consumer turns out unevaluated (under a folded constant, `sizeof`, a decided
  condition) was classified for nothing. A record whose consumer is evaluated but doesn't evaluate it costs nothing.
- **Calls below another call:** an evaluated call's depth among the evaluated calls numbers its row, and is its
  ancestors'.
- **Segments or splits** (a record followed by its consumer's segment or an update's first row), **update plans** and
  **labeled expressions**, which a fused T writes at the consumer's visit, as C does.
- **Expressions settled later:** those with an inherited context, a record classified for nothing or a call below
  another.

## The counts (`scripts/census.sh`, `results/*.txt`)

The cloud container's copies of `sqlite3.c`, Lua 5.4.8's 34 sources and musl's 1,336 units (`corpora.sh`'s set); the
machine takes the same expressions there as on the 9700X (`sqlite3.c`: 51,135 expressions, 257,263 evaluated nodes).

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| taken expressions | 51,135 | 10,444 | 21,604 |
| evaluated records | 257,263 | 57,779 | 110,119 |
| inherited contexts | 340 (0.13%) | 242 (0.42%) | 194 (0.18%) |
| of them not a value | 0 | 0 | 0 |
| unevaluated records | 34,829 | 16,384 | 20,708 |
| of them under an unevaluated consumer | 2,893 (1.1% of the evaluated) | 5,780 (10.0%) | 3,057 (2.8%) |
| evaluated calls | 13,351 | 4,049 | 5,357 |
| of them below another call | 325 (2.4%) | 176 (4.3%) | 318 (5.9%) |
| segments or splits | 5,724 | 1,429 | 3,032 |
| update plans | 3,795 | 880 | 2,606 |
| labeled expressions | 2,821 | 550 | 1,448 |
| expressions settled later | 1,554 (3.0%) | 1,281 (12.3%) | 1,550 (7.2%) |

- **The inherited contexts are few, and always values**: a fused T can classify them as values at once and check the
  assumption when the consumer's consumer arrives, and refuse the expression (leaving it to the pipeline) where it fails.
- **Lua's wasted classifications are a tenth of its evaluated records**, `sqlite3.c`'s a hundredth: Lua's macros fold
  more constant subexpressions whose operands T types.
- **The calls below another call are few**: their rows' numbers can be a fix-up after T, over the calls alone.

## Checks

The census reads the machine's records after the sweeps and changes none: `test-checker` passes (841,797 checks, 0
failures), and the shadow's comparison on the three corpora reports no difference (`results/*.txt`).
