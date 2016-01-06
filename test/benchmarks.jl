module TestBenchmarks
    using Benchmark

    benchmark(() -> 10^2, "Math", "Squaring", 100)
    benchmark(() -> 10^2, "Squaring", 100)

    benchmarks(Vector[
        [() -> 10^2, "Math", "Squaring", 100],
        [() -> 10 - 10, "Math", "Subtraction", 100]])
end
