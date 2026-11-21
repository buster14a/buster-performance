- **H1 and O1, exact: met.** No program of the tables or of `tests/` has
  status 1 under any of the three sets{{=must(all(v['after']['sweep'][p][s]['found'] == 0 for p in ('tests', 'inline') for s in SETS))}}
  ({{=n(v['before']['programs'])}} under each on the code before). The four
  corpora with no option and with `-Wall -Wextra`, 8 runs: no difference
  and no unsound take. The generator's {{=n(v['fuzz']['programs'])}}
  programs, six runs: {{=count(v['fuzz']['found'])}} with status 1{{=must(v['fuzz']['found'] == 0)}}
  ({{=n(v['fuzz_before']['found'])}} on the code before). The
  {{=n(v['probes']['lines'])}} one-statement programs agree{{=must(v['probes']['disagree'] == 0)}}:
  the {{=n(v['probes']['lines'] - v['probes_new']['lines'])}} of the pieces
  before and {{=n(v['probes_new']['lines'])}} units written for the
  objects' side, {{=n(v['probes_before']['disagree'])}} of which did not
  agree on the code before.
- **H6, a trigger a warning: met.** Of the {{=n(v['triggers']['tested'])}}
  warnings the tests stand for, {{=n(v['triggers']['written'])}} have a
  program written to warn and {{=n(v['triggers']['from_piles'])}} one found
  in the tables; each warns{{=must(v['triggers']['warn'] == v['triggers']['written'])}},
  and none of its three runs (its own options, with `-Wall -Wextra`, and
  with `-Weverything -Wno-c++-compat`) differs or takes an expression
  with a warning{{=must(v['triggers']['differ'] == 0)}}. On the code before
  {{=n(v['triggers_before']['differ'])}} warnings' runs did: the ordered
  comparison's and `-Wexcessive-regsave`'s. `-Wavailability` has no
  trigger.
- **H3 and O2, how much: met.** The four corpora take what they took, to
  the expression, with no option and with `-Wall -Wextra`: T, the tests, C,
  the rows' tapes and their entries, the kernel's records and the
  summaries (the table above). No corpus has a rename pragma, and T's
  refusals for a callee are the code before's ({{=four('t_refused_callee')}}):
  no unit of theirs loses a call to the overloads' answer.
{{file:gates_cost}}
{{file:gates_faults}}
- **O5, the fixtures: met.** Each kind has a line in a fixture, in a unit
  of its own where its answer is a unit's. Of the
  {{=n(len(v['fixtures']))}} new fixtures
  {{=n(sum(1 for f in v['fixtures'].values() if f['before']['status'] != 0))}}
  have status 1 on the code before{{=must(all(f['after']['status'] == 0 and f['after']['bad'] == 0 for f in v['fixtures'].values()))}}
  ({{=n(v['fixtures']['node_census_test_holes']['before']['bad'])}} of the
  holes' {{=n(v['fixtures']['node_census_test_holes']['before']['annotated'])}}
  annotated lines do not hold there,
  {{=n(v['fixtures']['node_census_test_segments']['before']['bad'])}} of the
  segments' {{=n(v['fixtures']['node_census_test_segments']['before']['annotated'])}});
  the {{=n(sum(1 for f in v['fixtures'].values() if f['before']['status'] == 0))}}
  others hold on both and pin what must stay as it was{{=must(sorted(k for k, f in v['fixtures'].items() if f['before']['status'] == 0) == ['node_census_test_silent', 'node_objects_test_overloads', 'node_objects_test_pragmas'])}}:
  nothing refused with every warning off, a labelled builtin's call taken
  beside a weak pragma, and an overloadable function's unit.
