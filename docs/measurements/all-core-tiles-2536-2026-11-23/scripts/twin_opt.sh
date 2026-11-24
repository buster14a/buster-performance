#!/bin/bash
# twin_opt.sh COMPILER LIST OPTION ENV...: each file compiled plain (--parse-tile=0) and with OPTION under the environment
# given; objects, stderr and statuses compared.
c=$1; list=$2; opt=$3; shift 3; d=$(mktemp -d); n=0; bad=0
while read -r f; do
    n=$((n+1))
    $c -c -Wall -Wextra --parse-tile=0 "$f" -o $d/a.o 2> $d/a.err; sa=$?
    env "$@" $c -c -Wall -Wextra $opt "$f" -o $d/b.o 2> $d/b.err; sb=$?
    ok=1
    [ $sa = $sb ] || ok=0
    cmp -s $d/a.err $d/b.err || ok=0
    if [ $sa = 0 ]; then cmp -s $d/a.o $d/b.o || ok=0; fi
    [ $ok = 1 ] || { bad=$((bad+1)); echo "DIFFER $f ($sa $sb)"; }
    rm -f $d/*.o
done < "$list"
echo "$n files, $bad differ ($opt $*)"
rm -rf $d
