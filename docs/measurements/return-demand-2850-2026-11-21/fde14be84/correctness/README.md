# Ordinary checker and driver correctness on fde14be84

Exact candidate fde14be84c074a65e8219f82c73202355635cfe1 and parent 875c08e9dd85c4c67bbe24a00e54bbe33f0890b5, Develop, Linux x86-64, Clang 23.1.4. The candidate executable SHA-256 is 34bd6cf7e15fb479617a5721d43987ca981b2595ea569de1b712ee469924aa57, the parent is f7cec863f9e254b66fa75dfd2cb446fb302a04395df132be0e4363a688ec0c56. Both source worktrees were clean.

All eight checker shards passed 848,394 checks, including every-node comparison of the incremental and complete semantic definitions. All eight native driver shards passed 208,919 checks with Clang 23.1.4. Commands were `build/compiler test-checker --seed 133 --part N/8` and `build/compiler test-checker-driver --in-process --executable $PWD/build/compiler --part N/8`. The driver used Clang native C predefines (`clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null`).

The local two-binary campaign ran both executables on the same sources and working directory. SQLite, Lua VM/parser, musl printf/malloc, Buster's own unchanged main translation unit, and default, `-Wall -Wextra` and `-w` on each of the targeted controls, the 448-function generated control matrix and the noreturn fixture all returned 0 with identical stdout, stderr and object SHA-256. The remaining three commands with `-Wno-return-type` previously failed inside the still-active `-Winvalid-noreturn` check. All succeed with the candidate. The focused `no-return.c` emits exactly the one `-Winvalid-noreturn` warning on the same location as Clang 23.1.4. The separate scope of the native release performance record is described in its own readme.

`objects-and-diagnostics.json` records all 18 ordinary compile comparisons. `noreturn-policies.json` contains independent Clang diagnostic and source-line comparison at all three policies. The matrix source tests combinations of four return types, seven control shapes, eight body endings and two call-operand orders.

The archived Clang and Buster warning text uses the relative name `no-return.c` for the fixture.
