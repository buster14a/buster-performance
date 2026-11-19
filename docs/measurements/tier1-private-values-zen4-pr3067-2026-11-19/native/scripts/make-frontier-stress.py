#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Generate a CFG in which many joins share a long dominator chain."""
import sys

n = int(sys.argv[1])
if n < 16:
    raise SystemExit("at least 16 joins required")
print("static volatile unsigned probe = ~0U;")
print("__attribute__((noinline)) static int select_value(int raw, unsigned selector, int other) {")
print("    int x;")
print("    if (other) { x = raw + 11; goto other_dispatch; }")
print("    x = raw - 2;")
for i in range(n):
    print(f"    if (probe == {i}U) return x - {i};")
for expression in ("selector", "selector + 1U"):
    if expression != "selector":
        print("other_dispatch:")
    print(f"    switch ({expression}) {{")
    for i in range(n):
        print(f"    case {i}U: goto join_{i};")
    print("    default: return -1;\n    }")
for i in range(n):
    print(f"join_{i}: return x + {i};")
print("}")
print("int main(void) { return select_value(17, 13, 0) != 28 || select_value(17, 13, 1) != 42; }")
