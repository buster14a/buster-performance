# usage: awk -v re='REGEX' [-v ex='REGEX'] -f blocks.awk tools/ci/correctness.tests
# Prints each "== " block whose heading or script matches re (and not ex).
function flush() { if (blk != "" && blk ~ re && (ex == "" || blk !~ ex)) printf "%s", blk; blk = "" }
/^== / { flush(); started = 1 }
started { blk = blk $0 "\n" }
END { flush() }
