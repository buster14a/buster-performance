set pagination off
set confirm off
break tier1_burs_classify_vector
run
printf "vector-selector-breakpoint-hit\n"
bt 4
disable 1
continue
