# Direct x87 loads of positive zero and one

[PR #3140](https://github.com/buster14a/buster/pull/3140) compares [a695f9d2c5](https://github.com/buster14a/buster/commit/a695f9d2c5240fd49619809347c80d784e8ffbc4) with [dbea6227a8](https://github.com/buster14a/buster/commit/dbea6227a8a1fca5f5c1f399089e5d26b3ccaea6).

Tier 1 now emits the two-byte x87 instructions `FLDZ` and `FLD1` for positive zero and positive one at their original consumers. Both patterns use the existing canonical narrowing check. Negative zero, negative one and the remaining constants retain their respective memory encodings.

In the 1,336-object musl census, 12 objects changed. In total they lost 176 bytes of text, 240 bytes of read-only data, 41 code relocations and 2,360 bytes of object-file storage. A linked executable exercising twelve real musl routines lost 128 bytes of text, 32 bytes of read-only data and one 4,096-byte file alignment boundary.

The two instructions produced the same x87 stack contents, tag word, status and control bits as explicit memory loads through all nine stack depths, three precision settings, four rounding modes and clean or sticky exception states. The test checks the preceding volatile store on both an already-pending invalid exception and an unmasked full-stack push. Eight parent/candidate configurations each passed 864 stack comparisons and 16 observed signal deliveries. The 498-constant fixture passed 346,608 comparisons per candidate configuration. Eight relocation inspections, 48 final links, 160 raw-IR runs and twelve existing exception-order tests passed. Static musl formatting and parsing reproduced all 30,720 and 36,864 outputs per compiler, including observable floating-point state. The twelve-function musl math comparison also matched the parent.

On the local Ryzen 9 7940HS, the zero-clamp loop took 0.29–0.67% fewer cycles across four placements. The reciprocal-one loop took 0.66–0.87% more, and the choice loop took 0.04–0.15% more. Application timing was mixed. The demonstrated benefit is smaller code, data and relocation tables. Direct 9700X measurements, including the missing `FLD1/REGISTER` scheduler cost, are pending.

Part of #1387. Stacked on #3138.

The [stack and exception harness](stack/), [ELF link ledger](elf/linked.tsv), [entire frozen musl footprint](footprint/), and [actual static libc parsing and formatting runs](musl-static/) cover the architectural and application results. The [local libm counters](libm/timed/paired.tsv) label #3138 as `narrow` and #3140 as `pool` in the inherited three-way harness. The full C driver completed 196,448 checks with zero failures.
