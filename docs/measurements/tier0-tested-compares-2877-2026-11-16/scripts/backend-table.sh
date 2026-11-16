#!/bin/bash
# backend-table.sh: benchmark-backend-source's runs (backend.sh's) as a table: for each corpus and label, the corpus's
# typed entries, records and code bytes, and the median over the runs of each timed variant's cycles and instructions an
# entry (the vector path, branch sizing, the encoder, the form choice) and of the vector path's cycles a record. Run in
# the record's directory (results/LABEL/backend-CORPUS-N.txt). No lock.
cd "$(dirname "$0")"
[ -d results ] || cd ..
printf '%-8s %-5s %9s %9s %9s %5s | %9s %9s %9s | %8s %8s %8s\n' corpus label entries records bytes runs "vec cyc/e" "vec ins/e" "vec cyc/r" "size c/e" "enc c/e" "choose"
for c in sqlite3 lua musl; do
    for l in main head; do
        ls results/$l/backend-$c-*.txt > /dev/null 2>&1 || continue
        cat results/$l/backend-$c-*.txt | awk -v c="$c" -v l="$l" '
            function median(v, n,    i, j, t) { for (i = 2; i <= n; i += 1) { t = v[i]; for (j = i - 1; j >= 1 && v[j] > t; j -= 1) v[j + 1] = v[j]; v[j + 1] = t } return n % 2 ? v[(n + 1) / 2] : (v[n / 2] + v[n / 2 + 1]) / 2 }
            /^benchmark-backend-source: [0-9]+ functions/ { entries = $4; records = $7; for (i = 1; i <= NF; i += 1) if ($(i + 1) ~ /^bytes;/) bytes = $i; runs += 1 }
            $1 == "vector" { vc[++nv] = $3; vi[nv] = $4; vr[nv] = $6 }
            $1 == "sizing" { sc[++ns] = $3 }
            $1 == "encode" { ec[++ne] = $3 }
            $1 == "choose" { cc[++nc] = $3 }
            END { printf "%-8s %-5s %9d %9d %9d %5d | %9.2f %9.2f %9.2f | %8.2f %8.2f %8.2f\n", c, l, entries, records, bytes, runs, median(vc, nv), median(vi, nv), median(vr, nv), median(sc, ns), median(ec, ne), median(cc, nc) }'
    done
done
