# Lua 5.4.8 language, C API and runtime

All six full upstream suites reached their final success marker. Release and internal-test interpreters built by pinned Clang, main and the 25-change integration ran the same unmodified 27 Lua files. Release used 33 source files and the internal build included upstream ltests.c as the 34th. The [six exits and executable identities](ksh-checks.tsv), [build objects](objects.tsv), [transcripts](transcripts/) and [input archive hashes](inputs.tsv) identify the runs.

The standalone prompt test needs readline. The file tests need a pipe on standard input and expect a nested shell killed by SIGHUP to report an exit status to its parent. The local Bash and dash runs reached the same files.lua assertion across all three compilers. In a private mount namespace the packaged Korn shell supplied those semantics. The [shell probe](ksh-semantics.txt) and [harness](harness/) document the environment.

The release interpreter executed five workloads in four object-link orders. [60 independent output checks](execution/checks.tsv) agreed with pinned Clang. The following ranges are across the four placement-specific paired medians, each from seven post-warm-up pairs on the local Ryzen 9 7940HS. [320 timed processes](execution/processes.tsv.gz) and [all paired results](execution/paired.tsv).

| Lua workload | Instructions | User cycles |
|---|---:|---:|
| arithmetic | -0.006% to -0.006% | +0.099% to +0.264% |
| calls | +0.000% to +0.000% | +0.937% to +1.652% |
| closures | -0.070% to +0.136% | -1.808% to +1.390% |
| strings | -0.010% to +0.002% | -0.947% to +2.858% |
| tables | -0.015% to -0.001% | -0.693% to +0.502% |
