float one_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*(1.25f)+x; }
float one_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (1.25f)*(c[z+1])+x; }
float minuszero_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*(-0.0f)+x; }
float minuszero_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (-0.0f)*(c[z+1])+x; }
float infinity_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*(__builtin_inff())+x; }
float infinity_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (__builtin_inff())*(c[z+1])+x; }
float qnan_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*(__builtin_nanf("0x321"))+x; }
float qnan_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (__builtin_nanf("0x321"))*(c[z+1])+x; }
float snan_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*(__builtin_nansf("0x321"))+x; }
float snan_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (__builtin_nansf("0x321"))*(c[z+1])+x; }
float neginf_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*(-__builtin_inff())+x; }
float neginf_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (-__builtin_inff())*(c[z+1])+x; }
float int32_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*((float)(int)u)+x; }
float int32_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(int)u)*(c[z+1])+x; }
float uint32_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*((float)(unsigned int)u)+x; }
float uint32_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(unsigned int)u)*(c[z+1])+x; }
float int64_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*((float)(long long)u)+x; }
float int64_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(long long)u)*(c[z+1])+x; }
float uint64_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*((float)(unsigned long long)u)+x; }
float uint64_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return ((float)(unsigned long long)u)*(c[z+1])+x; }
float square_left_f(float x,unsigned long long u,const float *c,unsigned long z) { return (c[z+1])*(x)+x; }
float square_right_f(float x,unsigned long long u,const float *c,unsigned long z) { return (x)*(c[z+1])+x; }
double one_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*(1.25)+x; }
double one_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (1.25)*(c[z+1])+x; }
double minuszero_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*(-0.0)+x; }
double minuszero_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (-0.0)*(c[z+1])+x; }
double infinity_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*(__builtin_inf())+x; }
double infinity_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (__builtin_inf())*(c[z+1])+x; }
double qnan_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*(__builtin_nan("0x321"))+x; }
double qnan_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (__builtin_nan("0x321"))*(c[z+1])+x; }
double snan_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*(__builtin_nans("0x321"))+x; }
double snan_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (__builtin_nans("0x321"))*(c[z+1])+x; }
double neginf_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*(-__builtin_inf())+x; }
double neginf_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (-__builtin_inf())*(c[z+1])+x; }
double int32_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*((double)(int)u)+x; }
double int32_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(int)u)*(c[z+1])+x; }
double uint32_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*((double)(unsigned int)u)+x; }
double uint32_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(unsigned int)u)*(c[z+1])+x; }
double int64_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*((double)(long long)u)+x; }
double int64_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(long long)u)*(c[z+1])+x; }
double uint64_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*((double)(unsigned long long)u)+x; }
double uint64_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return ((double)(unsigned long long)u)*(c[z+1])+x; }
double square_left_d(double x,unsigned long long u,const double *c,unsigned long z) { return (c[z+1])*(x)+x; }
double square_right_d(double x,unsigned long long u,const double *c,unsigned long z) { return (x)*(c[z+1])+x; }
