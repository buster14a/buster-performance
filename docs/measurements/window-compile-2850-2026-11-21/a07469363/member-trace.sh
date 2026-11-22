#!/bin/bash
set -eu
cd "$(dirname "$0")"
q="$PWD/sqlite-members.tsv"
printf 'closing-token\tbody-node\top\tparser-member-token\tpp-row\tpp-location\tbase-type\trecord-type\tcanonical-name-id\tspelling\tmember-slot\tresult-type\toffset-bits\tbit-width\toperand-conversion-flags\n' > "$q"
BUSTER_CONTROL_MEMBER_TRACE="$q" bash ./run.sh sqlite
