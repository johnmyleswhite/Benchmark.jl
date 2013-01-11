require("DataFrames")
module Benchmark
  using DataFrames

  export benchmark, @benchmark, @benchmark2

  include(joinpath(julia_pkgdir(), "Benchmark", "src", "benchmarks.jl"))
end
