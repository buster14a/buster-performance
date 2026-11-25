# #3577 round 4: the instructions' baseline and the cost after merging main 38483c5ba

buster#3597 (#3577) merged main twice more: 00ef70b20 (#3614, #3584's bulk reading of directive lines and macro calls)
as a3ff9881f, pushed as ec2e544f5 with the baseline below; and 38483c5ba (#3617, #3592's dead arms of constant
conditions) as bc300ab5a, pushed as 9d8560db5 with the baseline below. Each head was shipped to the 9700X as a git
bundle.

Both scripts (`scripts/m4.sh`, `scripts/m5.sh`) build main and the head as the 9700X job builds them
(`BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`, debug information on), each under the lock, then in one hold run
the job's "Hold sqlite3.c's compile to its instructions' baseline" step on each tree (`measure-compile --runs 3
--instructions-baseline tools/ci/compile-instructions.txt`, the tree's own file) and `measure-compile --runs 41`
interleaved. sqlite3.c's default `-c`, the job's flags and the host's headers, pinned to CPU 2.

## The baseline step

| tree | user instructions (median of 3) | the tree's file | verdict |
| --- | --- | --- | --- |
| main 00ef70b20 | 210,730,976 | 210,562,407 | +0.080%, passes |
| a3ff9881f (#3614 merged) | 230,303,891 | 210,562,407 (main's) | +9.376%, fails: written in ec2e544f5 |
| main 38483c5ba | 211,716,272 | 210,562,407 | +0.548%, fails |
| bc300ab5a (#3617 merged) | 230,680,515 | 230,303,891 | +0.164%, passes; written in 9d8560db5 |

Main 38483c5ba is past its own band: #3617 moved the count by about +0.47% against 00ef70b20 without stating it, which
the nightly's step will report.

## The cost (41 runs each, one hold with its main)

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 00ef70b20 | 16.285 ms | 80.2 M | 210.7 M |
| a3ff9881f | 17.380 ms (+6.7%) | 85.9 M (+7.1%) | 230.3 M (+9.3%) |
| main 38483c5ba | 16.331 ms | 80.6 M | 211.7 M |
| bc300ab5a | 17.392 ms (+6.5%) | 86.3 M (+7.1%) | 230.7 M (+9.0%) |

`results/m4.out` and `results/m5.out` hold `measure-compile`'s output, `results/bp-m4.log` and `results/bp-m5.log` the
scripts' logs. Every object came from the direct path (`buster direct` in `.comment`).
