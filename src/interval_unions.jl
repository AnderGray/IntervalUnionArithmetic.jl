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
function intervalUnion(v)
    x = IntervalUnion(v)
    sort!(x.v; by = left)
    remove_empties!(x)
    condense!(x)
    closeGaps!(x)
    return x
end

intervalUnion(num :: Real) = IntervalUnion([interval(num)])

intervalUnion(lo :: Real, hi :: Real) = IntervalUnion([interval(lo,hi)])

intervalUnion(x :: Interval) = intervalUnion([x])
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
function remove_empties!(x :: IntervalUnion)
    deleteat!(x.v, (i for i in eachindex(x.v) if isempty(x.v[i])))
    x
end

function closeGaps!(x :: IntervalUnion, maxInts = MAXINTS[1])

    while length(x.v) > maxInts     # Global

        # Complement code
        v = sort(x.v; by = left)
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
        sort!(x.v; by = left)
    end
    return x
end

function condense!(f::Function, x :: IntervalUnion)
    v = x.v
    sort!(v; by = left)
    i = 1
    while i < length(v)
        these = (i - 1) .+ findall(collect(!f(v[i] ∩ v[j]) for j in i:length(v)))
        if length(these) > 1
            v[i] = hull(v[these])
            deleteat!(v, @view(these[2:end]))
        end
        i += 1
    end
    return x
end

condense(f, x) = condense!(f, copy(x))

# join intervals that intersect.
condense!(x::IntervalUnion) = condense!(isempty, x)
# join intervals that intersect.
condense(x::IntervalUnion) = condense(isempty, x)
# Join intervals which intersect in more than one point
condense_weak(x::IntervalUnion) = condense(i->isempty(i) || isthin(i), x)

iscondensed(f::Function, x :: IntervalUnion) = all(f(intersect(x.v[i], x.v[j])) for i in eachindex(x.v) for j in 1:i-1)

iscondensed(x::IntervalUnion) = iscondensed(isempty, x)
iscondensed_weak(x::IntervalUnion) = iscondensed(i->isempty(i) || isthin(i), x)
