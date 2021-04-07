###
#   IntervalUnion Arithmetic
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

function sqrt( x:: IntervalU)
    us = sqrt.(x.v)
    return intervalU([us; -us])
end
