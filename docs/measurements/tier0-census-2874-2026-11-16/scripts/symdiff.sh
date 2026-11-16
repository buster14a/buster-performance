#!/bin/bash
# symdiff.sh BASE HEAD: the text symbols whose sizes differ between results/BASE/compiler and results/HEAD/compiler: for
# each name, its sizes in each executable (a unity build has a name once a unit), sorted; a name with other sizes, or
# in one executable alone, is printed. No lock: two nm's. results/HEAD/symdiff.txt.
cd "$(dirname "$0")"
sizes()
{
    nm -S "$1" | awk 'NF == 4 && ($3 == "t" || $3 == "T") { print $4, $2 }' | sort | awk '{ if ($1 != name) { if (name != "") print name, list; name = $1; list = $2 } else list = list "," $2 } END { if (name != "") print name, list }'
}
sizes "results/$1/compiler" > scratch/symbols-$1.txt
sizes "results/$2/compiler" > scratch/symbols-$2.txt
{
    echo "text symbols by name: $(wc -l < scratch/symbols-$1.txt) in $1, $(wc -l < scratch/symbols-$2.txt) in $2"
    join -a 1 -a 2 -e - -o 0,1.2,2.2 scratch/symbols-$1.txt scratch/symbols-$2.txt | awk '$2 != $3 { print }'
} > "results/$2/symdiff.txt"
wc -l < "results/$2/symdiff.txt"
