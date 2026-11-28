typedef int (*lua_CFunction)(void *);
void *dlsym(void *, const char *);
lua_CFunction lsys_sym(void *lib, const char *sym) {
  lua_CFunction f = (__extension__ (lua_CFunction)(dlsym(lib, sym)));
  return f;
}
