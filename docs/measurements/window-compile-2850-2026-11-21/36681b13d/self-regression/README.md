# Self-compilation failure

The initial widening loop lost live operand columns once a graph crossed multiple 256-node chunks. Buster failed in all three warning-policy modes and the ordinary compiler succeeded in each one. The signed correction clamps the active SIMD width and adds scalar and packed edge regressions at 259 and 519 nodes. [Comparison](main.tsv) · [Debugger output](coverage-main.log)
