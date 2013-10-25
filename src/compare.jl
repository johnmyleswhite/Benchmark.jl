function compare(fs::Vector{Function}, replications::Integer)
	n = length(fs)

	# Force JIT compilation
	for i in 1:n
		fs[i]()
	end

	n_total = replications * n
	indices = reshape(repmat([1:n], replications, 1), n_total)
	shuffle!(indices)
	indices = DataArray(indices)

	times = DataArray(Float64, n_total)
	for i in 1:n_total
		times[i] = @elapsed fs[indices[i]]()
	end

	df = DataFrame({times, indices}, ["Time", "Function"])
	df = by(df, "Function", :(Elapsed = sum(Time)))
	df["Relative"] = df["Elapsed"] / minimum(df["Elapsed"])
	df["Function"] = DataArray(ASCIIString, nrow(df))
	for i in 1:nrow(df)
		df[i, "Function"] = string(fs[i])
	end
	df["Replications"] = replications

	return df
end
compare(replications::Integer, fs::Function...) = compare([fs...], replications)
