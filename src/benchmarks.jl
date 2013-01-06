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

# For comparing two functions
function benchmark(f::Function, f2::Function, category::String, name::String, name2::String, N::Int)
  df = DataFrame()
  choosed = rand(2N) .<= .5
  N1= sum(choosed)
  N2= 2N - N1
  df["BenchmarkCategory"] = [ category; category ] 
  df["BenchmarkName"] = name
  df["Iterations"] = N1
  df[2,"BenchmarkName"] = name2
  df[2,"Iterations"] = N2
  times1 = zeros(N1)
  times2 = zeros(N2)
  f() # Call once to force JIT compilation
  f2()
  i=1
  j=1
  for itr in 1:2N
    if choosed[itr]
      times1[i] = @elapsed f()
      i += 1
    else
      times2[j] = @elapsed f2()
      j += 1
    end
  end
  df["TotalWall"] = sum(times1)
  df["AverageWall"] = mean(times1)
  df["MaxWall"] = max(times1)
  df["MinWall"] = min(times1)
  df[2,"TotalWall"] = sum(times2)
  df[2,"AverageWall"] = mean(times2)
  df[2,"MaxWall"] = max(times2)
  df[2,"MinWall"] = min(times2)
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
benchmark(f::Function, f2::Function, name::String, name2::String, N::Int) = benchmark(f, f2, "comparing", name, name2, N)
benchmark(f::Function, name::String, f2::Function, name2::String, N::Int) = benchmark(f, f2, "comparing", name, name2, N)
benchmark(f::Function, name::String, f2::Function, name2::String, category::String, N::Int) = benchmark(f, f2, category, name, name2, N)

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

# For comparing two expressions
macro benchmark(ex, ex2, category, name, name2, N)
  df = DataFrame()
  choosed = rand(2N) .<= .5
  N1= sum(choosed)
  N2= 2N - N1
  df["BenchmarkCategory"] = [ category; category ] 
  df["BenchmarkName"] = name
  df["Iterations"] = N1
  df[2,"BenchmarkName"] = name2
  df[2,"Iterations"] = N2
  times1 = zeros(N1)
  times2 = zeros(N2)
  esc(ex)
  esc(ex2)
  i=1
  j=1
  for itr in 1:2N
    if choosed[itr]
      times1[i] = @elapsed esc(ex)
      i += 1
    else
      times2[j] = @elapsed esc(ex2)
      j += 1
    end
  end
  df["TotalWall"] = sum(times1)
  df["AverageWall"] = mean(times1)
  df["MaxWall"] = max(times1)
  df["MinWall"] = min(times1)
  df[2,"TotalWall"] = sum(times2)
  df[2,"AverageWall"] = mean(times2)
  df[2,"MaxWall"] = max(times2)
  df[2,"MinWall"] = min(times2)
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
