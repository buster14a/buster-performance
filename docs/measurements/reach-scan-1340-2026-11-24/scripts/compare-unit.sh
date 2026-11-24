#!/bin/bash
# One unit, base against head, under one warning set: the objects, stderr and exit status must be the same, both
# compilers run from the same directory; then head again under the reach filter's audit, which must not fail where the
# plain compile doesn't. Arguments: BASE HEAD OUT SET INDEX -- compiler arguments. Prints one line.
base=$1; head=$2; out=$3; set_name=$4; index=$5; shift 6
case $set_name in
    default) extra=() ;;
    wall) extra=(-Wall -Wextra) ;;
    families) extra=(-Wall -Wextra -Wsign-compare -Wdouble-promotion -Wimplicit-int-float-conversion -Wfloat-conversion) ;;
    float-conversion) extra=(-Wfloat-conversion) ;;
    implicit-float) extra=(-Wimplicit-float-conversion) ;;
    self-assign) extra=(-Wself-assign -Wsign-compare) ;;
    float-precision) extra=(-Wimplicit-float-conversion -Wno-implicit-int-float-conversion) ;;
esac
d=$out/$set_name/$index
mkdir -p "$d"
"$base" --lanes 1 -c "${extra[@]}" "$@" -o "$d/base.o" > "$d/base.out" 2> "$d/base.err"; bs=$?
"$head" --lanes 1 -c "${extra[@]}" "$@" -o "$d/head.o" > "$d/head.out" 2> "$d/head.err"; hs=$?
BUSTER_TEST_COMMON_REACH_AUDIT=$out/$set_name.audit "$head" --lanes 1 -c "${extra[@]}" "$@" -o "$d/audit.o" > "$d/audit.out" 2> "$d/audit.err"; as=$?
verdict=same
[ $bs -eq $hs ] || verdict=status
cmp -s "$d/base.err" "$d/head.err" || verdict=stderr
cmp -s "$d/base.out" "$d/head.out" || verdict=stdout
if [ -e "$d/base.o" ] || [ -e "$d/head.o" ]; then cmp -s "$d/base.o" "$d/head.o" || verdict=object; fi
[ $as -eq $hs ] && cmp -s "$d/audit.err" "$d/head.err" || verdict=audit
object=no; [ -e "$d/head.o" ] && object=yes
echo "$verdict $set_name $index status=$hs object=$object diagnostics=$(grep -c 'warning:\|error:' "$d/head.err") ${*: -1}"
if [ $verdict = same ]; then rm -rf "$d"; fi
