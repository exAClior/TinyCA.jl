using IterTools

mutable struct RCA{T <: Int, d}
	n::Int # number of cell states
	# space of cell at time t
	space_t::Array{T, d}
	space_tminus1::Array{T, d}
	# space of cell at time t-1
	boundary_condition::String
end

function Base.copy(rca::RCA{T, d}) where {T, d}
	return RCA(rca.n, copy(rca.space_t), copy(rca.space_tminus1), rca.boundary_condition)
end

function RCA(n::Int, space::Array{Int, d}, boundary_condition::String) where d
	return RCA(n, space, space, boundary_condition)
end

function trans!(f::Function, rca::RCA{T, d}) where {T, d}
	new_space = similar(rca.space_t)
	for indices in product([1:size(rca.space_t, i) for i in 1:d]...)
		new_space[indices...] = mod(f(neighborhood(rca.space_t, indices)) - rca.space_tminus1[indices...], rca.n)
	end
	rca.space_tminus1 = rca.space_t
	rca.space_t = new_space
	return rca
end

function un_trans!(f::Function, rca::RCA{T, d}) where {T, d}
	old_space = similar(rca.space_t)
	for indices in product([1:size(rca.space_t, i) for i in 1:d]...)
		old_space[indices...] = mod(f(neighborhood(rca.space_tminus1, indices)) - rca.space_t[indices...], rca.n)
	end
	rca.space_t = rca.space_tminus1
	rca.space_tminus1 = old_space
	return rca
end

function neighborhood(space::AbstractArray{T, d}, iis) where {T <: Int, d}
	@assert length(iis) == d
	res = Int[]
	for diffs in product(repeat([[0, 1, -1]], d)...)
		if all(1 .<= iis .+ diffs .<= size(space, 1))
			push!(res, space[(iis .+ diffs)...])
		end
	end
	return res
end

function draw(rca::RCA{T, d}, t::String) where {T <: Int, d}
	if t == "cur"
		draw(rca.space_t)
	else
		draw(rca.space_tminus1)
	end
end

function draw(space::AbstractArray{T, d}) where {T <: Int, d}
	for idx in product([1:size(space, i) for i in 1:d]...)
		print(space[idx...], " ")
		if idx[1] == size(space, 1)
			println()
		end
	end
end
