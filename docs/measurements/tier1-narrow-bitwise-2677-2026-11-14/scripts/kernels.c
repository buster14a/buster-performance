// #2677's kernels (#1382's truth values, from buster-performance's tier1-if-convert-1382-2026-11-13), each called from
// bench.c's loop in another object: the `&&` and `&&`/`||` values as _Bool, the latter as int too (a select of the
// truth value and 0, not a test), and #1382's null and clamp rows as controls.
#include <stdbool.h>
int k_null(int a, int b) { return a ^ b; }
int k_clamp(int x) { return x < 0 ? 0 : x > 255 ? 255 : x; }
bool k_and(int a, int b) { return a < 128 && b < 128; }
bool k_andor(int a, int b, int c) { return (a < b) && (b < c || c == 0); }
int k_andori(int a, int b, int c) { return (a < b) && (b < c || c == 0); }
