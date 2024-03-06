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
	#initial time at 1
	time = Observable(1)
	# time steps is the idx for space
	timestamps = axes(spaces, d)

	space = @lift(eachslice(spaces; dims = d)[$time])

	fig = image(space; show_axis = false, interpolate = false)

	record(fig, save_name, timestamps;
		framerate = framerate) do t
		# update observable
		time[] = t
	end
end
