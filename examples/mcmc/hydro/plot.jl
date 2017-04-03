import JLD
using LaTeXStrings
import PyPlot

probs = JLD.load("probs.jld", "probs")
khighs = Set()
for (k, v) in probs
	khigh = k[1]
	push!(khighs, khigh)
end
khighs = sort(collect(khighs))
fig, ax = PyPlot.subplots()
khighsused = Float64[]
for (i, khigh) in enumerate(khighs)
	ys = Float64[]
	xs = Float64[]
	for (k, v) in probs
		if k[1] == khigh
			push!(xs, log10(k[2]))
			push!(ys, v)
		end
	end
	if maximum(ys) > 0
		asdf = sort(collect(zip(xs, ys)), by=x->x[1])
		xs = map(x->x[1], asdf)
		ys = map(x->x[2], asdf)
		ax[:plot](xs, ys)
		push!(khighsused, khigh)
	end
end
ax[:set_xlim](-6, -0.5)
ax[:set_ylabel](L"P(\hat{\mathbf{k}}=\mathbf{k})")
ax[:set_xlabel](L"\log_{10} \sigma")
ax[:legend](map(x->latexstring("\$k_h = 10^{$(round(log10(x), 1))}k_l\$"), khighsused), loc=1)
fig[:tight_layout]()
fig[:savefig]("1dprobabilities.pdf")
display(fig); println()
PyPlot.close(fig)
