#!/bin/bash
# One file through the pull request's compiler with its direct path and with --no-direct: prints a class line.
P=$1; f=$2; t=$(mktemp -d)
a=$(LLVM_PROFILE_FILE=/dev/null timeout 60 "$P" -c "$f" -o "$t/a.o" 2>&1; echo "status=$?")
b=$(LLVM_PROFILE_FILE=/dev/null timeout 60 "$P" --no-direct -c "$f" -o "$t/b.o" 2>&1; echo "status=$?")
sa=${a##*status=}; sb=${b##*status=}
wa=$(printf '%s\n' "$a" | grep -c 'warning:'); wb=$(printf '%s\n' "$b" | grep -c 'warning:')
ea=$(printf '%s\n' "$a" | grep -c 'error:'); eb=$(printf '%s\n' "$b" | grep -c 'error:')
same=$([ "$a" = "$b" ] && echo same || echo DIFF)
obj=none; if [ -f "$t/a.o" ] && [ -f "$t/b.o" ]; then cmp -s "$t/a.o" "$t/b.o" && obj=same || obj=differs; fi
echo "$same direct:status=$sa,w=$wa,e=$ea full:status=$sb,w=$wb,e=$eb objects=$obj $f"
rm -rf "$t"
