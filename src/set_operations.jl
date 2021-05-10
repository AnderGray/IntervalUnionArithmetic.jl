###
#   Set operations
###

# Envolpe/hull. Keeps it as a IntervalUnion
env(x :: IntervalU) = IntervalU([hull(x.v)])
hull(x :: IntervalU) = IntervalU([hull(x.v)])


# Computes the complement of a IntervalUnion
function complement(x :: IntervalU)

    v = sort(x.v)
    vLo = left.(v)
    vHi = right.(v)

    vLo[1] == -∞ ? popfirst!(vLo) : pushfirst!(vHi, -∞)
    vHi[end] == ∞ ? pop!(vHi) : push!(vLo, ∞)


    complements = interval.(vHi,vLo)

    return intervalU(complements)
end

complement(x :: Interval) = complement(intervalU(x))


# bisect x at α
function bisect( x :: IntervalU, α = 0)

    v = deepcopy(x.v)

    αIn = α .∈ v
    these = findall(αIn .== 1)

    if isempty(these); return x ; end

    this = popat!(v, these[1])

    β = (α - this.lo) /(this.hi - this.lo)

    bs = bisect(this, β)

    new = IntervalU(v ∪ bs[1] ∪ bs[2])
    new = remove_empties(new)
    sort!(new.v)
    return new

end


function intersect(x :: IntervalU, y :: IntervalU)
    intersects = [intersect(xv, yv) for xv in x.v, yv in y.v]
    if all(intersects .== ∅); return interval(∅); end
    return intervalU(intersects[:])
end

function intersect(x :: IntervalU, y :: Interval)
    intersects = [intersect(xv, y) for xv in x.v]
    if all(intersects .== ∅); return interval(∅); end
    return intervalU(intersects[:])
end

function intersect(x :: Interval, y :: IntervalU)
    intersects = [intersect(x, yv) for yv in y.v]
    if all(intersects .== ∅); return interval(∅); end
    return intervalU(intersects[:])
end


function setdiff(x :: IntervalU, y :: IntervalU)
    yc = complement(y)
    return intersect(x, yc)
end

\(x :: IntervalU, y :: IntervalU) = setdiff(x, y)
\(x :: Interval, y :: IntervalU) = setdiff(intervalU(x), y)
\(x :: IntervalU, y :: Interval) = setdiff(x, intervalU(y))

function ⊂(x :: IntervalU, y :: IntervalU)
    issubs = [xv .⊂ y.v for xv in x.v]
    return all(any.(issubs))
end

function ⊂(x :: Interval, y :: IntervalU)
    if length(y.v) == 1; return x ⊂ y; end
    issubs = x .⊆ y.v
    return any(issubs)
end

function ⊂( x::IntervalU, y :: Interval)
    issubs = x.v .⊂ y
    return all(issubs)
end

function ⊆(x :: IntervalU, y :: IntervalU)
    issubs = [xv .⊆ y.v for xv in x.v]
    return all(any.(issubs))
end

function ⊆(x :: Interval, y :: IntervalU)
    issubs = x .⊆ y.v
    return any(issubs)
end

function ⊆( x::IntervalU, y :: Interval)
    issubs = x.v .⊆ y
    return all(issubs)
end
