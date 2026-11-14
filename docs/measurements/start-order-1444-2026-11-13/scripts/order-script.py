#!/usr/bin/env python3
# #1444 item 4 (experiment): from layout.py's hot-functions.txt ("ADDRESS SIZE UNIT NAME", the functions small compiles
# run, each copy by its address), in the order they had:
# - ORDER.ld, a linker script that places the compiler's units' functions first, before .text, each by its unit's object
#   and its section (-ffunction-sections' .text.NAME, or .text.unlikely.NAME), so that one unit's copy of a static
#   helper moves and the others' don't. The checker's own section (.text.buster_checker) can't be split and stays;
# - ORDER.sym, a symbol ordering file of the C library's functions (the static link's, after every object's), whose
#   names no unit's statics share, so that lld puts their sections first in .text, right after.
#   order-script.py hot-functions.txt ORDER
import sys
libc_units = {"c_check_target_feature_emission_test.c", "libc/other"}
rows = []
for line in open(sys.argv[1]):
    a, s, unit, name = line.split()
    rows.append((int(a, 16), int(s), unit, name))
rows.sort()
with open(sys.argv[2] + ".ld", "w") as out:
    out.write("SECTIONS\n{\n    .text.buster_start :\n    {\n")
    for a, s, unit, name in rows:
        if unit in libc_units or not unit.endswith(".c"):
            continue
        stem = unit[:-2]
        for pattern in ("*/%s.c.o" % stem, "*/%s/native.o" % stem):
            out.write("        %s(.text.%s .text.unlikely.%s)\n" % (pattern, name, name))
    out.write("    }\n}\nINSERT BEFORE .text;\n")
with open(sys.argv[2] + ".sym", "w") as out:
    for a, s, unit, name in rows:
        if unit in libc_units:
            out.write(name + "\n")
