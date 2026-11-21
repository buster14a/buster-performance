# The tests' holes and the objects' side (buster#2850's step 2), 2026-11-21

The evidence for the piece that runs the node machine's shadow over the compiler's own tests' programs and closes
what they show in the pieces before: [buster#3201](https://github.com/buster14a/buster/issues/3201),
[#3202](https://github.com/buster14a/buster/issues/3202), [#3203](https://github.com/buster14a/buster/issues/3203),
[#3205](https://github.com/buster14a/buster/issues/3205), [#3206](https://github.com/buster14a/buster/issues/3206)
and [#3207](https://github.com/buster14a/buster/issues/3207).
[The tests' specification](https://github.com/buster14a/buster/issues/3201#issuecomment-7058791784),
[the objects'](https://github.com/buster14a/buster/issues/3203#issuecomment-7059489314); the piece before,
[summary-facts-2850-2026-11-21](../summary-facts-2850-2026-11-21/). Nothing here is in a compile: every reading is
the shadow's (`measure-node-machine --shadow --passes 0 --window-rows`), whose status is 1 where reader time's answers
are not the pipeline's.

The code before is buster main `{{=v['before_revision']}}`; the code here is `{{=v['code_revision']}}`
({{=v['code_note']}}).

## 1. The sweep (`sweep/`)

- `extract.py OUT_DIR TEST_FILE...` writes every C string literal of the test files that is a program as a file of
  its own (`inline/FILE-LINE-NUMBER.c`, listed in `inline-index.tsv`): {{=n(v['programs']['inline'])}} programs of
  `src/buster/compiler/*_test.c`, of which the compiler accepts {{=n(v['programs']['inline_accepted'])}} with no
  option. `tests.list` is `tests/`'s {{=n(v['programs']['tests'])}} files ({{=n(v['programs']['tests_accepted'])}}
  accepted).
- `sweep.py COMPILER OUT.tsv JOBS [OPTION...] < FILES` runs each file through the shadow: a line a file, `rejected`
  (the compiler does not accept it with these options), `clean` (status 0) or `found` (status 1).
  `run-sweep.sh TAG COMPILER` runs both lists under the three warning sets: none, `-Wall -Wextra`, and
  `-Weverything -Wno-c++-compat` (`-Wc++-compat` is a warning no test stands for, which refuses every expression).
  The three sets took {{=n(v['sweep_seconds'])}} s on four cores with a Develop build.
- `classify.py COMPILER SWEEP.tsv... [-- OPTION...]` runs each found file again with `--list` and names its kinds
  from the report's difference lines.
- `fixture-lines.py COMPILER TEST_FILE NAME [OPTION...]` writes a fixture's text out of the test file and prints
  each annotated line with what the census did there.

| | the code before (`sweep/before/`) | the code here (`sweep/after/`) |
| --- | ---: | ---: |
| the tables' programs: rejected; clean; found, with no option | {{=semi([n(v['before']['sweep']['inline']['default'][k]) for k in ('rejected', 'clean', 'found')])}} | {{=semi([n(v['after']['sweep']['inline']['default'][k]) for k in ('rejected', 'clean', 'found')])}} |
| found with `-Wall -Wextra`; with `-Weverything -Wno-c++-compat` | {{=semi([n(v['before']['sweep']['inline'][s]['found']) for s in ('wall', 'everything')])}} | {{=semi([n(v['after']['sweep']['inline'][s]['found']) for s in ('wall', 'everything')])}} |
| `tests/`: rejected; clean; found, with no option | {{=semi([n(v['before']['sweep']['tests']['default'][k]) for k in ('rejected', 'clean', 'found')])}} | {{=semi([n(v['after']['sweep']['tests']['default'][k]) for k in ('rejected', 'clean', 'found')])}} |
| found with `-Wall -Wextra`; with `-Weverything -Wno-c++-compat` | {{=semi([n(v['before']['sweep']['tests'][s]['found']) for s in ('wall', 'everything')])}} | {{=semi([n(v['after']['sweep']['tests'][s]['found']) for s in ('wall', 'everything')])}} |

The kinds of the code before's {{=n(v['before']['programs'])}} programs (`sweep/before/classes-*.txt`; the same under
each set{{=must(v['before']['same_in_every_set'])}}; a program can have several):
{{=join(['%s %s' % (n(c), k) for k, c in sorted(v['before']['kinds'].items(), key=lambda p: -p[1])])}}.

`programs/programs.tar.xz` has the small programs the issues name and those written while reading each kind.

## 2. A trigger a warning (`triggers/`)

`triggers.py COMPILER OUT_DIR [PILE.tsv...]`: a program for each warning the census's table marks as tested, written
to warn (it must, with the piece of the compiler's message its entry names), or the first program of the sweep's
that shows the warning's event in an expression; each run through the shadow with its own options, with
`-Wall -Wextra` and with `-Weverything -Wno-c++-compat`. `before.txt` and `after.txt` are its lines:
{{=n(v['triggers']['tested'])}} warnings, {{=n(v['triggers']['written'])}} written and
{{=n(v['triggers']['from_piles'])}} from the sweep's programs on the code here ({{=n(v['triggers_before']['from_piles'])}}
on the code before, where fewer events reach an expression's tokens), {{=n(v['triggers']['none'])}} with none
(`-Wavailability`: the compiler has x86_64-linux-gnu's predefines alone). Runs that differ:
{{=n(v['triggers_before']['differ'])}} warnings' before, {{=n(v['triggers']['differ'])}} here.

## 3. The corpora (`corpora/`)

`sqlite3.c`, Lua 5.4.8, musl and the compiler's own source through the shadow, with no option and with
`-Wall -Wextra` (`sweep/run-corpora.sh`; `cloud/corpora.sh` has the units and their options): each run's report
(without the census's per-test lines) in `before/` and `after/`, and `compare-corpora.py BEFORE_DIR AFTER_DIR`'s
lines and table in `table.md`. Every count of what is taken is the code before's; what differs is the new lines'
counts and musl's expressions with nothing listed.

## 4. The generator's programs (`fuzz/`)

`fuzz-campaign.sh COMPILER OUT [COUNT]`: the side facts' record's generator (`../summary-facts-2850-2026-11-21/fuzz/fuzz.py`),
its six runs of 15,000 programs (seeds 61 to 66). On the code here {{=n(v['fuzz']['programs'])}} programs,
{{=n(v['fuzz']['rejected'])}} rejected, {{=n(v['fuzz']['clean'])}} clean, {{=count(v['fuzz']['found'])}} found
(`run-6*.log`); on the code before {{=n(v['fuzz_before']['found'])}} found
(`../summary-facts-2850-2026-11-21/fuzz/code/`).

## 5. The one-statement programs (`probes/`)

`probe.py COMPILER CASES` (a file a case, a line a case). `cases26.py` is the objects' side's
{{=n(v['probes_new']['lines'])}} units; the earlier pieces' cases are the earlier records'. `before/` and `after/`
have every case's line: {{=n(v['probes']['lines'])}} lines, {{=n(v['probes_before']['disagree'])}} that do not agree
before (all of `cases26`) and {{=n(v['probes']['disagree'])}} here.

## 6. The faults (`faults/`)

{{file:faults}}

## 7. The 9700X (`9700x/`)

{{file:x9700}}

## 8. The cloud container's checks (`cloud/`)

{{file:checks}}

## 9. The write-ups' numbers (`generators/`)

`values.py` gathers every number above into `all.json`, and `fill.py TEMPLATE all.json [KEY=FILE...]` fills a
template's expressions from it: the design's section, the pull request's body and this file are made so, and a
`must(...)` beside a verdict fails the run where its numbers do not hold.
