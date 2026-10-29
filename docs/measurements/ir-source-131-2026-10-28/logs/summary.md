| Measurement | main | head | change | main range | head range | rounds |
| --- | ---: | ---: | ---: | --- | --- | ---: |
| verifier 32 instr: scalar (ns/instruction) | 9.749 | 9.879 | +1.3% | 9.414-10.117 | 9.860-10.088 | 3 |
| verifier 32 instr: vector (ns/instruction) | 6.082 | 6.430 | +5.7% | 5.943-6.114 | 6.422-6.632 | 3 |
| verifier 32 instr: uses (ns/instruction) | 11.046 | 11.157 | +1.0% | 10.960-11.164 | 11.102-11.173 | 3 |
| verifier 32 instr: cfg (ns/instruction) | 1.680 | 1.733 | +3.2% | 1.659-1.702 | 1.732-1.734 | 3 |
| verifier 262144 instr: scalar (ns/instruction) | 8.957 | 9.458 | +5.6% | 8.900-8.999 | 9.431-9.471 | 3 |
| verifier 262144 instr: vector (ns/instruction) | 5.654 | 6.064 | +7.3% | 5.631-5.773 | 6.019-6.375 | 3 |
| verifier 262144 instr: uses (ns/instruction) | 12.803 | 12.661 | -1.1% | 12.773-12.967 | 12.524-12.908 | 3 |
| verifier 262144 instr: cfg (ns/instruction) | 1.339 | 1.380 | +3.1% | 1.331-1.358 | 1.380-1.391 | 3 |
| lowering small mixed programs: scalar (ns/typed entry) | 33.960 | 35.614 | +4.9% | 33.827-34.494 | 35.439-35.734 | 3 |
| lowering small mixed programs: vector (ns/typed entry) | 30.800 | 31.857 | +3.4% | 30.607-30.889 | 31.813-31.874 | 3 |
| lowering larger mixed programs: scalar (ns/typed entry) | 73.250 | 75.747 | +3.4% | 72.469-73.367 | 75.715-75.844 | 3 |
| lowering larger mixed programs: vector (ns/typed entry) | 65.193 | 67.051 | +2.8% | 64.540-65.242 | 67.010-67.281 | 3 |
| lowering larger object programs: scalar (ns/typed entry) | 57.909 | 60.109 | +3.8% | 57.447-57.974 | 59.935-60.110 | 3 |
| lowering larger object programs: vector (ns/typed entry) | 52.033 | 53.718 | +3.2% | 51.594-52.208 | 53.709-53.810 | 3 |
| lowering larger dynamic stack programs: scalar (ns/typed entry) | 66.674 | 69.065 | +3.6% | 66.219-66.789 | 68.791-69.178 | 3 |
| lowering larger dynamic stack programs: vector (ns/typed entry) | 59.817 | 61.569 | +2.9% | 59.304-60.038 | 61.551-61.828 | 3 |
| lowering alloca isolated programs: scalar (ns/typed entry) | 12.014 | 12.947 | +7.8% | 11.999-12.074 | 12.859-13.072 | 3 |
| lowering alloca isolated programs: vector (ns/typed entry) | 11.024 | 11.722 | +6.3% | 11.003-11.056 | 11.650-11.754 | 3 |
| lowering stack-save isolated programs: scalar (ns/typed entry) | 7.702 | 8.178 | +6.2% | 7.701-7.730 | 8.125-8.188 | 3 |
| lowering stack-save isolated programs: vector (ns/typed entry) | 5.963 | 6.139 | +3.0% | 5.959-5.973 | 6.111-6.217 | 3 |
| lowering stack-restore isolated programs: scalar (ns/typed entry) | 8.877 | 9.373 | +5.6% | 8.788-8.953 | 9.229-9.391 | 3 |
| lowering stack-restore isolated programs: vector (ns/typed entry) | 8.083 | 8.379 | +3.7% | 7.987-8.102 | 8.242-8.481 | 3 |
| optimize small-dag: scalar (ns/function) | 2133.650 | 2202.100 | +3.2% | 2116.500-2150.800 | 2179.400-2224.800 | 2 |
| optimize small-dag: vector (ns/function) | 2164.450 | 2135.300 | -1.3% | 2147.900-2181.000 | 2129.200-2141.400 | 2 |
| optimize large-dag: scalar (ns/function) | 131085.250 | 137739.650 | +5.1% | 130043.900-132126.600 | 136640.100-138839.200 | 2 |
| optimize large-dag: vector (ns/function) | 133684.200 | 133837.600 | +0.1% | 132167.300-135201.100 | 133792.800-133882.400 | 2 |
| optimize phi-diamond: scalar (ns/function) | 1631.200 | 1762.900 | +8.1% | 1619.700-1642.700 | 1742.200-1783.600 | 2 |
| optimize phi-diamond: vector (ns/function) | 1842.450 | 1896.800 | +2.9% | 1833.300-1851.600 | 1896.100-1897.500 | 2 |
| optimize loop: scalar (ns/function) | 1887.800 | 1965.500 | +4.1% | 1878.400-1897.200 | 1961.500-1969.500 | 2 |
| optimize loop: vector (ns/function) | 2255.500 | 2246.900 | -0.4% | 2247.000-2264.000 | 2243.600-2250.200 | 2 |
| optimize jump-chain: scalar (ns/function) | 7760.450 | 8431.800 | +8.7% | 7725.600-7795.300 | 8352.300-8511.300 | 2 |
| optimize jump-chain: vector (ns/function) | 17795.650 | 17338.100 | -2.6% | 17758.700-17832.600 | 17253.700-17422.500 | 2 |
| passes gvn small-dag: scalar (ns/function) | 3321.395 | 3260.545 | -1.8% | 3309.600-3333.190 | 3244.290-3276.800 | 2 |
| passes gvn small-dag: vector (ns/function) | 4636.610 | 4485.825 | -3.3% | 4622.620-4650.600 | 4452.940-4518.710 | 2 |
| passes gvn large-dag: scalar (ns/function) | 285436.000 | 275656.440 | -3.4% | 283528.000-287344.000 | 275247.500-276065.380 | 2 |
| passes gvn large-dag: vector (ns/function) | 1308857.500 | 1373869.250 | +5.0% | 1306530.500-1311184.500 | 1367144.000-1380594.500 | 2 |
| passes gvn cyclic-phi: scalar (ns/function) | 2137.655 | 2179.610 | +2.0% | 2131.210-2144.100 | 2169.820-2189.400 | 2 |
| passes gvn cyclic-phi: vector (ns/function) | 2397.045 | 2419.000 | +0.9% | 2384.830-2409.260 | 2403.430-2434.570 | 2 |
| passes licm no-loop: scalar (ns/function) | 3490.015 | 3423.310 | -1.9% | 3471.220-3508.810 | 3421.930-3424.690 | 2 |
| passes licm no-loop: vector (ns/function) | 3060.805 | 3167.985 | +3.5% | 3024.250-3097.360 | 3150.980-3184.990 | 2 |
| passes licm nested-loops: scalar (ns/function) | 3044.450 | 3190.155 | +4.8% | 3033.130-3055.770 | 3162.170-3218.140 | 2 |
| passes licm nested-loops: vector (ns/function) | 3540.450 | 3512.800 | -0.8% | 3531.270-3549.630 | 3503.820-3521.780 | 2 |
| passes licm invariant-chain: scalar (ns/function) | 317584.500 | 297094.750 | -6.5% | 315299.000-319870.000 | 295569.380-298620.120 | 2 |
| passes licm invariant-chain: vector (ns/function) | 1083565.000 | 825785.125 | -23.8% | 1080677.500-1086452.500 | 824659.250-826911.000 | 2 |
| passes sroa two-fields: scalar (ns/function) | 1466.730 | 1446.710 | -1.4% | 1445.270-1488.190 | 1436.010-1457.410 | 2 |
| passes sroa two-fields: vector (ns/function) | 1423.660 | 1392.795 | -2.2% | 1398.340-1448.980 | 1386.640-1398.950 | 2 |
| passes sroa conditional-stores: scalar (ns/function) | 2163.115 | 2172.645 | +0.4% | 2146.860-2179.370 | 2170.250-2175.040 | 2 |
| passes sroa conditional-stores: vector (ns/function) | 2159.115 | 2106.460 | -2.4% | 2114.710-2203.520 | 2101.350-2111.570 | 2 |
| passes sroa field-array: scalar (ns/function) | 22585.055 | 23302.460 | +3.2% | 22432.310-22737.800 | 23289.230-23315.690 | 2 |
| passes sroa field-array: vector (ns/function) | 20365.270 | 20797.800 | +2.1% | 20233.890-20496.650 | 20719.570-20876.030 | 2 |
