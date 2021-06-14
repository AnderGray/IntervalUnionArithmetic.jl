###
#   Set operations
###

# Envolpe/hull. Keeps it as a IntervalUnion
env(x :: IntervalUnion) = IntervalUnion([hull(x.v)])
hull(x :: IntervalUnion) = IntervalUnion([hull(x.v)])


# Computes the complement of a IntervalUnion
function complement(x :: IntervalUnion)

    v = sort(x.v)
    vLo = left.(v)
    vHi = right.(v)

    vLo[1] == -∞ ? popfirst!(vLo) : pushfirst!(vHi, -∞)
    vHi[end] == ∞ ? pop!(vHi) : push!(vLo, ∞)


    complements = interval.(vHi,vLo)

    return intervalUnion(complements)
end

complement(x :: Interval) = complement(intervalUnion(x))


# bisect x at α
function bisect( x :: IntervalUnion, α = 0)

    v = deepcopy(x.v)

    αIn = α .∈ v
    these = findall(αIn .== 1)

    if isempty(these); return x ; end

    this = popat!(v, these[1])

    β = (α - this.lo) /(this.hi - this.lo)

    bs = bisect(this, β)

    new = IntervalUnion(v ∪ bs[1] ∪ bs[2])
    new = remove_empties(new)
    sort!(new.v)
    return new

end


function intersect(x :: IntervalUnion, y :: IntervalUnion)
    intersects = [intersect(xv, yv) for xv in x.v, yv in y.v]
    if all(intersects .== ∅); return  ∅; end
    return intervalUnion(intersects[:])
end

function intersect(x :: IntervalUnion, y :: Interval)
    intersects = [intersect(xv, y) for xv in x.v]
    if all(intersects .== ∅); return  ∅; end
    return intervalUnion(intersects[:])
end

function intersect(x :: Interval, y :: IntervalUnion)
    intersects = [intersect(x, yv) for yv in y.v]
    if all(intersects .== ∅); return  ∅; end
    return intervalUnion(intersects[:])
end


function setdiff(x :: IntervalUnion, y :: IntervalUnion)
    yc = complement(y)
    return intersect(x, yc)
end

\(x :: IntervalUnion, y :: IntervalUnion) = setdiff(x, y)
\(x :: Interval, y :: IntervalUnion) = setdiff(intervalUnion(x), y)
\(x :: IntervalUnion, y :: IntervalUnion) = setdiff(x, intervalUnion(y))

function ⊂(x :: IntervalUnion, y :: IntervalUnion)
    issubs = [xv .⊂ y.v for xv in x.v]
    return all(any.(issubs))
end

function ⊂(x :: Interval, y :: IntervalUnion)
    if length(y.v) == 1; return x ⊂ y; end
    issubs = x .⊆ y.v
    return any(issubs)
end

function ⊂( x::IntervalUnion, y :: Interval)
    issubs = x.v .⊂ y
    return all(issubs)
end

function ⊆(x :: IntervalUnion, y :: IntervalUnion)
    issubs = [xv .⊆ y.v for xv in x.v]
    return all(any.(issubs))
end

function ⊆(x :: Interval, y :: IntervalUnion)
    issubs = x .⊆ y.v
    return any(issubs)
end

function ⊆( x::IntervalUnion, y :: Interval)
    issubs = x.v .⊆ y
    return all(issubs)
end

function in(x :: Real, y :: IntervalUnion)
    for i = 1:length(y.v)
        if x ∈ y.v[i]; return true; end
    end
    return false
end
