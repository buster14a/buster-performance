// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_RECEIPT_H
#define BUSTER_HP_RECEIPT_H

#include "hp_common.h"
#include "hp_linked.h"

// Serialize successful, unmodified proof records. These functions do not run
// or replace their gates. Borrowed proof names must remain valid throughout.
// Creation is exclusive; flush, stream errors and close are all checked.
// Failure retains a possibly partial file and must never be treated as proof.
bool hp_receipt_object(const char *path, const HpObjectProof *proof, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_receipt_linked(const char *path, const HpLinkedProof *proof, char error[BUSTER_HP_ERROR_CAPACITY]);
// Record a file identity already established by the caller; this helper does
// not read/hash image. Identity is not an executable semantic proof. digest is
// exactly 64 lowercase hex bytes followed by NUL.
bool hp_receipt_identity(const char *path, const char *image, const char *digest, const char *scope, char error[BUSTER_HP_ERROR_CAPACITY]);

#endif
