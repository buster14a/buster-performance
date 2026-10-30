// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_COMMON_H
#define BUSTER_HP_COMMON_H

#include "hp_elf.h"
#include <stdio.h>
#include <sys/types.h>

#define BUSTER_HP_PATH_CAPACITY 4096
#define BUSTER_HP_ARGUMENT_LIMIT 4096
#define BUSTER_HP_FILE_LIMIT ((size_t)512 * 1024 * 1024)

typedef struct HpBuffer HpBuffer;
struct HpBuffer
{
    unsigned char* data;
    size_t size;
};

typedef struct HpArguments HpArguments;
struct HpArguments
{
    char* storage;
    char** values;
    size_t count;
};

bool hp_error(char error[BUSTER_HP_ERROR_CAPACITY], const char* format, ...);
bool hp_read_file(const char* path, size_t limit, HpBuffer* output, char error[BUSTER_HP_ERROR_CAPACITY]);
void hp_buffer_free(HpBuffer* buffer);
bool hp_write_file(const char* path, HpBytes bytes, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_join_path(char output[BUSTER_HP_PATH_CAPACITY], const char* directory, const char* name, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_mkdir_new(const char* path, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_files_equal(const char* a, const char* b, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_sha256_file(const char* path, char digest[65], char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_arguments_read(HpBytes input, HpArguments* arguments, char error[BUSTER_HP_ERROR_CAPACITY]);
void hp_arguments_free(HpArguments* arguments);
bool hp_record_arguments(const char* path, const char* const* arguments, char error[BUSTER_HP_ERROR_CAPACITY]);
pid_t hp_spawn(const char* const* arguments, const char* directory, const char* stdout_path, const char* stderr_path, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_wait(pid_t child, int* code, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_run(const char* const* arguments, const char* directory, const char* stem, bool split_stderr, int* code, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_prepare_environment(const char* toolchain, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_verify_sources(const char* tree, const char* manifest, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_validate_flags(const HpArguments* flags, char error[BUSTER_HP_ERROR_CAPACITY]);
void hp_json_string(FILE* output, HpString text);

#endif
