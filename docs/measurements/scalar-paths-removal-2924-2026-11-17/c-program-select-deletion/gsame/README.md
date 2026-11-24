`-g`'s objects in run.sh's `g` mode differ base against head because each tree compiles in its own directory, which the
DWARF records. Compiled by both executables in one directory (`gsame`, one locked run), Lua's `lvm.c` and `sqlite3.c`
with `-g` are byte-identical:

```
../compilers/base -c -g $L/lvm.c -o base-lvm.o; ../compilers/head -c -g $L/lvm.c -o head-lvm.o   -> cmp: same
../compilers/base -c -g -DSQLITE_THREADSAFE=0 -I$S $S/sqlite3.c -o base-sq.o; (head likewise)     -> cmp: same
```
