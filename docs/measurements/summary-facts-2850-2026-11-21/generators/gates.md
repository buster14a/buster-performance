- **F1, exact: met for what the piece makes, with two differences from the
  gate's letter.** On `sqlite3.c`, Lua, musl and the compiler's own source,
  in the cloud container, every kept expression's references and return fact
  are the program's own walks' ({{=four('kept')}} expressions,
  {{=four('program_references')}} references, {{=four('unknown')}} facts
  with an unknown and {{=four('stop')}} with a stop), every kept branch's
  condition's truth is its value's ({{=four('conditions')}} asked,
  {{=four('truths')}} known) and every kept root with an integer constant
  folds ({{=four('folds')}}); the same with `-Wall -Wextra`
  ({{=four('kept', n, True)}} expressions).{{=must(all(sum(v['cloud'][u + w]['differences']) == 0 and v['cloud'][u + w]['unkept'] == 0 and v['cloud'][u + w]['again'] == 0 and v['cloud'][u + w]['rows_differences'] == 0 for u in UNITS for w in ('', '-wall')))}}
  The {{=n(v['probes']['cases'])}} one-statement programs agree{{=must(v['probes']['agree'] == v['probes']['cases'])}}:
  {{=n(v['probes']['piece'])}} written for this piece (a reference of each
  kind in each place, a call of each form, a stop in each place an operator
  puts it, conditions an operand or a cast decides, the walks' other sources
  of a reference, a `constexpr` object, and statements at each lane of a
  block) and the {{=n(v['probes']['before'])}} of the pieces before. The
  differences: a selector's type is not made (above); and the control
  changes what reader time kept, not the program's answers. With it each
  kept expression's facts are kept with one changed (a reference more, a
  reference's object, its fact's stop and its unknown in turn), and the
  comparison must count every one by its turn; one of a chunk's first run's
  facts is changed, and every chunk's second run must differ; and the truths
  and the folds are asked of every root reader time typed, where they must
  count the fixture's lines the window lists for them.
- **F2, how much: met.** The turns' listing leaves out
  {{=four('left_out')}} expressions the piece before took (5 a corpus
  asked){{=must(all(0 <= v['cloud'][u]['left_out'] <= 5 for u in UNITS))}},
  and the cast's term lists {{='no expression' if all(v['cloud'][u]['passed'] == 0 for u in UNITS) else four('passed') + ' expressions'}} there.
- **F3, work a record: met for the tests' sweep; the rows' sweeps read
  {{=sval('sqlite3', 'rows_all_second')}} on `sqlite3.c` and
  {{=sval('lua', 'rows_all_second')}} on Lua where 0.30 was asked.** A
  chunk's second run of the rows' sweeps, the facts' among them, reads
  {{=srng('sqlite3', 'rows_all_second')}} ticks a record swept more with the
  facts on `sqlite3.c` and {{=srng('lua', 'rows_all_second')}} on Lua (0.30
  asked, 0.60 refutes){{=must(0.30 < med('sqlite3', 'rows_all_second') < 0.60 and 0.30 < med('lua', 'rows_all_second') < 0.60)}},
  and {{=sval('sqlite3', 'rows_all_second', 2, 'repeat')}} and
  {{=sval('lua', 'rows_all_second', 2, 'repeat')}} in the repeat{{=must(0.30 < med('sqlite3', 'rows_all_second', 'repeat') < 0.60 and 0.30 < med('lua', 'rows_all_second', 'repeat') < 0.60)}};
  the sweep itself is {{=val('sqlite3', 'sweep_second')}} and
  {{=val('lua', 'sweep_second')}} of it. The tests' sweep that makes the
  records' bytes reads {{=srng('sqlite3', 'bytes')}} and
  {{=srng('lua', 'bytes')}} more (0.20 asked){{=must(med('sqlite3', 'bytes') <= 0.20 and med('lua', 'bytes') <= 0.20)}},
  {{=sval('sqlite3', 'bytes', 2, 'repeat')}} and
  {{=sval('lua', 'bytes', 2, 'repeat')}} in the repeat{{=must(med('sqlite3', 'bytes', 'repeat') <= 0.20 and med('lua', 'bytes', 'repeat') <= 0.20)}}.
  The tests' sweeps have one run a chunk: theirs is a first run's reading,
  and the gate's "second run" is the rows' alone. On musl, which the gate
  did not name, {{=srng('musl', 'rows_all_second')}} and
  {{=srng('musl', 'bytes')}}.
