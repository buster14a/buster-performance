#!/bin/bash
# one.sh COMPILER MODE TAG FILE [FLAGS...]: the unit through the driver's -c as written, and its full preprocessor's -E -P
# output compiled again under the same name in a scratch directory; prints
# TAG MODE FILE status-a path-a status-b path-b same|differ|- (objects compared where both paths wrote one)
P=$1; mode=$2; tag=$3; f=$4; shift 4
t=$(mktemp -d /dev/shm/ppeq.XXXXXX)
b=$(basename "$f")
d=$(dirname "$f")
(cd "$d" && LLVM_PROFILE_FILE=/dev/null timeout 60 "$P" $mode "$@" -c "$b" -o "$t/a.o" 2>"$t/a.err" < /dev/null); sa=$?
pa=none; [ -f "$t/a.o" ] && { grep -qa 'buster direct' "$t/a.o" && pa=direct || pa=full; }
mkdir "$t/b"
(cd "$d" && LLVM_PROFILE_FILE=/dev/null timeout 60 "$P" $mode "$@" -E -P "$b" -o "$t/b/$b" 2>/dev/null < /dev/null); se=$?
sb=-; pb=none
if [ $se -eq 0 ]; then
  (cd "$t/b" && LLVM_PROFILE_FILE=/dev/null timeout 60 "$P" $mode "$@" -c "$b" -o "$t/b.o" 2>"$t/b.err" < /dev/null); sb=$?
  [ -f "$t/b.o" ] && { grep -qa 'buster direct' "$t/b.o" && pb=direct || pb=full; }
fi
cmpr=-
if [ "$pa" = direct ] && [ "$pb" = direct ]; then cmp -s "$t/a.o" "$t/b.o" && cmpr=same || cmpr=differ; fi
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$tag" "$mode" "$f" "$sa" "$pa" "$sb" "$pb" "$cmpr"
rm -rf "$t"
