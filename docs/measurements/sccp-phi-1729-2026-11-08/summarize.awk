NF==5 && $5==0 && $4 ~ /^[0-9]+$/ {v[$1" "$2]=v[$1" "$2]" "$4}
END {for (k in v) {n=split(substr(v[k],2),a," "); asort(a); printf "%s min=%.1f med=%.1f n=%d\n", k, a[1]/1000, a[int((n+1)/2)]/1000, n}}
