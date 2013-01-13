module Benchmark
    using DataFrames

    export benchmark, benchmarks, compare

    include(joinpath(julia_pkgdir(), "Benchmark", "src", "benchmarks.jl"))
    include(joinpath(julia_pkgdir(), "Benchmark", "src", "compare.jl"))
end
