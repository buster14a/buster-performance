
size_t K(count_eq_u8)(const uint8_t* a, size_t n, uint8_t v);
int K(count_gt_i32)(const int32_t* a, int n, int v);
int K(count_lt_i8)(const int8_t* a, int n, int8_t v);
size_t K(count_ge_u16)(const uint16_t* a, unsigned n, uint16_t v);
int K(count_ne_i64)(const int64_t* a, long n, int64_t v);
int K(count_two)(const uint8_t* a, const uint8_t* b, int n);
int K(count_sext_u8)(const uint8_t* a, int n);
int K(count_mixed)(const int8_t* a, const uint8_t* b, int n);

int K(aos_sum)(const P2* p, int n);
long K(aos_x)(const P2* p, long n);
void K(rgb_to_gray)(uint8_t* out, const uint8_t* rgb, int n);
void K(pairs_i16)(int16_t* out, const int16_t* in, int n);
int K(stride8_u8)(const uint8_t* a, int n);
long K(stride8_i64)(const int64_t* a, long n);
int K(stride5_i32)(const int32_t* a, int n);
int K(stride3_u16)(const uint16_t* a, int n);
int K(stride9_u8)(const uint8_t* a, int n);
int K(neg_stride)(const int32_t* a, int n);
int K(neg_stride_u8)(const uint8_t* a, int n);
int K(ptr_stride)(const int16_t* p, int n);
void K(strided_store)(int32_t* out, const int32_t* in, int n);
void K(gather_add)(int32_t* out, const int32_t* in, int n);
int K(idx_s32)(const uint8_t* a, int lo, int hi);
int K(idx_u32)(const uint8_t* a, unsigned lo, unsigned hi);
int K(idx_u32_i32)(const int32_t* a, unsigned lo, unsigned hi);
int K(idx_s32_neg)(const uint8_t* a, int lo, int hi);
void K(idx_copy_u32)(uint8_t* o, const uint8_t* a, unsigned lo, unsigned hi);
