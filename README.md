Benchmark.jl
============

**THIS PACKAGE IS ABANDONED. ALL FUTURE WORK WILL HAPPEN IN THE Benchmarks.jl REPO.**

A package for computing simple benchmarks and comparing functions

# Usage Example

	using Benchmark

	f1() = svd(zeros(100, 100))
	f2() = svd(ones(100, 100))
	f3() = svd(eye(100, 100))

	benchmark(f1, "Linear Algebra", "svd(zeros(100, 100))", 10)
	benchmark(f1, "svd(zeros(100, 100))", 10)

	benchmark(f2, "Linear Algebra", "svd(ones(100, 100))", 10)
	benchmark(f2, "svd(ones(100, 100))", 10)

	compare([f1, f2, f3], 100)

# Output Information

* Benchmarks:
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
    * CPU cores
* Comparisons
	* Function Name
	* Elapsed Time
	* Relative Performance
	* Number of Iterations

# Desired Information
    
* BLAS Information
* CPU Statistics
