# Native checker program extraction for Buster #2053

[Buster PR #3526](https://github.com/buster14a/buster/pull/3526) compares `2d20b1826` and `b6eb10860`. Clang 23.1.4 compiled the original expressions and macros with a compile-time length for each input. `native.c` emits a uint32 little-endian length followed by the raw bytes for each row in `native-inventory.tsv`. All 470 files match in order, including absent final newlines. They comprise 345,966 bytes in 91 groups.

All eight vector Release checker parts passed with seed 133 and BUSTER_CLANG_RESOURCE_DIR set to the pinned resource directory. The parts ran 833,533 checks. The program-bits focus ran 2,137 checks before and 2,138 after. Adding a case made the same executable check 18 programs in the lowering comparison. Invalid source produced a failure. Both data changes scheduled zero Ninja commands and retained the binary digest.

The change removed a net 470,336 bytes from host C. The checker object went from 30,935,944 bytes to 30,507,888 and the executable from 74,109,920 to 74,097,600. The build log is from a shared four-vCPU-quota cloud VM. No target-hardware timing claim is made.
