# IntervalUnionArithmetic.jl

An extension to [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl) with Interval Unions

Interval unions sets of defined by unions of disjoint intervals.

This package includes constructors, arithmetic (including with intervals and scalars)
and complement functions.
  
  ## Example
  
  ```Julia
julia> a = interval(0,2) ∪ interval(3,4)
    [0, 2] ∪ [3, 4]

julia> b = interval(1,2) ∪ interval(4,5) ∪ ∅
    [1, 2] ∪ [4, 5]

julia> c = a * b 
    [0, 10] ∪ [12, 20]
    
julia> complement(c)
    [-∞, 0] ∪ [10, 12] ∪ [20, ∞]
  ```
  
