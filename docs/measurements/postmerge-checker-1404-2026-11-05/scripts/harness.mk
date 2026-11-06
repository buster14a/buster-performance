# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
CC = clang
CFLAGS = -O2 -Wall -Wextra -Werror
.PHONY: all
all: scripts/policy_balanced scripts/usage_record
scripts/policy_balanced: scripts/policy_balanced.c
	$(CC) $(CFLAGS) $< -o $@
scripts/usage_record: scripts/usage_record.c
	$(CC) $(CFLAGS) $< -o $@
