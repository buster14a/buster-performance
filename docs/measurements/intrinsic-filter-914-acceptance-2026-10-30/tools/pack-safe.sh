#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-acceptance-20261030"
mkdir -p assets
profiles=(base-safe-p1 base-safe-p2 base-safe-p3-retry head-safe-p1 head-safe-p2 head-safe-p3-retry)
for profile in "${profiles[@]}"; do
        artifact="results/$profile.perf.data"
        # Never publish inherited-environment smoke/old captures. Only this
        # explicit six-file whitelist, recorded under env -i, is eligible.
        if LC_ALL=C grep -qaE '(github_pat_[A-Za-z0-9_]{20}|gh[pousr]_[A-Za-z0-9]{20}|tskey-auth-[A-Za-z0-9-]{16}|sk-[A-Za-z0-9]{24})' "$artifact"; then
            printf 'credential-pattern check rejected %s\n' "$artifact" >&2
            exit 1
        fi
        sha256sum "$artifact"
        zstd -q -T1 -3 -f "$artifact" -o "assets/$profile.perf.data.zst"
done
sha256sum assets/base-safe-p1.perf.data.zst assets/base-safe-p2.perf.data.zst assets/base-safe-p3-retry.perf.data.zst assets/head-safe-p1.perf.data.zst assets/head-safe-p2.perf.data.zst assets/head-safe-p3-retry.perf.data.zst
printf 'explicit safe-profile whitelist and credential-pattern check passed\n'
