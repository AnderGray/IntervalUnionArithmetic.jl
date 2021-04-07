module IntervalUnionArithmetic

using Reexport

@reexport using IntervalArithmetic

import Base: getindex, ∪, intersect
import Base: +, -, *, /, min, max, ^, log, <, >, exp, sin, cos, tan, sqrt
import IntervalArithmetic: hull, bisect

abstract type IntervalUnion{T} <: AbstractInterval{T} end

export 
    IntervalUnion, IntervalU, intervalU, remove_empties, condense,
    iscondensed, condense_strong, iscondensed_strong, env, hull, complement, left, right, bisect

include("interval_unions.jl")
include("arithmetic.jl")
include("utilities.jl")
include("set_operations.jl")

end # module
