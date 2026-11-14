#!/bin/bash
# all_units.sh PRESPLIT TAG [OPTIONS...]: inline_diff.sh over every main.c unit, into id/TAG/UNIT.
W=~/.cache/claude-2559; presplit=$1; tag=$2; shift 2
for unit in ${UNITS:-main_unit_assembler main_unit_x86 main_unit_link main_unit_dynamic main_unit_types main_unit_check_builtins main_unit_executable main main_unit_frontend main_unit_backend main_unit_checker}; do
  case $unit in main_unit_checker) n=48;; main_unit_backend) n=32;; main_unit_frontend) n=16;; *) n=8;; esac
  printf '%s: ' $unit; $W/inline_diff.sh $W/bc/$unit.bc $n $presplit $W/id/$tag/$unit "$@"
done
