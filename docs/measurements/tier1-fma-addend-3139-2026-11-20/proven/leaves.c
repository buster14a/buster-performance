float one_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (1.25f)*(x)+c[z+1]; }
float one_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(1.25f)+c[z+1]; }
float minuszero_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (-0.0f)*(x)+c[z+1]; }
float minuszero_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(-0.0f)+c[z+1]; }
float infinity_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (__builtin_inff())*(x)+c[z+1]; }
float infinity_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(__builtin_inff())+c[z+1]; }
float qnan_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (__builtin_nanf("0x321"))*(x)+c[z+1]; }
float qnan_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(__builtin_nanf("0x321"))+c[z+1]; }
float snan_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (__builtin_nansf("0x321"))*(x)+c[z+1]; }
float snan_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(__builtin_nansf("0x321"))+c[z+1]; }
float neginf_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (-__builtin_inff())*(x)+c[z+1]; }
float neginf_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(-__builtin_inff())+c[z+1]; }
float int32_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(int)u)*(x)+c[z+1]; }
float int32_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*((float)(int)u)+c[z+1]; }
float uint32_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(unsigned int)u)*(x)+c[z+1]; }
float uint32_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*((float)(unsigned int)u)+c[z+1]; }
float int64_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(long long)u)*(x)+c[z+1]; }
float int64_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*((float)(long long)u)+c[z+1]; }
float uint64_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(unsigned long long)u)*(x)+c[z+1]; }
float uint64_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*((float)(unsigned long long)u)+c[z+1]; }
float square_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(x)+c[z+1]; }
float square_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(x)+c[z+1]; }
double one_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (1.25)*(x)+c[z+1]; }
double one_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(1.25)+c[z+1]; }
double minuszero_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (-0.0)*(x)+c[z+1]; }
double minuszero_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(-0.0)+c[z+1]; }
double infinity_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (__builtin_inf())*(x)+c[z+1]; }
double infinity_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(__builtin_inf())+c[z+1]; }
double qnan_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (__builtin_nan("0x321"))*(x)+c[z+1]; }
double qnan_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(__builtin_nan("0x321"))+c[z+1]; }
double snan_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (__builtin_nans("0x321"))*(x)+c[z+1]; }
double snan_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(__builtin_nans("0x321"))+c[z+1]; }
double neginf_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (-__builtin_inf())*(x)+c[z+1]; }
double neginf_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(-__builtin_inf())+c[z+1]; }
double int32_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(int)u)*(x)+c[z+1]; }
double int32_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*((double)(int)u)+c[z+1]; }
double uint32_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(unsigned int)u)*(x)+c[z+1]; }
double uint32_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*((double)(unsigned int)u)+c[z+1]; }
double int64_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(long long)u)*(x)+c[z+1]; }
double int64_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*((double)(long long)u)+c[z+1]; }
double uint64_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(unsigned long long)u)*(x)+c[z+1]; }
double uint64_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*((double)(unsigned long long)u)+c[z+1]; }
double square_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(x)+c[z+1]; }
double square_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(x)+c[z+1]; }
