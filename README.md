Benchmark
=========

A package for computing simple benchmarks

# Usage Example

	load("Benchmark")
	using Benchmark

	function f()
	  svd(zeros(1000, 1000))
	end

	benchmark(f, "Calculate the SVD of a 1000x100 Matrix", 10)
	benchmark(f, "Linear Algebra", "Calculate the SVD of a 1000x100 Matrix", 10)

# Output Information

* Benchmark Category
* Benchmark Name
* Number of Iterations
* Total Wall Clock Time
* Average Wall Clock Time per Iteration
* Max Wall Clock Time
* Min Wall Clock Time
* Timestamp
* Git SHA1 for Julia
* Git SHA1 for Code
* OS Information

# Desired Information

* BLAS Information
* CPU Statistics
* CPU cores (in CPU_CORES)
