#!/bin/bash
set -euo pipefail
cd /home/david/Documents/Codex/2026-10-26/claim-and-solve-three-buster-performance
remote=/home/david/buster-fast-bench/codex-449-450-451-20261026
scp work/campaign/corpus450-cold.sh work/campaign/corpus450-cold-held.sh david@benchpress:"$remote/"
ssh david@benchpress "EXCLUSIVE_OWNER=codex-449-450-451 EXCLUSIVE_TITLE='Cold450 confirmatory: five complete paired corpus rounds, approved60s cap' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450 /home/david/buster-fast-bench/exclusive.sh bash $remote/corpus450-cold-held.sh"
ssh david@benchpress "EXCLUSIVE_OWNER=codex-449-450-451 EXCLUSIVE_TITLE='Collect full paired450 corpus evidence' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450 /home/david/buster-fast-bench/exclusive.sh tar -C $remote -cf - logs/450-cold-corpus corpus450-cold.sh corpus450-cold-held.sh" > work/campaign/450-cold-corpus-raw.tar 2> work/campaign/450-cold-corpus-collection.log
