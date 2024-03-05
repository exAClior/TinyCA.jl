using Makie, GLMakie

function draw(rca::RCA{T, d}) where {T <: Int, d}
	for idx in product([1:size(rca.world, i) for i in 1:d]...)
		print(rca.world[idx...], " ")
		if idx[1] == size(rca.world, 1)
			println()
		end
	end
end

function animate(spaces::AbstractArray{T, d};
	framerate::Int64 = 5,
	save_name::String) where {T <: Int, d}

	#initial time at 1
	time = Observable(1)
	# time steps is the idx for space
	timestamps = range(1, axes(spcaes, d); step = 1)

	shapes = [:circle]

	space = @lift(eachslice(spaces; dim = d)[$time])

	cur_indices = findall(x -> x == 2, space)
	fig = scatter!([i[1] for i in cur_indices], [i[2] for i in cur_indices]; shape = :circle)

	record(fig, save_name, timestamps;
		framerate = framerate) do t
		time[] = t
	end
end
