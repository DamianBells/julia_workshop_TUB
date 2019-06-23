#####################################################
############### Types in Julia ######################
#####################################################

# A program consists of data and operations on data.
# Data is not just the input file, but everything
# that is held—an array, a list, a graph, a constant—during the life of the program.
# The more the computer knows about this data,
# the better it is at executing operations on that data.
# Types are exactly this metadata (see reference [1]).

# Type annotation with "::":

10::Int64
4::Float64

# There is a hierarchy of types:

Int <: Number
Float64 <: AbstractFloat

# Some more examples of common types:

A = [1 2; 3 4]

R = rand(1, 2, 1);
typeof(R)

R[1,1,1]
typeof([R[1,1,1]])

# Array{T, ndims}  = Array{type, number of dims}


# One can generate own types!

# type declaration with concrete types:
struct Programmer
    name::String
    birth_year::UInt16
    fave_language::AbstractString
end

# type instantiation:
Albertovic = Programmer("Albertovic", 1994, "Julia")
typeof(Albertovic)
fieldnames(Programmer)
Albertovic.fave_language

# type declaration with a parameter/placeholder, i.e. a generic type:
struct Point{T}
 x::T
 y::T
end

# type instantiation:
Origin = Point(0, 0) # Parameter T is Int64
RandomPoint = Point(rand(1, 2)[1,1], rand(1, 2)[1,2]) # Parameter T is Float64

#####################################################
############### Small Exercise ######################
#####################################################

# Create a struct 'BodyDatas' that contains the fields: name, weight and height. Choose proper contrete types!
# Create an arbitrary instance of that struct!

#####################################################
############### Functional Programming in Julia #####
#####################################################

# (1): Functions can return functions as output argument.
# (2): Functions can feed other functions, i.e. act like an input argument.

# Example for (1):

function compose(ϕ::Function, ϑ::Function)
    Γ = ϕ ∘ ϑ; # compare to notation in mathematical papers
end

fancyComposition = compose(sin, exp); # i.e.: x -> sin(exp(X)) = x -> (sin ∘ exp) (x)
fancyComposition(1.9) # i.e.: 1.9 -> sin(exp(1.9)) = 1.9 -> (sin ∘ exp) (1.9)

# But there are unlike in Haskell no 'arrow-types' (see [4])

# Example for (2):

# Functional programming can shorten programming code:

x = [1, 2, 3, 4, 2, 1, 3, 9.1, 4.112];
f = x -> x^2;
map(f, x) # one of the standard higher-order functions

# compared to (which has some nice notion in the header of the for-loop):

y = zeros(length(x))
for i ∈ length(x)
    y[i] = x[i].^2
end
y

# Another useful higher-order function:
g = x-> x < 3;
filter(g, x)

#####################################################
############### Small Exercise ######################
#####################################################

# Consider the higher order function γ:

function γ(f::Function)
    f ∘ exp ∘ sin ∘ asin
end

# Which function has to be inserted into γ for achieving an identity map?
# Test it on a number between 0 and 1
# Test it on the array A = [0.1, 0.3, 0.1, 0.2, 0.4]
# (You should make use of an other higher-order function)


#####################################################
############# Useful References #####################
#####################################################

# [1]: Julia: A fresh approach to numerical computing (https://www.researchgate.net/publication/267983125_Julia_A_Fresh_Approach_to_Numerical_Computing)
# [2]: Julia Cheat-Sheet: https://juliadocs.github.io/Julia-Cheat-Sheet/
# [3]: https://docs.julialang.org/en/v1/manual/types/index.html
# [4]: Haskell: https://www.haskell.org/
# [5]: https://docs.julialang.org/en/v1/base/collections/#Base.map
