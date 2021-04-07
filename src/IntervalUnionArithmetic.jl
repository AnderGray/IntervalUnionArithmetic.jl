module IntervalUnionArithmetic

using Reexport

@reexport using IntervalArithmetic

import Base: getindex, ∪
import Base: +, -, *, /, min, max, ^, log, <, >, exp, sin, cos, tan
import IntervalArithmetic: hull

abstract type IntervalUnion{T} <: AbstractInterval{T} end

export 
    IntervalUnion, IntervalU, intervalU, remove_empties, condense,
    is_condensed, env, hull, complement, left, right

include("interval_unions.jl")

end # module
