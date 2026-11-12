#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
# (the all-core record's lock.sh with this re-measurement's owner, title and link)
export EXCLUSIVE_OWNER="claude-2536-rerun" EXCLUSIVE_TITLE="#2536: the all-core record measured again without #2555's stray" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxneK8P8UJcssRTAm46g"
exec ~/buster-fast-bench/exclusive.sh "$@"
