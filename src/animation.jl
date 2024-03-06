using Makie, GLMakie

function draw(rca::RCA{T, d}) where {T <: Int, d}
	for idx in product([1:size(rca.world, i) for i in 1:d]...)
		print(rca.world[idx...], " ")
		if idx[1] == size(rca.world, 1)
			println()
		end
	end
end

function animate(spaces::AbstractArray{T, d}; framerate::Int, save_name::String) where {T <: Int, d}
	x_limit, y_limit = size(eachslice(spaces; dims = d)[1])
	#initial time at 1
	time = Observable(1)
	# time steps is the idx for space
	timestamps = axes(spaces, d)

	space = @lift(eachslice(spaces; dims = d)[$time])

	function find_pos(space)
		cur_indices = findall(x -> x == 2, space)
		return [Point2(i[1] - 0.5, i[2] - 0.5) for i in cur_indices]
	end

	positions = lift(find_pos, space)

	fig, ax, line = scatter(
		positions; marker = :rect, markerspace = :data, markersize = 1.5, color = :black,
		axis = (;
			xgridcolor = :black,
			ygridcolor = :black,
			xgridwidth = 2,
			ygridwidth = 2,
			aspect = 1, limits = (0, x_limit, 0, y_limit)),
	)

	ax.xticks = 1:x_limit
	ax.yticks = 1:y_limit

	record(fig, save_name, timestamps;
		framerate = framerate) do t
		# update observable
		time[] = t
	end
end
