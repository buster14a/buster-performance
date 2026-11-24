# SSA's cell cap lifted (buster #3449, piece 2, not yet merged)

`claude/2924-ssa-cap` (8a0b2b3b) over #3511's first head (9c49d771): `ssa_dense_fits` bounds the dense constructor's
bit rows, rows' buffer and linear columns instead of 128 bytes a cell, and `ssa_vector_phis` takes the bounded
construction where the counted phis' storage passes the dense budget. The 7 corpus functions the cap sent to the bounded
construction take the dense one.

Gate c1 (`scripts/chain-c1.sh`, the same method as `../rows-in-groups`, a control copy of the base in the hold): the 7
functions take 0.51 to 0.91 of the base's whole-promotion ticks, except Lua's 1,509 x 654 function, 1.009 with the
default passes and 0.841 with +all. Every other bin read about 1.01 against a control of 0.999, also on musl, which has
none of the 7; the construction alone read 0.99 there, and `perf stat` of the whole musl compile (`scripts/perf-c1.sh`,
five alternating runs) read equal instructions (9.0776-9.0781 G) and cycles (median 4.282 G both): code placement in the
promotion, not work. `logs/c1.txt` has the comparisons, the perf runs and the gate's status.

Not merged yet: the #1353 work contract's scoped-loops fixture now takes the dense construction and passes at 4.14 MB of
its 4.26 MB bound at 1,024 locals, but its bit rows grow as blocks times locals, so placement's bit rows go into groups
of locals first.
