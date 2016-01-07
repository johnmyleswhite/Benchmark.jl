elapsedtime(adf::AbstractDataFrame) = DataFrame(Average = mean(adf[:Time]))

function compare(fs::Vector, replications::Integer)
	n = length(fs)

	# Force JIT compilation
	for i in 1:n
		fs[i]()
	end

	times = Array(Float64, n * replications)
	indices = Array(Int, n * replications)
	for i in 1:n
		f = fs[i]
		f()
		for itr in 1:replications
			index = (i - 1) * replications + itr
			times[index] = @elapsed f()
			indices[index] = i
		end
	end

	df = DataFrame(Any[times, indices], [:Time, :Function])
	df = by(df, :Function, elapsedtime)
	df[:Relative] = df[:Average] / minimum(df[:Average])
	df[:Function] = DataArray(UTF8String, size(df, 1))
	for i in 1:size(df, 1)
		df[i, :Function] = string(fs[i])
	end
	df[:Replications] = replications

	return df
end

compare(replications::Integer, fs::Function...) = compare([fs...], replications)
