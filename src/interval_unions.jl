"""

    Interval unions sets of defined by unions of disjoint intervals.
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


###
#   IntervalUnion constructor. Consists of a vector of intervals
###
struct IntervalUnion{T<:Real} <: AbstractInterval{T}
    v :: Vector{Interval{T}}
end


###
#   Outer constructors
###
function intervalUnion(x)
    x = IntervalUnion(x)
    sort!(x.v)
    x = remove_empties(x)
    x = condense(x)
    closeGaps!(x)
    return x
end

intervalUnion(num :: Real) = IntervalUnion([interval(num)])

intervalUnion(lo :: Real, hi :: Real) = IntervalUnion([interval(lo,hi)])

intervalUnion(x :: Interval) = IntervalUnion([x])
∪(x :: Interval) = intervalUnion(x)

∪(x :: Interval, y :: Interval) = intervalUnion([x; y])
∪(x :: Array{Interval{T}}) where T <:Real = intervalUnion(x)

intervalUnion(x :: Interval, y :: IntervalUnion) = intervalUnion([x; y.v])
∪(x :: Interval, y :: IntervalUnion) = intervalUnion(x,y)

intervalUnion(x :: IntervalUnion, y :: Interval) = intervalUnion([x.v; y])
∪(x :: IntervalUnion, y :: Interval) = intervalUnion(x,y)

intervalUnion(x :: IntervalUnion, y :: IntervalUnion) = intervalUnion([x.v; y.v])
∪(x :: IntervalUnion, y :: IntervalUnion) = intervalUnion(x,y)

# MultiInterval can act like a vector
getindex(x :: IntervalUnion, ind :: Integer) = getindex(x.v,ind)
getindex(x :: IntervalUnion, ind :: Array{ <: Integer}) = getindex(x.v,ind)

# Remove ∅ from IntervalUnion
function remove_empties(x :: IntervalUnion)

    v = x.v

    if all(isempty.(v)); return intervalUnion(∅); end

    Vnew = v[v .!= ∅]
    return IntervalUnion(Vnew)
end

function closeGaps!(x :: IntervalUnion, maxInts = MAXINTS[1])

    while length(x.v) > maxInts     # Global

        # Complement code
        v = sort(x.v)
        vLo = left.(v)
        vHi = right.(v)
        vLo[1] == -∞ ? popfirst!(vLo) : pushfirst!(vHi, -∞)
        vHi[end] == ∞ ? pop!(vHi) : push!(vLo, ∞)
        xc = interval.(vHi,vLo)

        # Close smallest width of complement
        widths = diam.(xc)
        d, i = findmin(widths)
        merge = hull(x[i-1], x[i])
        popat!(x.v, i)
        popat!(x.v, i-1)
        push!(x.v, merge)
        sort!(x.v)
    end
    return x
end

# Recursively envolpe intervals which intersect.
function condense(x :: IntervalUnion)

    if iscondensed(x); return x; end

    v = sort(x.v)
    v = unique(v)

    Vnew = Interval{Float64}[]
    for i =1:length(v)

        intersects = intersect.(v[i],v )
        these = findall( intersects .!= ∅)

        push!(Vnew, hull(v[these]))
    end
    return condense( intervalUnion(Vnew) )
end

function iscondensed(x :: IntervalUnion)
    v = sort(x.v)
    for i=1:length(v)
        intersects = findall( intersect.(v[i],v[1:end .!= i]) .!= ∅)
        if !isempty(intersects); return false; end
    end
    return true
end

# Recursively envolpe intervals which intersect, except those which touch
function condense_weak(x :: IntervalUnion)

    if iscondensed(x); return x; end

    v = sort(x.v)
    v = unique(v)

    Vnew = Interval{Float64}[]
    for i =1:length(v)

        intersects = intersect.(v[i],v )

        notempty = intersects .!= ∅
        isItThin = isthin.(intersects)    # Don't hull intervals which touch

        notEmptyOrThin = notempty .* (1 .- isItThin)
        them = findall(notEmptyOrThin .== 1)

        push!(Vnew, hull(v[them]))
    end
    return condense( intervalUnion(Vnew) )
end

function iscondensed_weak(x :: IntervalUnion)
    v = sort(x.v)
    for i=1:length(v)
        intersects = intersect.(v[i],v[1:end .!= i])

        notempty = intersects .!= ∅
        isItThin =  isthin.(intersects)

        notEmptyOrThin = notempty .* (1 .- isItThin)

        if sum(notEmptyOrThin) != 0; return false; end
    end
    return true
end
