###
#   Utilities and show
###

left(x :: Interval) = x.lo
right(x :: Interval) = x.hi

left(x :: IntervalU) = left.(x.v)
right(x :: IntervalU) = right.(x.v)

isequal(x :: IntervalU, y ::IntervalU) = all(isequal.(sort(x.v),sort(y.v)))

function in( x:: IntervalU, y :: Vector{IntervalU})
    for i =1:length(y)
        if x == y[i]
            return true
        end
    end
    return false
end 


function Base.show(io::IO, this::IntervalU)
    v = sort(this.v)
    print(io, join(v, " ∪ "));
end
