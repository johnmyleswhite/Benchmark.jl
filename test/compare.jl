using Benchmark

f1() = svd(zeros(100, 100))
f2() = svd(ones(100, 100))
f3() = svd(eye(100, 100))

benchmark(f1, "Linear Algebra", "svd(zeros(100, 100))", 10)
benchmark(f1, "svd(zeros(100, 100))", 10)

benchmark(f2, "Linear Algebra", "svd(ones(100, 100))", 10)
benchmark(f2, "svd(ones(100, 100))", 10)

compare([f1, f2, f3], 100)
