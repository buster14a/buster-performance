#!/bin/bash
# tables.sh: the record's tables from results/: the shape's sites in main's and head's objects with the census's reasons,
# the conditions by what their branch takes, the objects' instructions and bytes, and the joins. Run in the record's
# directory. No lock.
cd "$(dirname "$0")"
[ -d results ] || cd ..
field() { sed -n "s/^$2: .*[;:] \([0-9]*\) $3.*/\1/p" "results/$1/shapes.txt"; }
echo "the shape (setCC %al; movzbl %al,%eax; test %eax,%eax; je or jne), sites in the objects, and head's by the census's reasons"
printf '%-8s %8s %8s %8s | %8s %8s %8s %8s %8s\n' corpus main head "left %" census third target class other
for c in sqlite3 lua musl; do
    m=$(sed -n "s/^$c: .*branches; \([0-9]*\) compares tested again.*/\1/p" results/main/shapes.txt)
    h=$(sed -n "s/^$c: .*branches; \([0-9]*\) compares tested again.*/\1/p" results/head/shapes.txt)
    line=$(grep -a 'tested again:' results/head/census-$c.txt)
    total=$(echo "$line" | sed 's/.*tested again: \([0-9]*\) sites.*/\1/')
    third=$(echo "$line" | sed 's/.*: \([0-9]*\) a third test in a row.*/\1/')
    target=$(echo "$line" | sed 's/.*; \([0-9]*\) a jump.s target.*/\1/')
    class=$(echo "$line" | sed 's/.*; \([0-9]*\) a compare of a class.*/\1/')
    other=$(echo "$line" | sed 's/.*; \([0-9]*\) other.*/\1/')
    printf '%-8s %8d %8d %8.2f | %8d %8d %8d %8d %8d\n' "$c" "$m" "$h" "$(echo "100 * $h / $m" | bc -l)" "$total" "$third" "$target" "$class" "$other"
done
echo
echo "head's conditional branches by what their group takes (measure-tier0-entries)"
for c in sqlite3 lua musl all; do printf '%-8s %s\n' "$c" "$(grep -a 'conditions:' results/head/census-$c.txt | sed 's/^tier0-census: conditions: //')"; done
echo
echo "the objects"
printf '%-8s %-5s %12s %10s %12s %12s %10s\n' corpus label instructions branches "text bytes" "file bytes" eh_frame
for c in sqlite3 lua musl; do
    for l in main head; do
        i=$(sed -n "s/^$c: \([0-9]*\) instructions.*/\1/p" results/$l/shapes.txt)
        b=$(sed -n "s/^$c: [0-9]* instructions, \([0-9]*\) conditional branches.*/\1/p" results/$l/shapes.txt)
        awk -v c="$c" -v l="$l" -v i="$i" -v b="$b" '$1 == c { printf "%-8s %-5s %12d %10d %12d %12d %10d\n", c, l, i, b, $9, $5, $13 }' results/$l/objects.txt
    done
done
echo
echo "beside the shape: a local updated through rax, and a constant made and tested (of them after a jmp)"
for l in main head; do sed "s/^\([a-z0-9]*\): .*; updated through rax/$l \1: updated through rax/" results/$l/shapes.txt; done
echo
echo "the joins of && and || used as conditions"
for l in main head; do sed "s/^/$l /" results/$l/joins.txt; done
echo
echo "#2874's line (a key of 8 bytes or fewer, no conflict), head"
for c in sqlite3 lua musl all; do grep -a ': gate:' results/head/census-$c.txt | sed "s/^tier0-census: /$c /; s/, its tables.*//"; done
