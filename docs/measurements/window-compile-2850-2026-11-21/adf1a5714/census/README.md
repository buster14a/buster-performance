# Exact lexer work counts during SQLite preprocessing

A private counter build on the final adf1a5714 source ran the regular preprocessor on raw SQLite and its normal include tree. The file preparation and macro stream contained 716,136 output tokens. The complete 21,642,567-byte transcript retains SHA-256 `d1a4fe4549ca00312389b9153a8c1adaa09b4dd11e38dc167266ff8b8ea4345a`, the same as the pristine and final uninstrumented transcripts.

Across 19,787 writer calls, the original eight lanes per chunk would enter the writer loop 158,296 times. The final bounds execute 116,260 lane iterations. They remove 42,036 actual lane iterations, or 26.555%. Of the chunks, 2,429 own no token endpoint. The classifier reached the carried-region calculation in 19,821 chunks. Exactly 8,401 carried a block comment and 123 carried an opening-delimiter boundary skip.

The counters only exist in this diagnostic source. Times from the counter build are excluded from the performance comparisons.
