module IntervalUnionArithmetic

using Reexport

@reexport using IntervalArithmetic

import Base: getindex, ∪
import Base: +, -, *, /, min, max, ^, log, <, >, exp, sin, cos, tan, sqrt
import IntervalArithmetic: hull

abstract type IntervalUnion{T} <: AbstractInterval{T} end

export 
    IntervalUnion, IntervalU, intervalU, remove_empties, condense,
    is_condensed, env, hull, complement, left, right

include("interval_unions.jl")
include("arithmetic.jl")
include("utilities.jl")
include("set_operations.jl")

end # module
