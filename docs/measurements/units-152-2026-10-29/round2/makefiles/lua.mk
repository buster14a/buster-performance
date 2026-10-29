OBJECTS = lapi.o lauxlib.o lbaselib.o lcode.o lcorolib.o lctype.o ldblib.o ldebug.o ldo.o ldump.o lfunc.o lgc.o linit.o liolib.o llex.o lmathlib.o lmem.o loadlib.o lobject.o lopcodes.o loslib.o lparser.o lstate.o lstring.o lstrlib.o ltable.o ltablib.o ltm.o lua.o lundump.o lutf8lib.o lvm.o lzio.o 
lua: $(OBJECTS)
	$(CC) -o $@ $(OBJECTS) -lm -ldl
%.o: /home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src/%.c
	$(CC) $(CFLAGS) -c $< -o $@
