function timer(f::Function, n::Integer, args...)
    # Call once to force JIT compilation
    f(args...)

    times = Array(Float64, n)
    for itr in 1:n
        times[itr] = @elapsed f(args...)
    end

    return times
end

function benchmark(f::Function, category::String, name::String, n::Integer, args...)
    times = timer(f, n, args...)

    df = DataFrame()
    df["Category"] = category
    df["Benchmark"] = name
    df["Iterations"] = n
    df["TotalWall"] = sum(times)
    df["AverageWall"] = mean(times)
    df["MaxWall"] = max(times)
    df["MinWall"] = min(times)
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

benchmark(f::Function, name::String, n::Integer, args...) = benchmark(f, name, name, n, args...)

function benchmarks(marks::Vector)
    df = DataFrame()

    for mark in marks
        df = rbind(df,
                   benchmark(mark[1], mark[2], mark[3], mark[4]))
    end

    return df
end
