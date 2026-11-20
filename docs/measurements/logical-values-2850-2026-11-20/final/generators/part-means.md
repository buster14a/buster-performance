- **The operators' values and the commas are exact on the window,** and X's
  tapes are whole for 49,842, 10,248 and 40,444 expressions of the three corpora's
  50,993, 10,839 and 43,415.
- **Their work a record is small on `sqlite3.c` and Lua:** a chunk's second
  run reads +0.36 and -0.35 ticks a record of the decided more than the piece
  before's in C, and -0.04 and -0.29 a record of the taken in the rows. On musl C's
  reads +1.53.
- **Their cost is by the chunk, and it is C's loop's.** The loop's step has
  the new masks in every block, and its first run over a chunk reads
  +1.02, +1.94 and +3.49 ticks a record swept more where its second reads
  +0.44, +0.53 and +1.24. Over all the records swept, a first run of the two
  sweeps adds 86%, 61% and 154% of what the reference's C and X read on the
  newly taken records, and a second run 35%, 23% and 62%. **On musl, whose
  chunks are 127 records, a first run costs more than the reference's work
  it replaces.** What a chunk's first run pays is the window's cold start
  ([#3196](https://github.com/buster14a/buster/issues/3196)), which grew
  here with the masks the loop's step took on; the specification gated it
  for the rows' sweeps and not for C's.
