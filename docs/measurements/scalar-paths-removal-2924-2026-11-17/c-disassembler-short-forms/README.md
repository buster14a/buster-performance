# Fixed short instruction forms in the x86 disassembler

The candidate materializes complete fixed one- and two-byte instructions during initialization using the proposed lane decoder from buster14a/buster@07bfd1a5972461452d81582a5819ee06aeace958. A matching record can be copied directly. FWAIT requires a third byte to distinguish some x87 forms, so the table excludes it. The 65,536 decoded-record slots also add initialization work. [Base work in #3451](https://github.com/buster14a/buster/issues/3451#issuecomment-7222721667)

On the Ryzen 7 9700X, a single-instruction call takes 70.867 ns per instruction with the table. The original scalar route takes 31.693 ns. At four instructions the table takes nearly twice the original scalar time. The per-size replacement gate remains open.

| Instructions per call | Original scalar, ns/insn | Lane decoder, ns/insn | Lane decoder plus short forms, ns/insn |
| ---: | ---: | ---: | ---: |
| 1 | 31.693 | 100.230 | 70.867 |
| 2 | 21.584 | 49.539 | 45.770 |
| 4 | 13.527 | 26.487 | 26.149 |
| 8 | 9.261 | 13.912 | 14.494 |
| 16 | 8.671 | 7.912 | 7.977 |
| 64 | 7.759 | 7.995 | 7.740 |
| 256 | 7.562 | 7.531 | 7.732 |

Each entry is the median across three runs of the 21-pass synthetic compiler stream, pinned to core 2 under the shared lock. Initialization is excluded from decode timing. The initial benchmark headers report their original size metric, which omits the experimental fixed-record array. The raw logs include initialization time and hardware counters.

The differential fixture checks all byte strings of length zero through two and 200,000 generated strings of length three through 64. It checks capacities zero through three for each string, including returned count, consumed bytes, status, and the entire returned decoded records. The two serialized outputs have SHA-256 `b6c895df8d78b3132527d8ff8a5759f323c337e8e987213e9491c38d93b3f72f`. The unrevised FWAIT table produced a different output.

`runfixed` gives the exact shifts in run order, build command and shared-host baseline location. `mini.c` drives the published lane decoder and its benchmark. `short2.patch` is the candidate relative to the revision above. Run the driver inside the shared exclusive lock after placing these files in its working directory. [Measurements](results)
