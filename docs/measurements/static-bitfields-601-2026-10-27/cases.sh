#!/usr/bin/env bash
cases=(plain-1024 plain-4096 plain-16384 plain-65536 packed-16384 wide-16384 mixed-4096 clear-16384 sqlite lua-vm lua-table)
set_case()
{
  case_name=$1
  options=(-c --lanes 1)
  case "$case_name" in
    plain-*|packed-*|wide-*|mixed-*|clear-*) source="evidence/inputs/$case_name.c" ;;
    sqlite) source=evidence/inputs/external/sqlite/sqlite3.c
            options+=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE) ;;
    lua-vm) source=evidence/inputs/external/lua/lvm.c
            options+=(-U__ELF__ -DLUA_USE_JUMPTABLE=0) ;;
    lua-table) source=evidence/inputs/external/lua/ltable.c
               options+=(-U__ELF__ -DLUA_USE_JUMPTABLE=0) ;;
    *) return 2 ;;
  esac
}
