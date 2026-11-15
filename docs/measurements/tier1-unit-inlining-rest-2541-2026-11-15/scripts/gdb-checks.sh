for p in dbg9 dbg9l; do echo "== $p values"; gdb -nx -batch -x vals.gdb ./$p 2>&1 | grep -E '^#[0-2]' | sed 's/0x[0-9a-f]* in //; s/ at .*//' | tr '\n' ' '; echo; echo "== $p break"; gdb -nx -batch -x brk.gdb ./$p 2>&1 | grep -E 'locations' ; done
echo "== two"; gdb -nx -batch -x two.gdb ./two 2>&1 | grep -E '^#1' | sed 's/0x[0-9a-f]* in //; s/ at .*//'
echo "== t1h"; gdb -nx -batch -x bt.gdb ./t1h 2>&1 | grep -E '^#'
