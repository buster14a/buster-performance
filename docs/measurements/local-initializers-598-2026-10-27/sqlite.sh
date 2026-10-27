#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
input="$corpus/sqlite/sqlite3.c"
sha256sum "$input" > sqlite.sha256
for variant in base head; do
    cat > "$variant-sqlite" <<SCRIPT
#!/usr/bin/env bash
exec "\$(dirname "\$0")/../$variant/build/compiler" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "\$@"
SCRIPT
    chmod +x "$variant-sqlite"
done
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
mkdir -p logs-aa logs-sqlite
./compile ./base-sqlite ./base-sqlite "$input" sqlite 0 logs-aa default > sqlite-aa.log
./compile ./base-sqlite ./head-sqlite "$input" sqlite 0 logs-sqlite default > sqlite-default.log
./summarize sqlite-aa.log logs-aa > sqlite-aa.csv
./summarize sqlite-default.log logs-sqlite > sqlite-default.csv
