# Writes extract.h, the string decoder of c_check_literals.c alone, for fuzz.c and bench.c.
# usage: python3 extract.py BUSTER_CHECKOUT
import sys
src = open(sys.argv[1] + "/src/buster/compiler/c_check_literals.c").read()
def cut(a, b):
    i = src.index(a); j = src.index(b, i); return src[i:j]
types = cut("typedef struct CheckStringPart CheckStringPart;", "static uint32_t check_literal_digit")
digit = cut("static uint32_t check_literal_digit", "// A bit-precise constant")
unit = cut("// Always inlined (#880), as profile-guided builds do; hot caller: check_literal_string_part, once per character.", "static CheckLiteral check_literal_character(")
rest = cut("static CheckStringSpan check_literal_string_span", "// Decode one adjacent literal group after preprocessing.")
types = types.replace("TypeId element_type;", "uint32_t element_type;")
open("extract.h", "w").write(types + digit + unit + rest)
