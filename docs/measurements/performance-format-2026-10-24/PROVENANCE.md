# Sources, generators and validation provenance

## Original contributions and archive-derived values

The format design, thin Buster schema, fixture generator, queries and explanatory material are original agent-assisted work directed by David. Original contributions follow the existing project default, **Apache-2.0 WITH LLVM-exception**. Existing imported material retains the terms recorded by this repository's LICENSE, THIRD_PARTY_NOTICES.md and provenance/buster records; this update changes none of those terms.

The real example is a representation conversion of these existing project artifacts at exact performance commit **d3453eb2099d1e4dcd9c997720fcf6e0d86b81ea**:

- [foreign-string process/case CSV](https://github.com/buster14a/buster-performance/blob/d3453eb2099d1e4dcd9c997720fcf6e0d86b81ea/docs/measurements/foreign-strings-2026-10-23/raw/samples.csv)
- [foreign-string execution/resource CSV](https://github.com/buster14a/buster-performance/blob/d3453eb2099d1e4dcd9c997720fcf6e0d86b81ea/docs/measurements/foreign-strings-2026-10-23/raw/processes.csv)

The manifest resource inventory contains the original paths, exact bytes and hashes, including the original campaign-plan.json. CSV fields were mapped to exact integer/decimal/string values; 288 case rows and 12 process rows retain 7,308 source cells. Reported summaries were not expanded into fabricated individual observations. Buster source was inspected at a7741e836353642041aca0e3c653f38226153358 for the design; the publication PR has a later explicit base. Historical results remain scoped to their recorded executions.

## Native profile fixture

`profile-example/fixture.c` is an original, fixed-input C17 emitter for the published Perfetto protobuf wire schema, not copied upstream implementation, a production collector or a proposed custom format. Its literal synthetic inputs are the generator inputs. It produces eight stack samples, two threads, spans, counters, scheduling and a dispatch flow. The coverage-gap marker deliberately means unknown coverage; it is not an invented native lost-record count. See its README for the byte-reproduction and SQL commands. The arbitrary two-row Arrow/JSONL table also contains deliberately synthetic values, including uint64 maximum, a decimal and a null/reason.

Protocol fields and embedding behavior were checked against [Perfetto v58.2](https://github.com/google/perfetto/tree/v58.2), commit **add693d8b338ba9599dbcbc3e300b1ab8c000897**. Perfetto is Apache-2.0; its schema/API was used as a format reference. No Perfetto source, SDK, UI, native executable or WASM runtime is redistributed here. The official Trace Processor is an external validation tool, not incorporated code. Asset URLs/digests and tested status are in upstream-dependencies.json.

## Arrow and JSONL fixtures

Ordinary Arrow IPC files and zero-row schema streams were generated/read using **Apache Arrow JavaScript 21.1.0**, an external Apache-2.0 library. No library code is included. Exact decoded values, field order/types/nullability and JSONL equivalence were checked for all 7,320 typed cells. Integers above JavaScript's exact-number range use decimal strings in JSONL; decimal values retain scale. This is one Arrow-reader implementation, not independent C/browser interoperability qualification. The source CSV values and fixed synthetic values above are the generator inputs; the future production converter is tracked separately.

## Scope of receipts

The checks are local structural/representation and native-query validation, not 9700X performance measurements. They establish neither a production importer nor a hosted/deployed site. JSON Schema format annotations depend on validator configuration; recorded timestamps were parsed separately. There are no newly vendored third-party components or altered license grants.
