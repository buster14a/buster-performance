#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-672-wb" EXCLUSIVE_TITLE="#672: where a whole build's time goes beyond -c (-g and linking)" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxnfFPBGjgSsBZ6qE3Fy"
exec ~/buster-fast-bench/exclusive.sh "$@"
