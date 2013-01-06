load("DataFrames")
module Benchmark
  using DataFrames

  export benchmark, @benchmark

  include(joinpath(julia_pkgdir(), "Benchmark", "src", "benchmarks.jl"))
end
