int run_x86_semantics_benchmark(int argument_count, char** arguments);
int main(int argument_count, char** arguments)
{
    return run_x86_semantics_benchmark(argument_count - 1, arguments + 1);
}
