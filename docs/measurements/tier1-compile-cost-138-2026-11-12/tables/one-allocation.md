### sqlite: laps3.patch, today's two allocations (two) against the preferred one first (one)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 7 | 425.0 (424.3 to 425.2) | 2,245.5 | +0.00% | 5,278.8 | 100.9 |  |
| one | 7 | 401.6 (400.5 to 402.3) | 2,116.6 | -5.74% | 4,937.8 | 101.1 |  |

### sqlite: laps5.patch, with the restarting exact variant (exact)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 7 | 429.0 (428.2 to 430.6) | 2,268.2 | +0.00% | 5,294.6 | 97.9 |  |
| one | 7 | 403.5 (402.7 to 404.5) | 2,127.8 | -6.19% | 4,940.7 | 97.0 |  |
| exact | 7 | 429.5 (428.0 to 430.5) | 2,271.3 | +0.14% | 5,319.9 | 98.6 |  |

### sqlite: laps6.patch, one allocator call (shared), with the pressure bound (quiet), and the preferred one first (one)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 9 | 427.5 (426.8 to 428.4) | 2,263.6 | +0.00% | 5,298.4 | 98.8 |  |
| shared | 9 | 399.1 (399.0 to 401.2) | 2,109.1 | -6.83% | 4,893.8 | 96.8 |  |
| one | 9 | 402.2 (401.5 to 402.3) | 2,122.6 | -6.23% | 4,944.1 | 97.8 |  |
| quiet | 9 | 398.0 (397.5 to 399.1) | 2,101.0 | -7.18% | 4,838.5 | 97.9 |  |

### sqlite: laps7.patch, the unpatched executable (src) and the patched one's two, shared, quiet and prefix

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 9 | 426.6 (425.6 to 427.6) | 2,259.1 | +0.00% | 5,278.7 | 97.4 | 295.9 |
| two | 9 | 427.6 (427.0 to 428.1) | 2,263.3 | +0.19% | 5,298.9 | 98.5 | 294.5 |
| prefix | 9 | 396.5 (396.0 to 397.1) | 2,093.2 | -7.34% | 4,838.1 | 97.2 | 288.4 |
| shared | 9 | 400.1 (399.7 to 401.7) | 2,113.4 | -6.45% | 4,894.3 | 97.6 | 290.3 |
| quiet | 9 | 399.0 (397.9 to 400.9) | 2,106.8 | -6.74% | 4,838.7 | 97.2 | 290.5 |

### sqlite: laps8.patch, the unpatched executable (src) and the patched one's two, shared, prefix and inline

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 9 | 425.9 (424.7 to 427.3) | 2,258.1 | +0.00% | 5,278.7 | 97.1 | 295.9 |
| two | 9 | 428.4 (428.0 to 429.3) | 2,267.9 | +0.44% | 5,311.2 | 98.5 | 294.5 |
| inline | 9 | 393.0 (391.2 to 393.7) | 2,071.7 | -8.25% | 4,773.7 | 97.0 | 288.4 |
| shared | 9 | 400.6 (399.4 to 401.3) | 2,113.7 | -6.39% | 4,906.6 | 97.1 | 290.3 |
| prefix | 9 | 397.5 (396.4 to 398.3) | 2,097.4 | -7.11% | 4,850.4 | 97.3 | 288.4 |

### lua: laps3.patch, today's two allocations (two) against the preferred one first (one)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 7 | 167.1 (166.8 to 167.4) | 826.7 | +0.00% | 2,014.8 | 93.5 |  |
| one | 7 | 163.2 (162.9 to 165.6) | 807.5 | -2.33% | 1,958.8 | 90.6 |  |

### lua: laps5.patch, with the restarting exact variant (exact)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 7 | 168.6 (168.2 to 170.1) | 835.1 | +0.00% | 2,019.4 | 94.2 |  |
| one | 7 | 164.0 (163.7 to 164.6) | 812.8 | -2.66% | 1,959.8 | 90.8 |  |
| exact | 7 | 167.6 (167.4 to 168.1) | 829.4 | -0.68% | 2,002.8 | 94.2 |  |

### lua: laps6.patch, one allocator call (shared), with the pressure bound (quiet), and the preferred one first (one)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 9 | 167.5 (167.2 to 167.8) | 830.2 | +0.00% | 2,020.2 | 94.2 |  |
| shared | 9 | 162.1 (158.4 to 162.5) | 803.6 | -3.21% | 1,950.9 | 90.4 |  |
| one | 9 | 162.5 (162.2 to 163.3) | 806.6 | -2.85% | 1,960.4 | 90.4 |  |
| quiet | 9 | 161.7 (161.5 to 163.0) | 801.5 | -3.46% | 1,934.9 | 90.6 |  |

