The objects were a loop, and are a gather. Until this build the code wrote
each reference's object by a load and a store, one a step
({{=three('listed_references')}} records listed, one in
{{=join([one_in(c, 'listed_references') for c in CORPORA])}} of those
swept). An experiment build (the build before's code with a switch read
from the environment, not for a commit; {{=v['experiment2']['sqlite3']['runs']}}
readings, each setting in turn in one executable) read its two vector's
forms against it:

{{file:experiment}}

A gather of eight is the code: it reads the same on `sqlite3.c` and less
where a chunk has few references, which end the loop on a branch their
count mispredicts. A gather of sixteen doublewords reads more on
`sqlite3.c`. An earlier experiment read the sweep with no objects written
at all {{=xsrng('sqlite3', 'no_objects_more_second')}} ticks a record swept
on `sqlite3.c` and {{=xsrng('lua', 'no_objects_more_second')}} on Lua: the
loop was a third of the sweep.

What stays a record at a time:

- **A call asked** (`node_rows_summary_call`, a byte of its callee's and,
  in a unit with a function unknown from a declaration on, a table's
  entry): {{=three('suspects')}} calls, one record in
  {{=join([one_in(c) for c in CORPORA])}} of those swept. With none asked
  that experiment reads {{=xsrng('sqlite3', 'no_calls_more_second')}} and
  {{=xsrng('lua', 'no_calls_more_second')}}. A call that says a fact (an
  unknown in {{=three('unknown')}} expressions, a stop in
  {{=three('stop')}}) then scans to its expression's end mark, some records
  on.
- **The reduction** (`node_rows_summary_reduce`), up one expression's
  postorder: {{='no expression' if all(v['final'][c]['reduced'] == 0 for c in CORPORA) else three('reduced') + ' expressions'}}
  of the three corpora
  and {{=cloud('main', 'reduced')}} of the compiler's own source, those with
  a call that stops under an `&&`, an `||` or a `?:`. It is the flow's own
  rule in its own order, for expressions no reading here has enough of to
  time.
