#!/bin/bash
# job-short.sh LABEL PATCH [READINGS]: as job.sh without the profiles: the build, then the window (--front-window)
# alone, READINGS readings a corpus (default 3).
cd "$(dirname "$0")"
label=$1; patch=$2; readings=${3:-3}
head=eb0a76e21697c047d97f6efeb046b26691ea1e64
./build-label.sh "$label" $head "$patch" || exit 1
./turns.sh "" "$readings" "sqlite3 lua musl" "$label window --shadow --passes 0 --front-window" || exit 1
echo job finished
