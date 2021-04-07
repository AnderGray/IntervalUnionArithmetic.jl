using IntervalArithmetic
import Base: getindex, ∪
import Base: +, -, *, /, min, max, ^, log, <, >, exp, sin, cos, tan
import IntervalArithmetic: hull

"""

    Multi-Intervals are unions of disjoint intervals. 
    This file includes constructors, arithmetic (including intervals and scalars)
    and complement functions

    Empty sets and intersecting intervals are appropriately handled in the constructor:

    julia> a = interval(0,2) ∪ interval(3,4)
    [0, 2] ∪ [3, 4]

    julia> b = interval(1,2) ∪ interval(4,5) ∪ ∅
    [1, 2] ∪ [4, 5]

    julia> c = a * b 
    [0, 10] ∪ [12, 20]
    
    julia> complement(c)
    [-∞, 0] ∪ [10, 12] ∪ [20, ∞]

"""


abstract type IntervalUnion{T} <: AbstractInterval{T} end

###
#   Multi-Interval constructor. Consists of a vector of intervals
###
struct IntervalU{T<:Real} <: IntervalUnion{T} 
    v :: Array{Interval{T}}
end


###
#   Outer constructors
###
function intervalU(x) 
    x = IntervalU(x)
    x = remove_empties(x)
    return condense(x)
end

intervalU(x :: Interval) = IntervalU([x])
∪(x :: Interval) = intervalU(x)

∪(x :: Interval, y :: Interval) = intervalU([x; y])
∪(x :: Array{Interval{T}}) where T <:Real = intervalU(x)

intervalU(x :: Interval, y :: IntervalU) = intervalU([x; y.v])
∪(x :: Interval, y :: IntervalU) = intervalU(x,y)

intervalU(x :: IntervalU, y :: Interval) = intervalU([x.v; y])
∪(x :: IntervalU, y :: Interval) = intervalU(x,y)

intervalM(x :: IntervalU, y :: IntervalU) = intervalU([x.v; y.v])
∪(x :: IntervalU, y :: IntervalU) = intervalU(x,y)

# MultiInterval can act like a vector
getindex(x :: IntervalU, ind :: Integer) = getindex(x.v,ind)
getindex(x :: IntervalU, ind :: Array{ <: Integer}) = getindex(x.v,ind)

# Remove ∅ from Multi-Interval
function remove_empties(x :: IntervalU)
    v = x.v
    Vnew = v[v .!= ∅]
    return IntervalU(Vnew)
end

# Recursively envolpe intervals which intersect.
function condense(x :: IntervalU)

    if is_condensed(x); return x; end

    v = sort(x.v)
    v = unique(v)

    Vnew = Interval{Float64}[]
    for i =1:length(v)
        these = findall( intersect.(v[i],v ) .!= ∅)
        push!(Vnew, hull(v[these]))
    end
    return condense( intervalU(Vnew) )
end

function is_condensed(x :: IntervalU)
    v = sort(x.v)
    for i=1:length(v)
        intersects = findall( intersect.(v[i],v[1:end .!= i]) .!= ∅)
        if !isempty(intersects); return false; end
    end
    return true
end

# Envolpe/hull. Keeps it as a multi interval
env(x :: IntervalU) = IntervalU([hull(x.v)])
hull(x :: IntervalU) = IntervalU([hull(x.v)])


# Computes the complement of a Multi-Interval
function complement(x :: IntervalU)

    v = sort(x.v)
    vLo = left.(v)
    vHi = right.(v)

    pushfirst!(vHi, -∞)
    push!(vLo, ∞)

    complements = interval.(vHi,vLo)

    return intervalU(complements)
end

complement(x :: Interval) = complement(intervalU(x))

###
#   Multi-Interval Arithmetic
###

for op in (:+, :-, :*, :/, :min, :max, :^, :log, :<, :>)
    @eval ($op)( x::IntervalU, y::IntervalU) = intervalU([$op(xv, yv) for xv in x.v, yv in y.v][:])

    @eval ($op)( x::IntervalU, y::Interval) = intervalU(broadcast($op, x.v, y))
    @eval ($op)( x::Interval, y::IntervalU) = intervalU(broadcast($op, y, x.v))

    @eval ($op)( x::IntervalU, n::Real) = intervalU(broadcast($op, x.v, n))
    @eval ($op)( n::Real, x::IntervalU) = intervalU(broadcast($op, n, x.v))
    
end

for op in (:-, :sin, :cos, :tan, :exp, :log)
    @eval ($op)( x::IntervalU) = intervalU(broadcast($op, x.v))
end

###
#   Utilities and show
###

left(x :: Interval) = x.lo
right(x :: Interval) = x.hi

left(x :: IntervalU) = left.(x.v)
right(x :: IntervalU) = right.(x.v)

function Base.show(io::IO, this::IntervalU)
    v = sort(this.v)
    print(io, join(v, " ∪ "));
end
