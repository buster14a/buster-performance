#!/bin/sh
# usage: summary.sh OUT -- medians of check-input, total, peak RSS
cd $HOME/buster-fast-bench/3307-claude/$1
for f in *.stages; do
  ci=$(awk '$1=="time-stage" && $2=="check-input" {print $3}' $f | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}')
  pa=$(awk '$1=="time-stage" && $2=="parse" {print $3}' $f | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}')
  tot=$(awk '$1=="time-stage" && $2=="total" {print $3}' $f | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}')
  rss=$(awk '$1=="time-process" && $2=="peak-rss-kb" {print $3}' $f | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}')
  lazy=$(grep -m1 -o "planner=[a-z]*" $f)
  echo "$f parse=$pa check-input=$ci total=$tot peak-rss-kb=$rss $lazy"
done
