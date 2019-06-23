

#A function was created with intention to measure the overall simulation time interval

#using LinearAlgebra
#using SparseArrays
#using Plots
#using BenchmarkTools
#import Base.getindex

function get_ele(msh::mesh,ele_index::Int) #returns an array of points for given index
    return msh.coordinates[collect(msh.elements[ele_index]),:]
end

function stima(msh,element::NTuple{3,Int64})
        vertices=msh.coordinates[collect(element),:]
        d=size(vertices,2)
        G=[ones(1,d+1);vertices'] \ [zeros(1,d);I]
        return det([ones(1,d+1);vertices']) * (G*G')/prod(1:d)
end

function stima(mesh,element::NTuple{4,Int64})
        vertices=msh.coordinates[collect(element),:]
        D_Phi=[vertices[2,:]' - vertices[1,:]'; vertices[4,:]' - vertices[1,:]']'
        B=inv(D_Phi'*D_Phi)
        C1 = [2 -2; -2 2]*B[1,1]+[-3 0;0 -3]*B[1,2] + [2 1;1 2]*B[2,2]
        C2 = [-1 1; 1 -1]*B[1,1]+[-3 0;0 3]*B[1,2]+[-1 -2;-2 -1]*B[2,2]
        return det(D_Phi) * [C1 C2;C2 C1] /6
end

f(x) = zeros(size(x,1),1)
g(x) = zeros(size(x,1),1)
u_d1(x) = ones(size(x,1),1)
u_d2(x) = zeros(size(x,1),1)

function simulator((msh,inner_bound,outer_bound,indicies),re_u::Bool=false)
        #Init
        FreeNodes=setdiff(1:size(msh.coordinates,1),union(inner_bound,outer_bound))
        A=sparse([size(msh.coordinates,1)],[size(msh.coordinates,1)],[Float64(0)])
        b=(zeros(size(msh.coordinates,1),1))

        #A Assambly alternative

        @time for i in 1:size(msh.elements,1)   # vielleicht hier parallelisieren!
                A[collect(msh.elements[i]),collect(msh.elements[i])].+=stima(msh,msh.elements[i])
        end

        #Volume Force Alt
        for j in 1:size(msh.elements,1)
                b[collect(msh.elements[j])].+=det([1 1 1; get_ele(msh,j)[1:3,:]'])*f(sum(get_ele(msh,j))/3)[:][1]/6
        end


        #dirichlet conditions
        u=(zeros(size(msh.coordinates,1),1))
        #u[unique(dirichlet)]=u_d(coordinates[unique(dirichlet),:])
        u[inner_bound]=u_d2(inner_bound)
        u[outer_bound]=u_d1(outer_bound)

        b=b-A*u

        freeN=intersect(FreeNodes,indicies)
        #Intersection between FreeNodes and Indicies is needed to erase all zero entries in the diagonal of A! det(A) != zero !!
        #-> for Nodes outside the mesh and without a solution
        @time u[freeN]=A[freeN,freeN] \ b[freeN]

        if re_u return u',A,b end
end
