// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Harness-only plumbing. These reduced structs, representative token numbers and
// small intern implementation are stubs; this does not build the production driver.
// The extractor appends the current production comparison/bitmap helpers and controls.
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a)/sizeof((a)[0]))
#define BUSTER_PP_NONE UINT32_MAX
#define C_TOKEN_RAW_IDENTIFIER 5
#define C_TOKEN_NUMERIC_CONSTANT 7
#define BUSTER_PP_KIND_KEYWORD 64
#define BUSTER_PP_KIND_PRAGMA_END 200
#define C_NAME_INT 1
static bool pp_test_quiet;
typedef uint32_t IdentId;
typedef struct InternTable { uint32_t count; char names[16][64]; } InternTable;
static bool intern_initialize(InternTable* t) { memset(t,0,sizeof(*t)); strcpy(t->names[1],"int"); strcpy(t->names[2],"long"); t->count=3; return true; }
static void intern_release(InternTable* t) { (void)t; }
static const uint8_t* intern_bytes(const InternTable* t, IdentId id) { return (const uint8_t*)t->names[id]; }
static uint32_t intern_length(const InternTable* t, IdentId id) { return (uint32_t)strlen(t->names[id]); }
static IdentId intern_find_or_add(InternTable* t,const uint8_t* text,uint32_t n) { for(uint32_t i=1;i<t->count;i++) if(strlen(t->names[i])==n && memcmp(t->names[i],text,n)==0) return i; if(t->count==16 || n>=64) return 0; uint32_t id=t->count++; memcpy(t->names[id],text,n); t->names[id][n]=0; return id; }
typedef struct FilesTestUnit { uint8_t* kinds; uint8_t* flags; uint32_t* values; uint32_t* locations; uint32_t count; uint32_t errors; uint32_t warnings; bool ran; } FilesTestUnit;
typedef struct FilesTestWork { const char* name; } FilesTestWork;
typedef struct PPFileData { uint32_t record; bool prepared; } PPFileData;
