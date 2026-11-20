extern int puts(const char*);
int start_here(int argc, char** argv, char** envp)
{
    if (argc != 1 || argv[1] != 0 || envp[0] != 0 || argv[0][0] != 'p')
    {
        return 1;
    }
    puts("entered main alias");
    return 31;
}
int main(int, char**, char**) __attribute__((alias("start_here")));
