module Benchmark
    using DataFrames

    export benchmark, benchmarks, compare

    include("benchmarks.jl")
    include("compare.jl")
end
