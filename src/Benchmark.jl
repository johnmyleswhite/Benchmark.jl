module Benchmark
    using DataFrames

    export benchmark, benchmarks, compare

    include(Pkg.dir("Benchmark", "src", "benchmarks.jl"))
    include(Pkg.dir("Benchmark", "src", "compare.jl"))
end
