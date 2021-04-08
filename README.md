# IntervalUnionArithmetic.jl

An extension to [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl) with interval unions. Interval unions sets of defined by unions of disjoint intervals.

Conversation in [PR#452](https://github.com/JuliaIntervals/IntervalArithmetic.jl/pull/452)

This package includes constructors, arithmetic (including with intervals and scalars) and complement functions.

## Installation

This is not yet a registered julia package. However this package may be installed using the Julia package manager:

```Julia
julia> ]
pkg> add https://github.com/AnderGray/IntervalUnionArithmetic.jl.git
```

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
  
### Division and sqrt

  ```Julia
julia> x = interval(2,5); 
julia> y = interval(-1,1);
julia> x / y                # Standard interval arithmetic
    [-∞, ∞]
    
julia> x1 = intervalU(x);   # Convert to interval union
julia> y1 = intervalU(y);
julia> x1 / y1              # Does x1 / y1 for y1\{0} if 0 ∈ y1
    [-∞, -2] ∪ [2, ∞]

julia> sqrt(x)
    [1.41421, 2.23607]

julia> sqrt(x1)
    [-2.23607, -1.41421] ∪ [1.41421, 2.23607]
  ```
  
  
## Bibiography

* Schichl, Hermann, et al. ["Interval unions."](https://link.springer.com/content/pdf/10.1007/s10543-016-0632-y.pdf) BIT Numerical Mathematics 57.2 (2017): 531-556.]
* Montanher, Tiago, et al. "[Using interval unions to solve linear systems of equations with uncertainties."](https://www.researchgate.net/publication/316372412_Using_interval_unions_to_solve_linear_systems_of_equations_with_uncertainties) BIT Numerical Mathematics 57.3 (2017): 901-926.
* Domes, Ferenc, et al. ["Rigorous global filtering methods with interval unions."](https://link.springer.com/chapter/10.1007/978-3-030-31041-7_14) Beyond Traditional Probabilistic Data Processing Techniques: Interval, Fuzzy etc. Methods and Their Applications. Springer, Cham, 2020. 249-267
