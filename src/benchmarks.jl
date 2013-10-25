function timer(f::Function, n::Integer)
    # Call once to force JIT compilation
    f()

    times = Array(Float64, n)
    for itr in 1:n
        times[itr] = @elapsed f()
    end

    return times
end

function benchmark(f::Function, category::String, name::String, n::Integer)
    times = timer(f, n)

    df = DataFrame()
    df["Category"] = category
    df["Benchmark"] = name
    df["Iterations"] = n
    df["TotalWall"] = sum(times)
    df["AverageWall"] = mean(times)
    df["MaxWall"] = maximum(times)
    df["MinWall"] = minimum(times)
    df["Timestamp"] = strftime("%Y-%m-%d %H:%M:%S", int(time()))
    df["JuliaHash"] = Base.VERSION_COMMIT
    if isdir(".git")
        df["CodeHash"] = readchomp(`git rev-parse HEAD`)[1:10]
    else
        df["CodeHash"] = NA
    end
    df["OS"] = string(OS_NAME)
    df["CPUCores"] = CPU_CORES

    return df
end

benchmark(f::Function, name::String, n::Integer) = benchmark(f, name, name, n)

function benchmarks(marks::Vector)
    df = DataFrame()

    for mark in marks
        df = rbind(df,
                   benchmark(mark[1], mark[2], mark[3], mark[4]))
    end

    return df
end
