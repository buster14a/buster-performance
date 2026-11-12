| stages | ms | of the compile | the compile without it, ms | M cycles | IPC | slots waiting for the frontend |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| register allocation: the first call | 48.4 | 11.3% | 378 | 272.7 | 2.24 | 45% |
| register allocation: the second call | 32.7 | 7.7% | 393 | 184.3 | 2.74 | 39% |
| register allocation: the callee-saved step | 3.5 | 0.8% | 423 | 20.0 | 2.38 | 45% |
| emission: the allocation problem | 18.2 | 4.3% | 408 | 104.0 | 2.29 | 47% |
| emission: saves and frame | 7.1 | 1.7% | 419 | 40.2 | 2.60 | 45% |
| emission: records | 35.0 | 8.2% | 391 | 198.9 | 2.46 | 43% |
| SSA construction | 37.6 | 8.8% | 389 | 208.4 | 2.25 | 48% |
| instruction selection | 33.8 | 7.9% | 392 | 190.8 | 2.18 | 45% |
| IR verification, six checks | 30.6 | 7.2% | 395 | 173.5 | 2.28 | 50% |
| optimizer: analyses, SCCP, dead code, rewrite | 30.5 | 7.1% | 396 | 171.3 | 2.16 | 50% |
| lowering to the IR | 14.1 | 3.3% | 412 | 80.0 | 2.14 | 52% |
| inlining, wide integers, vector pieces, truth, if-conversion | 4.2 | 1.0% | 422 | 23.0 | 2.00 | 51% |
| straight-line functions' back end | 2.1 | 0.5% | 424 | 12.2 | 1.64 | 63% |
| arenas, publication, the rest | 0.8 | 0.2% | 425 | 4.2 | 2.34 | 52% |
| the pipeline | 298.6 | 70.0% | 127 | 1683.6 | 2.31 | 46% |
