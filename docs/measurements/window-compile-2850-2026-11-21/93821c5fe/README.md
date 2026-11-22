# Source-local static objects

Sixteen checked Buster tables supply 1,107,440 bytes and 63,290 symbolic addresses through the ordinary writer. This removes 773,157 of 1,407,416 nodes from the unit graph. All 33 standard comparisons match. The additional diagnostic matrix exposes 36 of 76 mismatches, including hidden implicit conversions, overridden subobjects and output from declined attempts. This revision is a diagnostic baseline.

[Full object hashes and warning policy comparisons](objects.tsv), [nineteen generated sources under four policies](diagnostics.tsv), [input generator and Clang comparison](edges.py), [raw outputs and inputs](raw.tar.gz) and [source above the frozen baseline](source.patch)

Ordinary local fresh-process compilation on the 7940HS saved a paired 105.446 ms and 205,436 KiB on Buster (5/5). SQLite had zero eligible tables and paired wall changed by +2.148 ms (2/5 faster). This timing is for the earlier sixteen-table diagnostic baseline. [Time and memory](local-paired.tsv)
