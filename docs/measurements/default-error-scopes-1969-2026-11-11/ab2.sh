#!/bin/bash
# base (main d43c37e) vs head (claude/1969-default-error-scopes 4023c4ea): -fsyntax-only --time-stages of sqlite3.c and main.c.
# ab takes the 9700X lock for each run (--lock), pinned to CPU 2; each run prints its own time-stage lines.
D=~/buster-fast-bench/1969-claude
cd $D
export EXCLUSIVE_OWNER=claude-c5 EXCLUSIVE_TITLE='C5: rejected units warnings (#1969)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxneBL4rUaGXcmPE1Coj
head/build/compiler ab --rounds 6 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head \
  -- -fsyntax-only --time-stages $D/sqlite3.c \
  -- -fsyntax-only --time-stages -march=native -I$D/head/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/head/src/buster/compiler/main.c
echo "exit $?"
