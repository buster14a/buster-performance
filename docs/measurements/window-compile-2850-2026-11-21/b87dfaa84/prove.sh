#!/bin/bash
set -eu
cd "$(dirname "$0")"
for item in probe sqlite main;do
  for mode in ordinary source prior;do
    envs=(CHAIN_MODE="$mode" BUSTER_CHAIN_GRAPH=1 BUSTER_CHAIN_POISON=1)
    case $mode in source) envs+=(BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_EARLY_NATIVE=1 BUSTER_CONTROL_EARLY_RELEASE=1 BUSTER_CONTROL_EARLY_POISON=1);; prior) envs+=(CHAIN_LEGACY=1);; esac
    env "${envs[@]}" bash run.sh "$item"
  done
done
