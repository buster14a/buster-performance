#!/bin/bash
# chain.sh: extra.sh once final.sh has finished.
cd "$(dirname "$0")"
until grep -q finished final.done 2> /dev/null; do sleep 5; done
./extra.sh
