extern int ext(int);
int dispatch(int x) { switch (x) { case -2: return 41; case -1: return ext(16); case 0: return 4; case 1: return -71; case 2: return ext(x); case 3: return 17; default: return -4; } }
int other(int z) { switch(z) { case 1:return 9; case 3: return 17; case 4: return ext(z + 2); case 6: return 81; case 7: return 6; default: return 201; } }
int ind(int k) { return dispatch(k)+other(k*3); }
