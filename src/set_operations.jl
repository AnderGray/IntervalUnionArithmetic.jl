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

function intersect(x :: IntervalU)

end

function set_diff(x :: IntervalU)

end