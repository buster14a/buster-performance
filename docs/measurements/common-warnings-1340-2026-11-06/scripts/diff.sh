cd ~/buster-fast-bench/1340-droid
ls prof2; cat prof2/holds.txt
# samples.txt lines: "  SAMPLES  [.] sym" ; ms per compile = samples * 50021 cycles / 5.55e9 Hz... use sample counts directly
awk 'FNR==1{f++} {s=$1; $1=""; $2=""; sub(/^ +/, ""); n[$0]; v[f, $0]=s} END {for (k in n) printf "%s\t%d\t%d\t%d\n", k, v[1,k], v[2,k], v[3,k]}' prof/pre1049-znver5.samples.txt prof/main-znver5.samples.txt prof2/znver5.samples.txt | sort -t$'\t' -k4,4nr > prof2/diff-samples.tsv
awk -F'\t' '{p+=$2; m+=$3; h+=$4} END {print "total", p, m, h}' prof2/diff-samples.tsv
awk -F'\t' '{d=$4-$2; print d "\t" $0}' prof2/diff-samples.tsv | sort -k1,1nr | head -25
