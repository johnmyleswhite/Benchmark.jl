using Benchmark

tests = ["benchmarks.jl", "compare.jl", "consistency.jl"]

@printf "Running tests:\n"

for t in tests
    include(t)
    @printf " * %s\n" t
end