### lua: laps7.patch, the unpatched executable (src) and the patched one's two, shared, quiet and prefix

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 9 | 167.4 (167.0 to 167.9) | 828.7 | +0.00% | 2,014.2 | 93.1 | 104.3 |
| two | 9 | 168.2 (167.9 to 168.8) | 832.9 | +0.51% | 2,020.3 | 93.6 | 102.8 |
| prefix | 9 | 162.9 (162.7 to 164.8) | 807.2 | -2.59% | 1,944.9 | 89.9 | 91.0 |
| shared | 9 | 162.8 (162.7 to 163.4) | 807.0 | -2.63% | 1,951.1 | 89.9 | 90.9 |
| quiet | 9 | 162.6 (162.4 to 163.1) | 805.7 | -2.78% | 1,935.0 | 90.1 | 91.1 |

### lua: laps8.patch, the unpatched executable (src) and the patched one's two, shared, prefix and inline

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 9 | 167.5 (167.0 to 169.2) | 829.3 | +0.00% | 2,014.2 | 93.3 | 104.3 |
| two | 9 | 168.6 (168.0 to 169.1) | 833.9 | +0.55% | 2,022.6 | 94.5 | 102.8 |
| inline | 9 | 162.2 (159.1 to 163.5) | 802.7 | -3.21% | 1,932.0 | 90.3 | 91.0 |
| shared | 9 | 162.9 (162.6 to 166.4) | 806.3 | -2.78% | 1,953.3 | 90.8 | 90.9 |
| prefix | 9 | 163.1 (162.3 to 163.6) | 807.5 | -2.64% | 1,947.2 | 90.6 | 91.0 |

### musl: laps3.patch, today's two allocations (two) against the preferred one first (one)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 5 | 1359.5 (1357.2 to 1360.6) | 6,247.4 | +0.00% | 15,175.8 | 1,259.8 |  |
| one | 5 | 1350.8 (1348.8 to 1352.8) | 6,199.7 | -0.76% | 15,053.5 | 1,263.0 |  |

### musl: laps5.patch, with the restarting exact variant (exact)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 5 | 1358.5 (1356.8 to 1361.0) | 6,243.8 | +0.00% | 15,170.2 | 1,260.6 |  |
| one | 5 | 1347.8 (1346.6 to 1350.6) | 6,185.7 | -0.93% | 15,040.0 | 1,260.5 |  |
| exact | 5 | 1357.8 (1355.5 to 1382.6) | 6,248.0 | +0.07% | 15,160.0 | 1,264.2 |  |

### musl: laps6.patch, one allocator call (shared), with the pressure bound (quiet), and the preferred one first (one)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| two | 5 | 1357.9 (1353.6 to 1363.3) | 6,247.2 | +0.00% | 15,171.9 | 1,266.4 |  |
| shared | 5 | 1343.7 (1341.3 to 1353.1) | 6,161.9 | -1.36% | 15,011.3 | 1,263.5 |  |
| one | 5 | 1346.8 (1342.2 to 1356.7) | 6,177.3 | -1.12% | 15,041.3 | 1,262.0 |  |
| quiet | 5 | 1346.0 (1339.6 to 1353.8) | 6,153.3 | -1.50% | 14,979.0 | 1,263.8 |  |

### musl: laps7.patch, the unpatched executable (src) and the patched one's two, shared, quiet and prefix

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 5 | 1348.6 (1347.3 to 1349.1) | 6,201.4 | +0.00% | 15,145.0 | 1,246.5 | 149.9 |
| two | 5 | 1353.0 (1352.5 to 1357.2) | 6,233.7 | +0.52% | 15,172.2 | 1,248.1 | 148.4 |
| prefix | 5 | 1339.4 (1336.2 to 1341.2) | 6,159.6 | -0.67% | 14,991.2 | 1,242.3 | 147.3 |
| shared | 5 | 1343.2 (1338.5 to 1345.3) | 6,174.2 | -0.44% | 15,011.6 | 1,244.2 | 147.4 |
| quiet | 5 | 1338.2 (1336.1 to 1341.6) | 6,153.1 | -0.78% | 14,979.3 | 1,240.4 | 147.4 |

### musl: laps8.patch, the unpatched executable (src) and the patched one's two, shared, prefix and inline

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 5 | 1350.1 (1348.7 to 1353.5) | 6,208.2 | +0.00% | 15,145.0 | 1,254.8 | 149.9 |
| two | 5 | 1359.0 (1356.5 to 1365.7) | 6,259.7 | +0.83% | 15,177.5 | 1,246.3 | 148.3 |
| inline | 5 | 1341.4 (1336.8 to 1343.6) | 6,170.0 | -0.62% | 14,963.5 | 1,241.7 | 147.2 |
| shared | 5 | 1344.4 (1342.9 to 1354.3) | 6,184.8 | -0.38% | 15,017.0 | 1,243.3 | 147.3 |
| prefix | 5 | 1344.2 (1341.8 to 1346.1) | 6,182.8 | -0.41% | 14,996.6 | 1,243.0 | 147.2 |

