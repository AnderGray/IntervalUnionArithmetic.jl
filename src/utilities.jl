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
