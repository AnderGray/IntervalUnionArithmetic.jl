###
#   Utilities and show
###

left(x :: Interval) = x.lo
right(x :: Interval) = x.hi

left(x :: IntervalUnion) = left.(x.v)
right(x :: IntervalUnion) = right.(x.v)

isequal(x :: IntervalUnion, y ::IntervalUnion) = all(isequal.(sort(x.v; by = left),sort(y.v; by = left)))

function in( x:: IntervalUnion, y :: Vector{IntervalUnion})
    for i =1:length(y)
        if x == y[i]
            return true
        end
    end
    return false
end


function Base.show(io::IO, this::IntervalUnion)
    if length(this.v) == 0
        print(io, "∅ᵤ")
    elseif length(this.v) == 1;
        print(io, "$(this.v[1])ᵤ");
    else
        v = sort(this.v; by = left)
        print(io, join(v, " ∪ "));
    end
end