- **F4, a chunk: refuted on musl for the rows' sweeps, not met on Lua, met
  on `sqlite3.c`; and the tests' sweep reads by the build.** The rows'
  sweeps' first run less their second rose by
  {{=srng('sqlite3', 'rows_all_cold', 0)}} ticks a chunk on `sqlite3.c`,
  {{=srng('lua', 'rows_all_cold', 0)}} on Lua and
  {{=srng('musl', 'rows_all_cold', 0)}} on musl (100 asked, 200 refutes){{=must(med('sqlite3', 'rows_all_cold') <= 100 and 100 < med('lua', 'rows_all_cold') < 200 and med('musl', 'rows_all_cold') > 200)}},
  and by {{=threes('rows_all_cold', 0, 'repeat')}} in the repeat{{=must(med('sqlite3', 'rows_all_cold', 'repeat') <= 100 and 100 < med('lua', 'rows_all_cold', 'repeat') < 200 and med('musl', 'rows_all_cold', 'repeat') > 200)}}:
  musl's is past what refutes in both sets. The sweep is a function of its
  own and pays a chunk's cold start of its own, {{=threev('sweep_cold', 0)}}
  ticks a chunk ({{=threev('sweep_cold', 0, 'repeat')}} in the repeat), and
  musl's chunks are {{='%.0f' % v['final']['musl']['a_chunk']}} records. The
  two frozen builds before read {{=threes('rows_all_cold', 0, 'xs4')}} and
  {{=threes('rows_all_cold', 0, 'xs5')}}: over the gate on Lua and musl in
  each. **The tests' sweep reads by the build.** Its bytes and loop read
  {{=srng('sqlite3', 'tests_two_chunk', 0)}} ticks a chunk more with the
  facts on `sqlite3.c` here and {{=srng('sqlite3', 'tests_two_chunk', 0, 'repeat')}}
  in the repeat (50 asked, 100 refutes); the two frozen builds before read
  {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs4')}} and
  {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs4b')}}, then
  {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs5')}} and
  {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs5b')}}, in two sets
  each{{=must(med('sqlite3', 'tests_two_chunk', 'xs4') <= 50 and med('sqlite3', 'tests_two_chunk', 'xs4b') <= 50 and med('sqlite3', 'tests_two_chunk', 'xs5') > 100 and med('sqlite3', 'tests_two_chunk', 'xs5b') > 100 and 50 < med('sqlite3', 'tests_two_chunk') < 100 and 50 < med('sqlite3', 'tests_two_chunk', 'repeat') < 100)}}.
  The first and the second of the three builds differ by one mask's
  operation in the bytes' sweep, and the second and this one by nothing in
  either sweep. With
  the facts and without them each of the tests' sweeps is another copy of
  its code (`node_tests_window_bytes_by`'s and `node_tests_window_loop_by`'s
  forms), so the switch reads one copy's place in the executable against
  the other's, which is the build's: by the gate's letter it is met in one
  build, over in one and refuted in one. What the facts add to the two is a
  narrowing and a store a step of sixteen records, and a load, an AND, a
  permute, two tests and a quadword's store a step of sixty-four. On Lua
  {{=srng('lua', 'tests_two_chunk', 0)}} and
  {{=sval('lua', 'tests_two_chunk', 0, 'repeat')}}, on musl
  {{=srng('musl', 'tests_two_chunk', 0)}} and
  {{=sval('musl', 'tests_two_chunk', 0, 'repeat')}}.
- **F5, nothing else moves: met for the kernel and C's sweeps; the tests'
  other parts are within it on `sqlite3.c` and not told apart on Lua and
  musl.** By the switch, the kernel in place reads {{=threesr('kernel')}}
  more and C's sweeps' second run {{=threesr('c_second')}} (0.2 asked){{=must(all(abs(med(c, k, b)) <= 0.2 for c in CORPORA for k in ('kernel', 'c_second') for b in (None, 'repeat')))}}.
  The tests' other parts read {{=threesr('tests_rest')}}, and
  {{=threes('tests_rest', 2, 'repeat')}} in the repeat{{=must(abs(med('sqlite3', 'tests_rest')) <= 0.2 and abs(med('sqlite3', 'tests_rest', 'repeat')) <= 0.2)}}:
  one run a chunk, with ranges ten times the gate on the two corpora of
  small chunks. Five earlier builds' medians of the same parts on musl are
  {{=join([sval('musl', 'tests_rest', 2, b) for b in ('xs1', 'xs2', 'xs3', 'xs4', 'xs5')])}}.
