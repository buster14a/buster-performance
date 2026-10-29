| Measurement | main | head | change | main range | head range | rounds |
| --- | ---: | ---: | ---: | --- | --- | ---: |
| verifier 32 instr: scalar (ns/instruction) | 9.668 | 10.259 | +6.1% | 9.639-9.684 | 10.167-10.263 | 3 |
| verifier 32 instr: vector (ns/instruction) | 5.950 | 6.257 | +5.2% | 5.935-6.040 | 6.130-6.271 | 3 |
| verifier 32 instr: uses (ns/instruction) | 11.003 | 11.717 | +6.5% | 10.884-11.052 | 11.703-11.720 | 3 |
| verifier 32 instr: cfg (ns/instruction) | 1.668 | 1.751 | +5.0% | 1.664-1.678 | 1.740-1.869 | 3 |
| verifier 262144 instr: scalar (ns/instruction) | 8.850 | 9.326 | +5.4% | 8.831-8.862 | 9.316-9.334 | 3 |
| verifier 262144 instr: vector (ns/instruction) | 5.647 | 5.968 | +5.7% | 5.643-5.665 | 5.943-5.987 | 3 |
| verifier 262144 instr: uses (ns/instruction) | 12.608 | 13.058 | +3.6% | 12.483-12.748 | 13.016-13.310 | 3 |
| verifier 262144 instr: cfg (ns/instruction) | 1.333 | 1.400 | +5.0% | 1.331-1.339 | 1.360-1.404 | 3 |
| lowering small mixed programs: scalar (ns/typed entry) | 34.031 | 36.779 | +8.1% | 33.960-34.436 | 36.725-36.976 | 3 |
| lowering small mixed programs: vector (ns/typed entry) | 30.654 | 32.671 | +6.6% | 30.601-30.890 | 32.535-32.849 | 3 |
| lowering larger mixed programs: scalar (ns/typed entry) | 73.586 | 75.305 | +2.3% | 73.406-73.598 | 75.235-75.585 | 3 |
| lowering larger mixed programs: vector (ns/typed entry) | 65.599 | 66.926 | +2.0% | 65.514-65.742 | 66.828-66.973 | 3 |
| lowering larger object programs: scalar (ns/typed entry) | 58.142 | 59.353 | +2.1% | 57.937-58.451 | 59.312-59.448 | 3 |
| lowering larger object programs: vector (ns/typed entry) | 52.407 | 53.441 | +2.0% | 52.190-52.586 | 53.357-53.444 | 3 |
| lowering larger dynamic stack programs: scalar (ns/typed entry) | 67.217 | 68.383 | +1.7% | 66.995-67.349 | 68.306-68.526 | 3 |
| lowering larger dynamic stack programs: vector (ns/typed entry) | 60.177 | 61.411 | +2.1% | 60.048-60.499 | 61.347-61.433 | 3 |
| lowering alloca isolated programs: scalar (ns/typed entry) | 12.074 | 12.407 | +2.8% | 12.003-12.277 | 12.404-12.552 | 3 |
| lowering alloca isolated programs: vector (ns/typed entry) | 11.070 | 11.405 | +3.0% | 11.049-11.230 | 11.349-11.553 | 3 |
| lowering stack-save isolated programs: scalar (ns/typed entry) | 7.856 | 7.965 | +1.4% | 7.794-8.012 | 7.850-8.074 | 3 |
| lowering stack-save isolated programs: vector (ns/typed entry) | 5.999 | 6.036 | +0.6% | 5.991-6.163 | 6.021-6.131 | 3 |
| lowering stack-restore isolated programs: scalar (ns/typed entry) | 9.026 | 9.052 | +0.3% | 8.903-9.071 | 9.001-9.190 | 3 |
| lowering stack-restore isolated programs: vector (ns/typed entry) | 8.273 | 8.192 | -1.0% | 8.136-8.305 | 8.148-8.361 | 3 |
| optimize small-dag: scalar (ns/function) | 2119.400 | 2220.600 | +4.8% | 2119.400-2119.400 | 2220.600-2220.600 | 1 |
| optimize small-dag: vector (ns/function) | 2156.300 | 2239.100 | +3.8% | 2156.300-2156.300 | 2239.100-2239.100 | 1 |
| optimize large-dag: scalar (ns/function) | 131370.200 | 144384.600 | +9.9% | 131370.200-131370.200 | 144384.600-144384.600 | 1 |
| optimize large-dag: vector (ns/function) | 134288.100 | 144512.900 | +7.6% | 134288.100-134288.100 | 144512.900-144512.900 | 1 |
| optimize phi-diamond: scalar (ns/function) | 1636.100 | 1755.700 | +7.3% | 1636.100-1636.100 | 1755.700-1755.700 | 1 |
| optimize phi-diamond: vector (ns/function) | 1862.100 | 1936.400 | +4.0% | 1862.100-1862.100 | 1936.400-1936.400 | 1 |
| optimize loop: scalar (ns/function) | 1881.800 | 1967.300 | +4.5% | 1881.800-1881.800 | 1967.300-1967.300 | 1 |
| optimize loop: vector (ns/function) | 2230.000 | 2312.100 | +3.7% | 2230.000-2230.000 | 2312.100-2312.100 | 1 |
| optimize jump-chain: scalar (ns/function) | 7817.400 | 8179.100 | +4.6% | 7817.400-7817.400 | 8179.100-8179.100 | 1 |
| optimize jump-chain: vector (ns/function) | 17887.400 | 17442.400 | -2.5% | 17887.400-17887.400 | 17442.400-17442.400 | 1 |
| passes gvn small-dag: scalar (ns/function) | 3296.120 | 3507.860 | +6.4% | 3296.120-3296.120 | 3507.860-3507.860 | 1 |
| passes gvn small-dag: vector (ns/function) | 4665.140 | 4592.680 | -1.6% | 4665.140-4665.140 | 4592.680-4592.680 | 1 |
| passes gvn large-dag: scalar (ns/function) | 281073.380 | 304307.000 | +8.3% | 281073.380-281073.380 | 304307.000-304307.000 | 1 |
| passes gvn large-dag: vector (ns/function) | 1303415.000 | 1374673.500 | +5.5% | 1303415.000-1303415.000 | 1374673.500-1374673.500 | 1 |
| passes gvn cyclic-phi: scalar (ns/function) | 2112.650 | 2223.020 | +5.2% | 2112.650-2112.650 | 2223.020-2223.020 | 1 |
| passes gvn cyclic-phi: vector (ns/function) | 2369.220 | 2460.970 | +3.9% | 2369.220-2369.220 | 2460.970-2460.970 | 1 |
| passes licm no-loop: scalar (ns/function) | 3474.230 | 3573.420 | +2.9% | 3474.230-3474.230 | 3573.420-3573.420 | 1 |
| passes licm no-loop: vector (ns/function) | 3125.460 | 3186.260 | +1.9% | 3125.460-3125.460 | 3186.260-3186.260 | 1 |
| passes licm nested-loops: scalar (ns/function) | 3065.280 | 3190.970 | +4.1% | 3065.280-3065.280 | 3190.970-3190.970 | 1 |
| passes licm nested-loops: vector (ns/function) | 3553.040 | 3755.260 | +5.7% | 3553.040-3553.040 | 3755.260-3755.260 | 1 |
| passes licm invariant-chain: scalar (ns/function) | 316541.250 | 349283.880 | +10.3% | 316541.250-316541.250 | 349283.880-349283.880 | 1 |
| passes licm invariant-chain: vector (ns/function) | 1075943.500 | 1273824.500 | +18.4% | 1075943.500-1075943.500 | 1273824.500-1273824.500 | 1 |
| passes sroa two-fields: scalar (ns/function) | 1447.320 | 1460.740 | +0.9% | 1447.320-1447.320 | 1460.740-1460.740 | 1 |
| passes sroa two-fields: vector (ns/function) | 1393.660 | 1440.970 | +3.4% | 1393.660-1393.660 | 1440.970-1440.970 | 1 |
| passes sroa conditional-stores: scalar (ns/function) | 2162.960 | 2217.670 | +2.5% | 2162.960-2162.960 | 2217.670-2217.670 | 1 |
| passes sroa conditional-stores: vector (ns/function) | 2149.540 | 2190.050 | +1.9% | 2149.540-2149.540 | 2190.050-2190.050 | 1 |
| passes sroa field-array: scalar (ns/function) | 22507.690 | 23566.230 | +4.7% | 22507.690-22507.690 | 23566.230-23566.230 | 1 |
| passes sroa field-array: vector (ns/function) | 20180.270 | 21280.300 | +5.5% | 20180.270-20180.270 | 21280.300-21280.300 | 1 |
