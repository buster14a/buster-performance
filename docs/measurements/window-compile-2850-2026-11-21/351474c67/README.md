# Native object publication from source-local C graphs

Combining local static objects with switch tables and labels supplies 380,408 of 381,191 typed entries and 11,144 symbol references from 2,664 emitted SQLite functions.

The frozen inputs are SQLite 3.53.2 and the Buster compiler amalgamation. Each ordinary object was checked byte for byte. The coverage runs use one lane and a diagnostic build with the checker unit at -O0. The opt-in path uses BUSTER_CONTROL_SOURCE_NATIVE=1. [Per-unit coverage and complete ELF hashes](native-units.tsv), [raw output and commands](raw.tar.gz) and [complete experimental source above the frozen base](source.patch)
