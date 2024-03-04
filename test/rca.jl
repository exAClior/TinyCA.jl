using Test, TinyCA

@testset "rca helpers" begin
	space_1d = [0, 1, 0]
	@test neighborhood(space_1d, (2,)) == [1, 0, 0]

	space_2d = [1 2 3; 4 5 6; 7 8 9]
	@test neighborhood(space_2d, (2, 2)) == [5, 8, 2, 6, 9, 3, 4, 7, 1]
	@test neighborhood(space_2d, (1, 1)) == [1, 4, 2, 5]
end

@testset "transition" begin
	rca = RCA(2, [0 1 0; 0 1 0; 0 1 0], "fixed")

	function allone(x)
		if all(x .== 1)
			return 1
		else
			return 0
		end
	end

	rca_change = TinyCA.trans!(allone, copy(rca))

	rca_back = TinyCA.un_trans!(allone, copy(rca_change))

	draw(rca_back, "cur")
	draw(rca_back, "prev")

	@test rca_back.space_t == rca.space_t
	@test rca_back.space_tminus1 == rca.space_tminus1
end
