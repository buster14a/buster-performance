#!/bin/bash
# blocks.sh FILE PATTERN...: the blocks of a correctness list whose headings match any PATTERN (extended regex).
file=$1; shift
pattern=$(IFS='|'; echo "$*")
awk -v p="$pattern" '/^== /{keep = ($0 ~ p)} keep' "$file"
