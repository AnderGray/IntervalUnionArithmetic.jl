###
#   IntervalUnion Arithmetic
###

# Special case for /. Probably better with promotion rules and convert
for op in (:+, :-, :/, :*, :min, :max, :^, :log, :<, :>)

    if op != :/; @eval ($op)( x::IntervalUnion, y::IntervalUnion) = intervalUnion([$op(xv, yv) for xv in x.v, yv in y.v][:]); end

    @eval ($op)( x::IntervalUnion, y::Interval) = intervalUnion(broadcast($op, x.v, y))
    if op != :/; @eval ($op)( x::Interval, y::IntervalUnion) = intervalUnion(broadcast($op, x, y.v)); end

    @eval ($op)( x::IntervalUnion, n::Real) = intervalUnion(broadcast($op, x.v, n))
    @eval ($op)( n::Real, x::IntervalUnion) = intervalUnion(broadcast($op, n, x.v))

end

for op in (:-, :sin, :cos, :tan, :exp, :log)
    @eval ($op)( x::IntervalUnion) = intervalUnion(broadcast($op, x.v))
end


# Does x/y for y\{0} if 0 ∈ y
function /(x :: IntervalUnion, y :: IntervalUnion)
    yNew = bisect(y, 0)
    return intervalUnion([xv / yv for xv in x.v, yv in yNew.v][:])
end

function /(x :: Interval, y :: IntervalUnion)
    yNew = bisect(y, 0)
    return intervalUnion(broadcast(/, x, yNew.v))
end

function sqrt( x:: IntervalUnion)
    us = sqrt.(x.v)
    return intervalUnion([us; -us])
end
