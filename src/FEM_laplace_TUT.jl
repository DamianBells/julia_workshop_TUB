using LinearAlgebra
using SparseArrays
using Plots
using DelimitedFiles
#using BenchmarkTools
#using Distributed

element = Tuple{Vararg{Int}} # element type. Allows varois DoF

struct mesh
    coordinates::Array{Float64}  # coordinates of domainpoints {Float64}
    elements::Array{element}   # elements: indices for coordinates {Int64}
    boundaries::Array{element}  #boundary elements: indices for coordinates {Int64}
end

include("FEM_simulator.jl")

coordinates=readdlm("data/coordinates.txt")
elements=convert(Array{Int64},readdlm("data/elements.txt"))
boundary=convert(Array{Int64},readdlm("data/boundaries.txt"))

inner_bound=convert(Array{Int64},readdlm("data/inner_bound.txt"))
outer_bound=convert(Array{Int64},readdlm("data/outer_bound.txt"))
indicies=convert(Array{Int64},readdlm("data/indicies.txt"))



msh = mesh( coordinates[:,1:2],
            [tuple(elements[i,:]...) for i in 1:size(elements,1) ],
            [tuple(boundary[k,:]...) for k in 1:size(boundary,1) ] )


φ,A,b = simulator((msh,inner_bound,outer_bound,indicies),true)

gr();

x = msh.coordinates[:,1];
y = msh.coordinates[:,2];

p = x, y, φ;
xₗ = "x"; yₗ = "y";
pl = surface(p);

plot(pl, xlabel = xₗ, ylabel = yₗ, camera=(0, 90))

#savefig("Solution.pdf")

# convergence: error validaton:

# analytical solution:
function φₐ(x,y)
    ρ = sqrt(x^2+y^2);
    φ₋ = 0; φ₊ = 1;
    r₁ = 1; r₂ = 2;
    A₁ = (φ₊-φ₋)/log(r₂/r₁); A₂ = φ₋-A₁*log(r₁);
        if ρ<=r₁ || ρ>=r₂
            return 0;
        end
    return A₁*log(ρ) + A₂;
end

z = (zeros(size(msh.coordinates,1),1));
z = map(φₐ, x, y);

err=φ'-z

#plot(pₚ, xlabel = xₗ, ylabel = yₗ, camera=(30, 30))


ind=findall(x->x==1,err)

for i in ind
    err[i]=0
end

pₚ = surface(x,y,sqrt.((err).^2));
plot(pₚ, xlabel = xₗ, ylabel = yₗ, camera=(30, 30))

#savefig("Error.pdf");

δ = sqrt(sum( (err).^2))

maximum(err)
minimum(err)

#surface(x,y,z', camera=(90, 0))
