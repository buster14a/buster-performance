# Independently rebuilt compiler controls for #2924

An independent Release build of `cc7d4ffb4` on the Ryzen 7 9700X had identical contents for every file-backed ELF section except five debugging sections. The archive contains the section sizes and SHA-256 digests. The executable code, read-only constants and initialized program data matched byte for byte.

Each of the six configurations ran seven rounds on core 2 with the shared exclusive lock. Each round started four fresh compiler processes under each of seven executable labels. Every executable occupied every launch position once. Both parent executables and five source variants were present in each round. The runs compiled 34 Lua units, the SQLite amalgamation and 1,336 musl units, with debug information and one compiler lane. All 42 groups completed successfully.

The table gives the median percentage change in user cycles against the arithmetic mean of the two parent measurements in the same round. Positive values mean more cycles. The original and rebuilt columns quantify variation between two executables with identical code. Observing that variation does not establish a regression threshold.

| Tier | Corpus | Original parent | Rebuilt parent | Wide division | Direct member resolution | Contiguous IR ranges | IR with extra-list detection | Cold wide division |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| tier0 | lua | +0.106% | -0.106% | -0.002% | +0.089% | +0.092% | +0.000% | +0.052% |
| tier0 | sqlite | +0.138% | -0.138% | -0.210% | -0.060% | -0.096% | -0.047% | +0.084% |
| tier0 | musl | +0.045% | -0.045% | +0.005% | -0.018% | +0.128% | +0.073% | -0.117% |
| tier1 | lua | -0.062% | +0.062% | +0.062% | +0.191% | +0.285% | +0.096% | -0.014% |
| tier1 | sqlite | -0.044% | +0.044% | -0.066% | +0.075% | +0.101% | +0.090% | -0.082% |
| tier1 | musl | +0.032% | -0.032% | +0.145% | +0.011% | +0.131% | +0.025% | -0.077% |

Cold wide division reduced median cycles in all three Tier 1 configurations and in Tier 0 musl. Tier 0 Lua and SQLite still took more cycles than the paired parent mean. IR with extra-list detection improved the complete compilation median on Tier 0 SQLite. The IR optimizer pass driver is measured separately.

[ELF section comparisons, all per-process counters, round medians and runners](seven-way-compilations.tar.xz)
