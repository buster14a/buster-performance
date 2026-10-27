# General- and local-dynamic TLS relaxed in a dynamic PIE: the 9700X cost for #515

2026-10-27. This record measures the writer's cost for
[buster14a/buster#515](https://github.com/buster14a/buster/issues/515). A dynamic
PIE relaxes general- and local-dynamic TLS accesses. An access to one of its own
thread-locals becomes local-exec, and an access to an imported one becomes
initial-exec through a `TPOFF64` GOT slot
([buster14a/buster#521](https://github.com/buster14a/buster/pull/521)). The
measurement comes from `benchmark-executable`'s TLS modes
([buster14a/buster#553](https://github.com/buster14a/buster/pull/553)), run by
the 9700X job of that pull request.

## Revisions

The job builds the merge of the pull request's head into its base,
`claude/dazzling-einstein-di6enh` at
`01c1343dd58fba34cfc3750cb7ffa7890b3b3a9e` (#511's branch, which holds #521).
There were three heads, in order:

| Head | Built as | Job | What its benchmark has |
| --- | --- | --- | --- |
| `dce336514df2316d0fe582db9947c4862be205e8` | `7e0c3ddea70a371bda5a0ea414ab36d133f4e42f` | [122130660142](https://github.com/buster14a/buster/actions/runs/40486829450/job/122130660142) | general, local, imported; no control |
| `04bf9758388b6af5a5e2b98808b355290f1e9cd6` | `7fbed5e6976d3e3e43a8ed353cc457bb4582e3bd` | [122142420281](https://github.com/buster14a/buster/actions/runs/40490308790/job/122142420281) | the control added |
| `c1a615c9133219ebc2b97a8a128242f3f7147771` | `a581181b9edacb7d7d20e389c7c4640645ab548f` | [122147939229](https://github.com/buster14a/buster/actions/runs/40491972955/job/122147939229) | each probe checked against its own target (#553's review) |

The writer (`executable.c`) is the same in all three merges. Only
`executable_benchmark.c` and `AGENTS.md` changed between them.

## Host and builds

The runner is `buster-zen5-9700x` on `benchpress`, an AMD Ryzen 7 9700X. The
build used clang 23.1.1 and wild as the build's linker:
`BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh`. The runner's hooks held the
shared host lock for the whole job. The log doesn't give the kernel's version or
`build/compiler`'s sha256. `logs/*-setup.log` holds each job's lines from its
start through the build.

## Commands

The job's step "Benchmark the direct path's executables" ran:

```sh
cpu="$(awk '/^Cpus_allowed_list:/ { split($2, cpus, /[,-]/); print cpus[1] }' /proc/self/status)"
taskset -c "$cpu" ./build/compiler benchmark-executable
```

Each job ran this once. `logs/*-benchmark-executable.log` holds each job's step
in full.

The dynamic section links programs that call libc, with 1, 64, 2,000 and
180,000 workers, as dynamic PIEs on one lane. Each figure is the median of the
timed writes after a first, untimed one, both in place over the previous
write's file and as a new file. There are 41 timed writes for an output of up
to 4 MB (`BUSTER_EXECUTABLE_BENCHMARK_LINK_RUNS`, the 1-, 64- and 2,000-worker
rows), and 11 past it (`BUSTER_EXECUTABLE_BENCHMARK_LARGE_RUNS`, the
180,000-worker rows' files of 44 to 50 MB). Besides the plain program, each
worker gets one probe in one of these modes:

- **control**: the general-dynamic probe's bytes, atoms and fixups without TLS.
  It has a `PC32` to a data object where the access has `TLSGD`, and a direct
  call where the access calls `__tls_get_addr`. It is link-only code: it is
  never run.
- **general**: a general-dynamic access to a thread-local of the program's own,
  which the writer relaxes to local-exec.
- **local**: a local-dynamic access (`TLSLD` and the call) plus a `DTPOFF32`,
  relaxed to local-exec. This adds 3 bytes of code and one fixup per probe over
  the control.
- **imported**: a general-dynamic access to `libc.so.6`'s `errno`, relaxed to
  initial-exec through its `TPOFF64` GOT slot.

Each write of the TLS modes starts from binding's bytes, which are copied back
before the write and outside its timing, since a relaxation can't be repeated
over its own output. The same copy runs for the control, so the two are timed
alike. After the timed writes, the benchmark checks every probe in the file.
For general and local, it checks the relaxed bytes and that the offset equals
the symbol's offset from the thread pointer. For imported, it checks the
initial-exec bytes and that every probe reaches the GOT slot the file's
`R_X86_64_TPOFF64` against `errno` fills. For the control, it checks that the
bytes are unchanged. Every row of `04bf975` and `c1a615c` printed "every probe
checked against its target".

## Results

All times are in µs, written in place on one lane.

| Workers | Plain | Control | General | Local | Imported |
| ---: | ---: | ---: | ---: | ---: | ---: |
| `dce3365` 2,000 | 79.8 | — | 179.1 | 189.3 | 182.4 |
| `dce3365` 180,000 | 9,958.8 | — | 19,524.7 | 20,432.2 | 19,832.4 |
| `04bf975` 2,000 | 79.5 | 146.3 | 183.8 | 192.4 | 187.1 |
| `04bf975` 180,000 | 9,865.5 | 16,008.5 | 19,357.0 | 20,262.3 | 19,727.2 |
| `c1a615c` 2,000 | 81.0 | 143.4 | 183.0 | 191.7 | 187.5 |
| `c1a615c` 180,000 | 9,835.8 | 16,159.0 | 19,544.6 | 20,342.3 | 19,862.7 |

At 1 worker every mode takes 5.8 to 6.0 µs; at 64, 11.5 (control) to 13.2.

### What each mode's program is

These are `c1a615c`'s counts for each program, from the rows' headers. The other
heads' programs are the same.

| Program | Atoms | Fixups | Code bytes | Dynamic symbols | `.rela.dyn` | File bytes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain, 180,000 | 185,457 | 2,342,793 | 31,650,098 | 10 | 11 | 44,712,744 |
| control, 180,000 | 365,521 | 2,702,793 | 36,690,098 | 11 | 11 | 50,473,368 |
| general, 180,000 | 365,521 | 2,702,793 | 36,690,098 | 11 | 11 | 50,473,368 |
| local, 180,000 | 365,521 | 2,882,793 | 37,230,098 | 11 | 11 | 50,473,368 |
| imported, 180,000 | 365,521 | 2,702,793 | 36,690,098 | 12 | 12 | 50,473,464 |
| control, 2,000 | 4,181 | 30,108 | 408,079 | 11 | 11 | 579,488 |
| general, 2,000 | 4,181 | 30,108 | 408,079 | 11 | 11 | 579,488 |
| local, 2,000 | 4,181 | 32,108 | 414,079 | 11 | 11 | 579,488 |
| imported, 2,000 | 4,181 | 30,108 | 408,079 | 12 | 12 | 579,600 |
| control, 1 | 100 | 122 | 819 | 11 | 11 | 19,584 |
| general, 1 | 100 | 122 | 819 | 11 | 11 | 19,592 |

General and control are the same program but for each probe's two fixups'
kinds: a `PC32` into `.data` and a call to a function, against a `TLSGD` into
`.tdata` and a call to `__tls_get_addr`. Their data and TLS sections differ, so
the one-worker files differ by 8 bytes. Local adds a `DTPOFF32` fixup and 3
bytes of code per probe. Imported adds `errno`'s dynamic symbol and its
`TPOFF64` relocation, and its probes target one symbol rather than one each.

### Per access

Each access's cost is the mode's time minus the control's, divided by the
number of probes. All figures are in ns. These are whole-writer deltas between
the programs above, not the latency of the relaxation's code alone: each one
includes whatever else the two programs' differences cost the writer, and the
local and imported rows include their extra fixup or relocation.

| Head | Mode | 2,000 in place | 180,000 in place | 180,000 new file |
| --- | --- | ---: | ---: | ---: |
| `04bf975` | general | 18.8 | 18.6 | 18.7 |
| `04bf975` | local | 23.0 | 23.6 | 23.9 |
| `04bf975` | imported | 20.4 | 20.7 | 20.3 |
| `c1a615c` | general | 19.8 | 18.8 | 18.9 |
| `c1a615c` | local | 24.1 | 23.2 | 23.4 |
| `c1a615c` | imported | 22.0 | 20.6 | 21.1 |

So a general-dynamic access to the program's own thread-local adds about
19 ns to the write, and one to an import about 21 ns. A local-dynamic access
adds about 23 ns, part of which is its probe's extra `DTPOFF32` fixup.

These are the phases at 180,000 workers on `c1a615c`, as each mode's excess over
the control in ns per access:

| Mode | count | layout | symbols | dynamic | chunks |
| --- | ---: | ---: | ---: | ---: | ---: |
| general | 3.2 | 0.0 | 3.2 | 0.0 | 12.4 |
| local | 3.7 | −0.1 | 3.3 | 0.0 | 16.3 |
| imported | 4.9 | 0.0 | 3.1 | 0.0 | 12.5 |

- The count phase, which finds the accesses, and the symbols' pass, which
  resolves their targets and the import's GOT slot, each grow by about 3 ns.
- The chunks, where the sequences are rewritten, grow by about 12 ns per
  access, or 16 ns with the local-dynamic probe's extra field.

The control itself costs about 34 ns per probe over the plain program, from the
probe's atoms and fixups alone: (16,159.0 − 9,835.8) / 180,000 on `c1a615c`.
Without the control, `dce3365`'s TLS rows would have charged that growth to the
relaxation.

## Limitations

- These are CI job logs: one job per head and one process per job. The heads
  agree to within about 1 ns per access at 180,000 workers. The 2,000-worker
  figures differ by up to 1.6 ns, since a 1 ns difference there is only 2 µs of
  the write.
- The log gives neither the kernel's version nor the executable's sha256. The
  merge commits identify the sources.
- The copy of binding's bytes before each write is outside the timing, but it
  leaves the program's bytes in the caches. The control pays the same copy, so
  the subtraction removes most of that effect, though not the extra bytes the
  local-dynamic probe copies.
- The probes are synthetic, one per worker, with no other TLS in the program.
  They measure the writer's throughput on the relaxation, not how often real
  code has such accesses.
- The figures are for one lane only. The relaxation's passes run on every lane
  of a group, but this record doesn't measure the multi-lane writes.
