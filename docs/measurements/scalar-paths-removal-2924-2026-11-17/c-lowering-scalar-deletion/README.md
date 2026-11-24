# #2924 C12c-4: the definition planner's scalar selector

`c_lowering_scalar` had no caller once selection (#3462) and the lazy planner (#3465) stopped choosing it, so it goes
with its `visited` column. test-lowering keeps its independent oracle (a plain work queue over the unsorted
references) and Clang's symbols.

`mutation.sh` mutates the vector selector; `mutation-results.txt`: both killed (lane 15 dropped on blocks after the
first: 762,199 failures; optional definitions taken as roots in C_LOWERING_ALL: 16,519).
