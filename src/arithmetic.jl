###
#   IntervalUnion Arithmetic
###

# Special case for /. Probably better with promotion rules and convert
for op in (:+, :-, :/, :*, :min, :max, :^, :log, :<, :>)

    if op != :/; @eval ($op)( x::IntervalU, y::IntervalU) = intervalU([$op(xv, yv) for xv in x.v, yv in y.v][:]); end

    @eval ($op)( x::IntervalU, y::Interval) = intervalU(broadcast($op, x.v, y))
    if op != :/; @eval ($op)( x::Interval, y::IntervalU) = intervalU(broadcast($op, x, y.v)); end

    @eval ($op)( x::IntervalU, n::Real) = intervalU(broadcast($op, x.v, n))
    @eval ($op)( n::Real, x::IntervalU) = intervalU(broadcast($op, n, x.v))
    
end

for op in (:-, :sin, :cos, :tan, :exp, :log)
    @eval ($op)( x::IntervalU) = intervalU(broadcast($op, x.v))
end


# Does x/y for y\{0} if 0 ∈ y
function /(x :: IntervalU, y :: IntervalU)
    yNew = bisect(y, 0)
    return intervalU(broadcast(/, x.v, yNew.v))
end

function /(x :: Interval, y :: IntervalU)
    yNew = bisect(y, 0)
    return intervalU(broadcast(/, x, yNew.v))
end

function sqrt( x:: IntervalU)
    us = sqrt.(x.v)
    return intervalU([us; -us])
end
