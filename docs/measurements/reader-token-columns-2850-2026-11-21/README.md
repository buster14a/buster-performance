# Token-indexed storage in the ordinary checker reader

The ordinary checker writes two 32-bit arrays for every translation unit. One stores the result type at a return keyword. The other remembers the start of the declaration specifiers for a function body. Frozen SQLite has 716,136 tokens, so each array with its sentinel takes 2,864,548 bytes. Each alternative below was compiled separately from [0efe6db19](https://github.com/buster14a/buster/commit/0efe6db191c5314674011b2369c0ce98f405bd84).

| Prototype | Base pages, change in cycles/token [range] | Huge pages allowed, change in cycles/token [range] |
| --- | ---: | ---: |
| [Move the return-type array to its own sparse mapping](separate-mapping/) | −7.323 | −0.684 [−6.385, +4.681] |
| [Use the expression query slot at a return keyword](return-query/) | −13.655 [−18.448, −7.291] | −7.063 [−33.910, −2.346] |
| [Allocate body specifiers only for a unit using `__PRETTY_FUNCTION__`](pretty-name/) | −8.249 [−17.479, −5.352] | −4.317 [−13.235, −0.001] |

The separate mapping saved 515 minor faults with base pages and added 496 when huge pages were allowed. Reusing the query slot removed the return array and its deferred-body type remap. It saved about 86,000 user instructions on either page policy. The pretty-name gate reuses the token census's existing identifier match. It added about 10,000 user instructions, and its base-page measurements saved 1,011 minor faults. Each comparison has an independent parent sample. These results cannot be added to predict a combined build.

The host was a locked Ryzen 7 9700X, pinned to CPU 2. Each experiment ran seven alternating ABBA/BAAB rounds under each page policy using a fresh ordinary SQLite object compile for each reading. The paired differences use total user and kernel core cycles divided by 716,136 tokens. All 168 object digests matched. Each directory contains the patch, original perf records, paired results and hardware runner. [Binaries and host](environment.txt) · [Reduction and build scripts](scripts/).

The return-query prototype passed all eight checker partitions (844,079 checks), plus 243 ordinary/changed policy comparisons covering GNU statement expressions, value returns, scope, VLA type queries, missing values and malformed sources. Of these, 194 emitted objects. The pretty-name prototype passed 514,636 checker assertions and all 210 object and diagnostics comparisons across spelling, macro expansion, debug information, deferred bodies, the scalar reader and poisoned arenas. The combined integration and its independent wall-time measurements use a later compiler revision.
