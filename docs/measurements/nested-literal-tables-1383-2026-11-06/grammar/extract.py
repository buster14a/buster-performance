# usage: extract.py BUSTER_CHECKOUT — cuts check_literal_table_parity and check_literal_table_rows into extract.h
import sys
src = open(sys.argv[1] + '/src/buster/compiler/c_check_literal_table_input.c').read()
a = src.index('// The lanes of `bits` that follow')
b = src.index('// Common bin2c spellings')
open('extract.h', 'w').write(src[a:b])
