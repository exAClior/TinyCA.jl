using IterTools

mutable struct RCA{T <: Int, d}
	parity::T
	world::Array{T, d}
end

function Base.copy(rca::RCA{T, d}) where {T, d}
	return RCA(rca.parity, copy(rca.world))
end

function RCA(space::Array{T, d}) where {T <: Int, d}
	@assert maximum(space) <= 2 "Check the cells, it should be less than 2"
	@assert minimum(space) >= 1 "Check the cells, it should be greater than 0"
	return RCA(0, space)
end

function trans!(f::Function, rca::RCA{T, d}) where {T, d}
	new_world = similar(rca.world)
	for indices in product([(1 + rca.parity):2:size(rca.world, i) for i in 1:d]...)
		nb_idcs = neighborhood(rca.world, indices)
		new_world[nb_idcs] = f(rca.world[nb_idcs])
	end
	rca.world = new_world
	rca.parity = mod(rca.parity + 1, 2)
	return rca
end

function untrans!(f::Function, rca::RCA{T, d}) where {T, d}
	rca.parity = mod(rca.parity + 1, 2)
	return trans!(f, rca)
end

function neighborhood(space::AbstractArray{T, d}, iis) where {T <: Int, d}
	@assert length(iis) == d
	cis = LinearIndices(space)
	idcs = cis[[[ii, mod1(ii + 1, size(space, 1))] for ii in iis]...]
	return idcs
end
