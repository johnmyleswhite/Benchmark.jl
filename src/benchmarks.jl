function benchmark(f::Function, category::String, name::String, N::Int)
  df = DataFrame()
  df["BenchmarkCategory"] = category
  df["BenchmarkName"] = name
  df["Iterations"] = N
  times = zeros(N)
  f() # Call once to force JIT compilation
  for itr in 1:N
    times[itr] = @elapsed f()
  end
  df["TotalWall"] = sum(times)
  df["AverageWall"] = mean(times)
  df["MaxWall"] = max(times)
  df["MinWall"] = min(times)
  df["Timestamp"] = strftime("%Y-%m-%d %H:%M:%S", int(time()))
  df["JuliaVersion"] = string(VERSION)
  df["JuliaHash"] = Base.VERSION_COMMIT
  if isdir(".git")
    df["CodeHash"] = readchomp(`git rev-parse HEAD`)[1:10]
  else
    df["CodeHash"] = NA
  end
  df["OS"] = string(OS_NAME)
  return df
end

benchmark(f::Function, name::String, N::Int) = benchmark(f, name, name, N)

macro benchmark(ex, category, name, N)
  df = DataFrame()
  df["BenchmarkCategory"] = category
  df["BenchmarkName"] = name
  df["Iterations"] = N
  times = zeros(N)
  esc(ex) # Call once to force JIT compilation
  for itr in 1:N
    times[itr] = @elapsed esc(ex)
  end
  df["TotalWall"] = sum(times)
  df["AverageWall"] = mean(times)
  df["MaxWall"] = max(times)
  df["MinWall"] = min(times)
  df["Timestamp"] = strftime("%Y-%m-%d %H:%M:%S", int(time()))
  df["JuliaVersion"] = string(VERSION)
  df["JuliaHash"] = Base.VERSION_COMMIT
  if isdir(".git")
    df["CodeHash"] = readchomp(`git rev-parse HEAD`)[1:10]
  else
    df["CodeHash"] = NA
  end
  df["OS"] = string(OS_NAME)
  return df
end

# Pass a Vector{Any} of benchmarks
# Each must have the argument form of a single call to benchmark
function benchmarks(marks::Vector{Any})
  df = DataFrame()
  for mark in marks
    rbind(df, benchmark(mark[1], mark[2], mark[3]))
  end
  return df
end
