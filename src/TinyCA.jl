module TinyCA

# Write your package code here.
export neighborhood, RCA, trans!, untrans!
include("rca.jl")
export draw
include("animation.jl")
end
