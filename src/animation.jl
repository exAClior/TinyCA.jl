using Plots

function draw(rca::RCA{T, d}) where {T <: Int, d}
	for idx in product([1:size(rca.world, i) for i in 1:d]...)
		print(rca.world[idx...], " ")
		if idx[1] == size(rca.world, 1)
			println()
		end
	end
end

function animate(spaces::AbstractArray{T, d}) where {T <: Int, d}
	shapes = [:circle, :rect, :star5, :diamond, :hexagon, :cross, :xcross, :utriangle, :dtriangle, :rtriangle, :ltriangle, :pentagon, :heptagon, :octagon, :star4, :star6, :star7, :star8]
	for t in axes(d, spaces)
		cur_plot = plot(1)
		for cur_shape in 1:maximum(spaces)
			cur_indices = findall(x -> x == cur_shape, eachslice(spaces, d))
			# cur_indices = [(i[1], i[2]) for i in cur_indices]
			scatter!([i[1] for i in cur_indices], [i[2] for i in cur_indices]; shape = shapes[cur_shape])
		end
	end
end