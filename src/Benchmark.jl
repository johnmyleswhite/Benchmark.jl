module Benchmark
    using DataArrays # TODO: Remove this
    using DataFrames

    export benchmark, benchmarks, compare

    include("benchmarks.jl")
    include("compare.jl")
end
