#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
clang -std=c17 -O2 -Wall -Wextra -Werror -shared -fPIC rss_probe.c -o rss_probe.so
for variant in base head; do
    BUSTER_RSS_RECORD="$PWD/$variant-smaps.txt" LD_PRELOAD="$PWD/rss_probe.so" ../"$variant"/build/compiler --lanes 1 --time-stages -c cases/string-128.c -o /dev/null > "$variant-rss.txt" 2>&1
    readelf -SW ../"$variant"/build/compiler > "$variant-sections.txt"
done
