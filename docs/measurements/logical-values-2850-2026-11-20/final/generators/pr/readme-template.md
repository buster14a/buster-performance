# An operator's value and a comma on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes `&&` and `||` as values, `?:` and a comma on the front's window, in the node
machine's C (a record's context, target and template) and in its X (the rows' entries), where both listed them:
[its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495), and the census before
it, [logical-values-census-2850-2026-11-20](../logical-values-census-2850-2026-11-20/). The piece before is
[x-values-2850-2026-11-20](../x-values-2850-2026-11-20/). Nothing here is in a compile: every reading is the
shadow's (`measure-node-machine --shadow --passes 0 --window-rows`), which runs the window's sweeps beside the
reference, C and X on T's columns at reader time, and compares.

The code is buster `{{=d('checks','revision')}}`'s, which is main `549613156` with `final/9700x/xl3.patch` (the cloud checks ran
on that commit; the pull request's first commit has its sources byte for byte).

## 1. The builds (`builds/`)

Three builds were read on the 9700X, each by `builds/job-xl.sh LABEL PATCH REVISION RUNS BASE SUFFIX`: a Release
build of PATCH on REVISION (`build-label.sh`), the piece before's executable (BASE, REVISION as it is), and in each
of RUNS readings the build, the piece before's twice, and the build again, on `sqlite3.c`, Lua 5.4.8's 34 files and
musl's 1,336 units (`turns.sh`, `turns-env.sh`, `corpora.sh`), CPU 2, each run its own hold of the lock
(`lock.sh`). A reading's file is `results/LABEL/TAG-CORPUS-SUFFIX-N.txt`, the shadow's own report.
`xl-table.py results LABEL BASE SUFFIX` makes a build's table: a line's median of the seven readings of the build
(the mean of its two runs a reading), of the piece before's, and of their difference a reading, each with its
lowest and highest.

| build | its patch | on | against | its table |
| --- | --- | --- | --- | --- |
| the first | `builds/xl1.patch` | `8a7427df2` (#3197's head) | the same revision, `xlb` | `builds/xl1/table.txt` |
| the second | `builds/xl2.patch` | `8a7427df2` | `xlb` | `builds/xl2/table.txt` |
| the code | `final/9700x/xl3.patch` | `549613156` (main, #3197 merged) | `xlm` | `final/9700x/table.txt` |

{{file:builds}}

What changed between them:

- **The first to the second** (C's loop alone; the rows' code is the same). The first had two more permutes a
  block: the block's answers by each record's consumer's lane, for a `!` that is not over an `&&` or an `||`,
  whose answer is its consumer's; and the block's classes by the consumer's lane, to ask a comma's consumer's
  class before the loop that read its type. The second has neither: a `!` under an operator is entered or chained
  as an `&&` is, and a value whose first operand is a `!` lists; every comma under a wrapper or an arm loads its
  consumer's byte. A comma's and a conditional's keys were three blends in a row on the templates' register; the
  second makes the three keys beside the templates and places them in one blend. A discarded comma's context was a
  second blend into the contexts' register; the second stores a byte a discarded comma. And a `!` at a block's
  first lane read the operator of the record below it, a load a block, to list a run that starts in the block
  below; the second lists it from below, the block's last record that is a branch operator under a `!`.
- **The second to the code:** the first fault round's changes (section 2).

## 2. The fault rounds (`faults/`)

`make-faults-logical.py` writes a round's list, `faults-logical-round1.py` ({{=d('faults','round1')}} faults) and
`faults-logical-round2.py` (282, of which the second round ran the {{=d('faults','round2')}} in `round2-indices.txt`: every one whose
text changed, the new ones and the first round's survivors). A fault is one edit of the piece's code; a round is,
a fault, a Develop build and `test-checker --seed 133 --part 5/8`, with every fault syntax-checked first
(`syntax-check.sh`). Each round ran from the list's two ends at once: the 9700X from the first up
(`job-faults-values.sh` with `xlf1.patch` and `xlf2.patch`, the code of each round; `dev-mutant*.sh`), and the
cloud container from the last down (`local-round.sh`); `join-round.py` joins them by name (`roundN/9700x.txt`,
`roundN/cloud.txt`, `roundN/joined.txt`), and `account.py` counts them and says what became of each of the first
round's survivors (`final/generators/faults.json`).

| | faults | caught | survived |
| --- | ---: | ---: | ---: |
| the first round | {{=d('faults','round1')}} | {{=d('faults','round1_caught')}} | {{=d('faults','round1_survived')}} |
| the second round | {{=d('faults','round2')}} | {{=d('faults','round2_caught')}} | {{=n(len(v['derived']['faults']['round2_survived']))}} |

The first round's {{=d('faults','round1_survived')}}: {{=d('faults','taken_out')}} terms taken out of the code or left in the fault's simpler form, {{=d('faults','sink')}} of the rule for a
conversion the tasks put into an operator's arms as the first two builds had it, {{=d('faults','lined')}} that found a line of the
fixture or a pin to add (each caught in the second round), and {{=d('faults','nothing')}} that change nothing a program reaches. The
pull request's description names each. The second round's survivors, which change nothing a program reaches:
`{{=', '.join(v['derived']['faults']['round2_survived'])}}`.

**The rule for the tasks' conversions** (`node_contexts_sinks`). The first two builds had the reference's
`node_machine_sinks` term by term on the window's bytes. {{=d('faults','sink')}} of its terms' faults survived the first round: no
line of the fixture separated them. It is three terms now, each with a line, and lists what the others would
take: the code's build takes {{=n(v['xl2']['sqlite3']['counts on']['taken'] - v['final']['sqlite3']['counts on']['taken'])}}, {{=n(v['xl2']['lua']['counts on']['taken'] - v['final']['lua']['counts on']['taken'])}} and {{=n(v['xl2']['musl']['counts on']['taken'] - v['final']['musl']['counts on']['taken'])}} expressions fewer than the second on `sqlite3.c`, Lua and musl, and
lists {{=n(v['final']['sqlite3']['more on']['sunk'] - v['xl2']['sqlite3']['more on']['sunk'])}}, {{=n(v['final']['lua']['more on']['sunk'] - v['xl2']['lua']['more on']['sunk'])}} and {{=n(v['final']['musl']['more on']['sunk'] - v['xl2']['musl']['more on']['sunk'])}} more records for their target.

## 3. The probes (`probes/`)

`probes/cases21.py` is {{=d('probes','new_cases')}} one-statement programs written for this piece and a baseline (the same function
with an empty statement), each a file of its own run through the shadow by `probe.py`, which asks that no answer
and no entry differ from the reference's and that no chunk's second run differ from its first:

- a comma under each consumer, discarded and not, of each class, nested either way;
- a conditional with each arm's conversion and each kind of condition, of void's class, nested, as an argument;
- `&&` and `||` as values with each operand's class, with operators for operands, under and over `!`s;
- mixes of them (`plain`): operators' values nested either way and beside one another, under runs of `!`s, with
  conditionals, commas, stores and calls for operands, as values and in a statement's condition;
- nine statements whose answer is another record's, the next one's or a consumer's past a long operand, each
  after 0 to 69 padding statements of three records, so that each of its records lands on every lane of a block
  and each run of chained records crosses a block's end (`edge_not`, `chain`, `value_chain`, `discard`,
  `void_arm`, `shallow`, `held`, `held_far`, `comma_far`).

`probes/final/` is their run on the code's build (`compiler.sha256`), with every earlier piece's
(`values/`, `earlier/`): {{=d('probes','all')}} lines, {{=d('probes','disagree')}} that do not agree (`summary.txt`). `probe-summary.py` sorts the
piece's by what the window makes of each statement beside the baseline's (`summary21.txt`): {{=d('probes','whole')}} taken whole,
{{=d('probes','listed_c')}} listed by C, {{=d('probes','listed_x')}} listed by X and {{=d('probes','refused')}} refused as the reference refuses.

## 4. The final readings, and the checks (`final/`)

**The readings** (`final/9700x/`): `job-xl.sh xl3 xl3.patch 549613156 7 xlm -xl3` (`job-xl3.log`;
`results/xl3` and `results/xlm`, {{=v['final']['runs']['runs']}} runs, {{=v['final']['runs']['failed']}} without status 0; `table.txt`).

{{file:table}}

**Against the specification's gates:**

{{file:gates}}

Beside the gates, what the reference's C and X read on the newly taken records against what the piece adds over
all the records swept (`final/generators/beside.py`):

{{file:beside}}

**The cloud container's checks** (`final/cloud-checks/`, on `{{=d('checks','revision')}}`; `progress.txt`): a native Release
build (`build.log`); `test-checker --seed 133`, {{=d('checks','checker_parts_ok')}} of {{=d('checks','checker_parts')}} parts with status 0 (`test-checker/`); the shadow with
`--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's
own source, with the default warnings and with `-Wall -Wextra` (`shadow/`, {{=d('cloud','runs')}} runs, {{=d('cloud','runs_failed')}} without status 0); the
shadow's other modes on `sqlite3.c` and Lua (`modes/`, {{=d('checks','mode_runs_ok')}} of {{=d('checks','mode_runs')}} runs with status 0); the self-check, the
self-parse, `test-call-graph`, `check-call-graph` and the ownership check; and the complete driver's lists
(`complete-lists/`, `complete-light.log`, `complete-heavy.log`): {{=d('checks','complete_passed')}} of {{=d('checks','complete_items')}} items pass, and the one that does not
is the preprocessor's comparison with clang, whose {{=d('checks','preprocessor_differ')}} differing units of {{=d('checks','preprocessor_units')}} differ by where their line markers
place a token (the container's clang's resource directory is spelled two ways) and by no token.

**The compiler's own source, before and after** (`final/cloud-checks/own/`: `run.sh`, the piece's tree's source
through main `{{=d('own','before_revision')}}`'s build and through the piece's, with the default warnings and with `-Wall -Wextra`,
which read the same). The window decides {{=d('own','after','decided')}} of {{=d('own','after','expressions')}} expressions ({{=d('own','after','decided_share')}}%) where it decided
{{=d('own','before','decided')}} ({{=d('own','before','decided_share')}}%), and X makes {{=d('own','after','taken')}} tapes whole where it made {{=d('own','before','taken')}}: {{=d('own','more_taken')}} more, {{=d('own','more_taken_share')}}% of the
expressions. {{=d('own','after','valued')}} records are operators' values, {{=d('own','after','sunk')}} of them listed for their target; C lists {{=d('own','after','listed_logical')}}
expressions for a logical operator or a conditional where it listed {{=d('own','before','listed_logical')}}; and X lists {{=d('own','after','x_listed_branches')}} expressions at a
turn where it listed {{=d('own','before','x_listed_branches')}}. This piece's two listings at a turn are an arm converted to bool and a logical
operator's second operand of a narrow class, and the compiler's own source has `bool` where the three corpora
have `int`.

**The sanitizers** (`final/cloud-sanitizers/`, `sanitizers-parts.sh`, on the same commit): the native rows,
memory, address and thread: a Release build each, `test-checker`'s part 5, and for memory and address the shadow
with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source: {{=d('checks','sanitizer_ok')}} of {{=d('checks','sanitizer_steps')}} steps with status 0,
{{=d('checks','sanitizer_reports')}} reports (`progress.txt`).

## 5. The generators (`final/generators/`)

No number of the write-ups is typed: `pr/gen.sh` runs `values.py` (the three builds' tables into `values.json`),
`derive.py` (the gates' counts, the cost beside the reference's, the probes', the faults', the cloud runs' and the
fixture's, into `all.json`), `table.py` and `beside.py` (the tables), and `fill.py` over each template: the two
design sections (`node-machine-section.md`, `one-core-path-section.md`, placed by `apply-docs.py`), the pull
request's description (`pr/body-template.md`, with parts of the design section by `pr/extract.py`), the result
note (`pr/result-note-template.md`) and this file (`pr/readme-template.md`). A placeholder that names nothing fails
the run.
