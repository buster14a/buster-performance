The objects, one a reference, were a loop of a load and a store, a third of
the sweep; a gather of eight is the code, the same on `sqlite3.c`
({{=xsrng('sqlite3', 'eight_more_second', 2, 'experiment2')}} ticks a record
swept against the loop, one executable) and less on Lua and musl
({{=xsrng('lua', 'eight_more_second', 2, 'experiment2')}} and
{{=xsrng('musl', 'eight_more_second', 2, 'experiment2')}}), whose chunks'
few references ended the loop on a mispredicted branch. A record at a time
stay a call that is no plain function's (one record in
{{=join([one_in(c) for c in CORPORA])}} of those swept) and the flow's
reduction, for an expression with a call that stops under an `&&`, an `||`
or a `?:` ({{='none' if all(v['final'][c]['reduced'] == 0 for c in CORPORA) else three('reduced')}}
in the three corpora, {{=cloud('main', 'reduced')}} in the compiler's own
source).
