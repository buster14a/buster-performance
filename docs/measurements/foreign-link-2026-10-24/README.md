# Foreign executables (`link-foreign`), 2026-10-24

The 9700X's validation and measurements of `link-foreign`, the command that
links GCC's and clang's objects (#86), for Buster pull request
[#380](https://github.com/buster14a/buster/pull/380). The linker design's
"Foreign executables, as built", the driver's "Cost" and the interpreter note
cite this record. It measures dynamic PIEs on one lane and on eight; the
foreign conversion on lanes (#87) and the streaming of the output (#88) are
not in it.

## Source and host

- Source commit: `b3c7bf10c482ecb8d4b91b548fbcca5d90d70f64`, the head of
  #380 when measured.
- [Source manifest](source.sha256): the SHA-256 of each file of
  `git archive b3c7bf1`, SHA-256
  `09db97b0790f318f9ba2b83ce3987bda54754fe523415423c94f0763d2f12599`. The
  measured tree (`~/buster-fast-bench/claude-linker-80/tree2`) matched it file
  for file; it also held a stale `.gitattributes` and old `docs/measurements`
  files, which the build doesn't read.
- `build/compiler` SHA-256:
  `578bdc4e54e09b0e79daf8e612b827f7a6e48787c990a4eeb078a6a82d55a393`.
- Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1,
  GNU ld 2.47, lld 23.1.1, mold 3.0.0, wild 0.10.0. `/tmp` is tmpfs and
  `/home` btrfs.
- Each step took the shared lock on its own, through
  `~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-linker-80`
  and `EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/86`, CI
  first. The lock's waiting messages, which name other runs, are removed from
  the logs; nothing else in them is changed.

The scripts are [phase2.sh](phase2.sh) (the build, the tests, the corpus,
`benchmark-link`, the profile and the interpreter's lookup),
[phase3.sh](phase3.sh) (the appendix's inputs with the output on btrfs) and
[phase3c.sh](phase3c.sh) (the same with the output on tmpfs).

## Validation

- [build.log](build.log) and [callgraph.log](callgraph.log): the build, and
  the call graph check (42 units, 0 cycles past the 3 allowed).
- [tests.log](tests.log): the job's 68 test commands ([tests.txt](tests.txt),
  taken from the workflow), all passed in 60.0 s, among them
  `test-foreign --cross-check` and `test-foreign-corpus` (68 checks).
- [corpus.log](corpus.log): `test-foreign-corpus` with SQLite 3.53.4's
  amalgamation (its shell), Lua 5.4.8 and the compiler itself: 165 checks and
  0 failures, each program linked by `link-foreign`, lld and mold from one
  command line, with the reference linkers' documented differences counted.

## Measurements

[link.log](link.log) is `benchmark-link --kinds dynamic --keep`: the design's
generated programs that call libc (1 worker in 4 units, 2,000 workers in 10,
and synth's shape, 102,400 workers in 512 units of 96 MB of objects), linked
as dynamic PIEs by the direct path, and from the object writer's objects by
GNU ld, lld, mold, wild and `link-foreign`, each a process from one command
line, the output on tmpfs. One thread is lld's `--threads=1`, mold's and
wild's `--no-threads` and `link-foreign`'s `--lanes=1`, pinned to CPU 2;
their own threads are the 15 CPUs, or `--lanes=8`. Medians (ms):

| Program | `link-foreign`, 1 lane / 8 | wild, 1 thread / its threads | mold, 1 / its | lld, 1 / its | GNU ld | Direct path |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 worker | 0.60 / 1.71 | 1.35 / 2.54 | 2.44 / 5.46 | 4.45 / 5.73 | 5.46 | 0.017 |
| 2,000 workers | 1.12 / 2.53 | 2.56 / 2.88 | 3.31 / 6.54 | 5.48 / 6.60 | 9.08 | 0.091 |
| 102,400 workers | 55.2 / 41.2 | 99.9 / 24.8 | 99.9 / 37.3 | 98.7 / 56.8 | 355 | 7.32 |

On synth's shape, `link-foreign` wrote 49,250,384 bytes, lld 49,242,936, mold
53,737,480 and wild 49,255,659: per lane, 0.89 GB/s of output against mold's
0.54, wild's 0.49 and lld's 0.50 on one thread. On the small programs its
outputs are larger (23,288 bytes for 1 worker, against lld's 11,616).

[perf.log](perf.log) links synth's shape from `benchmark-link`'s kept objects
([foreign-command.txt](foreign-command.txt) has the command) seven times with
`--time` on one lane (CPU 2) and seven on eight (CPUs 0 to 7), runs the
output, records one link with `perf record -F 20000 -g` and counts three with
`perf stat`. [perf-report.txt](perf-report.txt) and
[perf-children.txt](perf-children.txt) are the profile without and with
children. The medians of `--time` on one lane: the resolution 21.2 ms (the
symbols' parse 6.6, the resolution 7.2, the winners 2.5, the exchange 2.2, the
opening 1.4), the conversion 20.3, the write 9.8 (its chunks 7.2), the release
2.9, 54.4 ms in all; on eight lanes, the resolution 10.1, the conversion 20.4,
the write 6.5, 40.1 ms in all. `perf stat`: 655 million instructions and 2,310
page faults per link.

[interp.log](interp.log) links a hello world (gcc's `-O2` object) 41 times in
alternating pairs, with the interpreter looked up and given
(`-dynamic-linker /lib64/ld-linux-x86-64.so.2`), each process timed in
nanoseconds by `date +%s%N` around `taskset -c 2`: medians 937 µs looked up
and 943 µs given. Both outputs run; they differ by their `PT_INTERP` paths
(`/usr/lib/ld-linux-x86-64.so.2`, which glibc's `libc.so` names, against the
given one). Three `--time` runs put the lookup at 10 to 11 µs and the link at
0.22 to 0.26 ms.

[appendix.log](appendix.log) and [appendix-tmpfs.log](appendix-tmpfs.log) link the design appendix's own
inputs: clang's `hello.o`, tcc's `tcc.o` and `libtcc.a` with `-lm -ldl
-lpthread`, and synth's 513 objects, with the appendix's matched options
(`-z now --no-gc-sections`) and the C runtime as GCC's driver gives it, timed
by the appendix's `timeit` (`timeit RUNS PAUSE_MS COMMAND`: one warm-up, then
RUNS runs with PAUSE_MS between them, each from `fork` to `waitpid`, its output
to `/dev/null`; minimum, median and maximum in µs). The first wrote its
outputs on btrfs (`~/buster-fast-bench/claude-linker-80/appendix-out`); its
synth case never ran, as its script's one argument passed the kernel's 128 KB
limit. The second wrote them on tmpfs (`/tmp/claude-linker-80-appendix`), as
the appendix measured, ran each output and compared what it printed with lld's
output's (all alike). Medians (ms), 41 runs for hello and tcc and 11 for synth:

| Input | `link-foreign`, 1 lane / 8 | wild, 1 thread / its threads | mold, 1 / its | lld, 1 / its |
| --- | ---: | ---: | ---: | ---: |
| hello | 0.594 / 1.606 | 1.338 / 2.509 | 2.445 / 5.297 | 4.458 / 5.547 |
| tcc | 1.060 / 2.131 | 2.145 / 2.932 | 3.293 / 6.663 | 5.231 / 6.508 |
| synth | 60.97 / 44.98 | 139.95 / 25.12 | 96.63 / 37.96 | 105.16 / 58.82 |

Their outputs: hello 17,576 bytes (lld's 6,008, mold's 8,120, wild's 6,566),
tcc 450,592 (439,288, 447,704, 437,663) and synth 45,894,224 (45,878,488,
46,158,424, 45,891,297): per lane on synth, 0.75 GB/s against mold's 0.48,
lld's 0.44 and wild's 0.33 on one thread. On btrfs, one lane linked hello in
0.601 ms and tcc in 1.066, against wild's 1.340 and 2.213 and mold's 2.814 and
3.834 on one thread.

Input identities (SHA-256): `timeit`
`c0f9b7a5c76653fd83c037d862322e377d92c3a11c0217a784d9290f43a228f3`, `hello.o`
`225ad00d92f498ba72dd38522ba8fbc79f5f07635806ea8500ac8c3561e107b4`, `tcc.o`
`2714f06e87d3d73b4ed94c9ba62606ee3db34c4d610ac5039cc04909ed6e3c35`,
`libtcc.a` `3c60152eb903fc3ac8a93a24c3fad0a2369c37aa818dfcca7749d76011048128`;
the sorted `sha256sum *.o` listing of synth's objects hashes to
`c8bf7b7106cbd0422f8ad1a0a64a1f47c336f7b77557e387bba07a9d60d298a5`.

## Limitations

Medians of whole processes, from one machine and one session; the logs give
each one's range, which is not a confidence interval. CI's run of the same
tree ([40090244483](https://github.com/buster14a/buster/actions/runs/40090244483),
the job's own `benchmark-link`) measured the same order with every linker
slower: 10 to 25% for the others on the small programs, and 61% for
`link-foreign` on the smallest (0.97 ms against 0.60). The interpreter's
process times include the shell's `fork` of `taskset`, and its `--time` lines
are single runs. `perf record` samples one link, about 1,000 samples.
