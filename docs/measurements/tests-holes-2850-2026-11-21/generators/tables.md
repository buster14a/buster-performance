**Measured.** In the cloud container, a Develop build of the code here.

| | the code before | the code here |
| --- | ---: | ---: |
| the tables' programs with status 1: no option; `-Wall -Wextra`; `-Weverything -Wno-c++-compat` | {{=semi([n(v['before']['sweep']['inline'][s]['found']) for s in SETS])}} | {{=semi([n(v['after']['sweep']['inline'][s]['found']) for s in SETS])}} |
| `tests/`'s files with status 1, the same three | {{=semi([n(v['before']['sweep']['tests'][s]['found']) for s in SETS])}} | {{=semi([n(v['after']['sweep']['tests'][s]['found']) for s in SETS])}} |
| the generator's programs with status 1, of {{=n(v['fuzz']['programs'])}} | {{=n(v['fuzz_before']['found_all'])}} | {{=n(v['fuzz']['found'])}} |
| the one-statement programs that do not agree, of {{=n(v['probes']['lines'])}} | {{=n(v['probes_before']['disagree'])}} | {{=n(v['probes']['disagree'])}} |
| the warnings' triggers with a run that differs, of {{=n(v['triggers']['written'] + v['triggers']['from_piles'])}} (three runs each) | {{=n(v['triggers_before']['differ'])}} | {{=n(v['triggers']['differ'])}} |

How much is taken, on the four corpora (the same counts with
`-Wall -Wextra` but the tests', which refuse more there):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions T takes at reader time; before | {{=fourpair('t_taken')}} |
| expressions the tests take there; before | {{=fourpair('tests_taken')}} |
| the same with `-Wall -Wextra`; before | {{=fourpair('tests_taken', True)}} |
| expressions C decides on the window; before | {{=fourpair('c_decided')}} |
| tapes X makes whole; before | {{=fourpair('rows_taken')}} |
| records the kernel makes; before | {{=fourpair('kernel_made')}} |
| calls T refuses for their callee; before | {{=fourpair('t_refused_callee')}} |
| pointers' ordered comparisons left out | {{=fourcells('orders_left_out')}} |
| the program's own objects; objects a pragma labelled | {{=cells([n(v['corpora'][u]['own_objects']) + '; ' + n(v['corpora'][u]['pragma_labelled']) for u in UNITS])}} |
| declarations' lines made again | {{=fourcells('lines_again')}} |
{{=must(all(v['corpora'][u + w][k] == v['corpora_before'][u + w][k] for u in UNITS for w in ('', '-wall') for k in ('t_taken', 'tests_taken', 'c_decided', 'rows_taken', 'rows_entries', 'kernel_made', 'kernel_left', 't_refused_callee', 'summaries_kept')))}}
Nothing a corpus took is lost, and nothing more is taken: the holes were
in what the corpora do not have.

