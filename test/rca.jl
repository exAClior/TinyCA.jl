using Test, TinyCA

@testset "rca helpers" begin
	space_1d = [0, 1, 0]
	@test neighborhood(space_1d, (2,)) == [2, 3]

	space_2d = [1 4 7; 2 5 8; 3 6 9]
	@test neighborhood(space_2d, (2, 2)) == [5 8; 6 9]
	@test neighborhood(space_2d, (3, 3)) == [9 3; 7 1]
end

@testset "transition" begin
	basis = [[1 1; 1 1], [1 1; 2 1], [1 2; 2 1], [1 2; 1 2], [2 2; 1 2], [2 2; 2 2]]
	random_world = zeros(Int64, 10, 10)
	for i in 1:2:10, j in 1:2:10
		random_world[i:(i + 1), j:(j + 1)] = rand(basis)
	end

	rca = RCA(random_world)

	function reversible_4(x::AbstractMatrix)
		if x == [1 1; 1 1] || x == [2 2; 2 2]
			return x
		elseif x == [1 1; 2 1]
			return [1 2; 1 1]
		elseif x == [1 2; 2 1]
			return [2 1; 1 2]
		elseif x == [1 2; 1 2]
			return [1 2; 1 2]
		elseif x == [2 2; 1 2]
			return [2 2; 1 2]
		else
			error("Invalid input")
		end
	end

	function inv_reversible_4(x::AbstractMatrix)
		if x == [1 1; 1 1] || x == [2 2; 2 2]
			return x
		elseif x == [1 2; 1 1]
			return [1 1; 2 1]
		elseif x == [2 1; 1 2]
			return [1 2; 2 1]
		elseif x == [1 2; 1 2]
			return [1 2; 1 2]
		elseif x == [2 2; 1 2]
			return [2 2; 1 2]
		else
			error("Invalid input")
		end
	end

	rca_change = trans!(reversible_4, copy(rca))

	# draw(rca)

	# draw(rca_change)

	rca_change.parity = mod(rca_change.parity + 1, 2)
	rca_back = trans!(inv_reversible_4, copy(rca_change))

	@test rca_back.world == rca.world
end
