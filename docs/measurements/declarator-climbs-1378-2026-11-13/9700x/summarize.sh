#!/bin/bash
cd ~/buster-fast-bench/1378-claude/out
med() { sort -n | awk '{a[NR]=$1} END{if(NR) printf "%.2f", a[int((NR+1)/2)]; else printf "?"}'; }
printf '%-12s %-5s %9s %9s %9s %9s %s\n' input build wall total chk-input chk-prog "runs/exits"
for inp in small file_64 local_64 file_4000 local_4000 file_8000 local_8000 file_16000 local_16000; do
  for v in base fix main; do
    w=$(awk '$1=="wall"{print $2}' $v.$inp.* | med)
    t=$(awk -F'\t' '$1=="time-stage"&&$2=="total"{print $3}' $v.$inp.* | med)
    ci=$(awk -F'\t' '$1=="time-stage"&&$2=="check-input"{print $3}' $v.$inp.* | med)
    cp=$(awk -F'\t' '$1=="time-stage"&&$2=="check-program"{print $3}' $v.$inp.* | med)
    printf '%-12s %-5s %9s %9s %9s %9s %s\n' $inp $v $w $t $ci $cp "$(ls $v.$inp.* | wc -l)/$(grep -h '^exit' $v.$inp.* | sort | uniq -c | xargs)"
  done
done
