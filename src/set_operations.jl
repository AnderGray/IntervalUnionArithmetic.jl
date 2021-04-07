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


