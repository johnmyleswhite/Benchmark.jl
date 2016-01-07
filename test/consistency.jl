module TestConsistency
    import Base.Test.@test
    import Benchmark.compare

    function f1()
        x = 0.0
        for i in 1:1_000_000
            x = rand()
        end
        return
    end

    comparisons = compare([f1, f1, f1], 100)
    @test maximum(comparisons[:Relative]) < 1.1
end
