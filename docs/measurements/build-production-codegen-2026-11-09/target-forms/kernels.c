#include <stdio.h>
#include <assert.h>
#include "buster/compiler/x86_64_encoder.c"
#if BUSTER_PROBE_MODE == 0
#define BUSTER_X86_TARGET_DATA_ELSEWHERE
#elif BUSTER_PROBE_MODE == 1
#define BUSTER_X86_TARGET_DATA __attribute__((visibility("hidden")))
#endif
#include FORMS_INPUT
uint32_t probe_compact(uint64_t features) { return x86_target_compact_features(features); }
uint64_t probe_requirement(uint32_t form) { return x86_target_requirement(form); }
void probe_forms(const X86Target* target, uint8_t* allowed) { x86_target_forms(target, allowed); }
void probe_forms_scalar(const X86Target* target, uint8_t* allowed) { x86_target_forms_scalar(target, allowed); }
bool probe_allowed(const uint8_t* allowed, uint32_t form) { return x86_target_form_allowed(allowed, form); }
uint32_t probe_validate(const uint8_t* allowed, const X86Instruction* instructions, uint32_t count) { return x86_target_validate(allowed, instructions, count); }
