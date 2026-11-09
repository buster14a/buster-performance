#!/bin/sh
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Verify public package/container integrity only. No compiler workload runs.
set -eu
cd "$(dirname "$0")"
sha256sum --check --strict SHA256SUMS
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT HUP INT TERM
for archive in timing-records.tar.gz wait-records.tar.gz independent-audits.tar.gz failures-and-history.tar.gz
do
    tar -tzf "$archive" > "$temporary/members"
    if LC_ALL=C grep -E '(^/|(^|/)\.\.(/|$))' "$temporary/members" >/dev/null
    then
        echo 'Unsafe archive member path' >&2
        exit 1
    fi
    if LC_ALL=C sort "$temporary/members" | uniq -d | grep . >/dev/null
    then
        echo 'Duplicate archive member' >&2
        exit 1
    fi
    tar -tvzf "$archive" | awk 'substr($0,1,1) != "-" && substr($0,1,1) != "d" { bad=1 } END { exit bad }'
    mkdir "$temporary/extracted"
    tar -xzf "$archive" --no-same-owner --no-same-permissions -C "$temporary/extracted"
    (cd "$temporary/extracted" && sha256sum --check --strict SHA256SUMS)
    rm -rf "$temporary/extracted"
done
echo 'Public package hashes and safe member types/paths verified.'
echo 'Full native audit replay still requires retained originals, binaries, external inputs and reference objects.'
