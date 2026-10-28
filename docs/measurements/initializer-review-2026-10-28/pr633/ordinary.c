// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original ordinary-record control for the direct-name namespace skip.
struct Small { int x; char y; };
struct Pair { struct Small first; struct Small second; };
_Static_assert(sizeof(struct Small) == 8, "small layout");
_Static_assert(sizeof(struct Pair) == 16, "pair layout");
int ordinary(void) { return sizeof(struct Pair); }
