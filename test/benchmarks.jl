load("Benchmark")
using Benchmark

benchmark(() -> 10^2, "Squaring", 100)

benchmarks({
	 		 {() -> 10^2, "Squaring", 100},
	 		 {() -> 10 - 10, "Subtraction", 100}
	       })
