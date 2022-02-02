using IntervalUnionArithmetic
using Test


@testset "constructor" begin

    x = 1..2
    a = intervalUnion(x)
    @test length(a.v) == 1
    @test a.v[1] == x

    a2 = intervalUnion(1, 2)
    @test length(a.v) == 1
    @test a.v[1] == x

    x2 = 3 .. 4
    b = intervalUnion([x, x2])
    @test length(b.v) == 2
    @test b.v == [x, x2]

    b2 = x ∪ x2
    @test b2.v == b.v

    x3 = interval(5, 6)
    b3 = b2 ∪ x3
    @test b3.v == [x, x2, x3]

    # Remove empties
    c = x ∪ ∅
    @test length(c.v) == 1
    @test c.v[1] == x

    # Remove empties
    c2 = x ∪ ∅ ∪ ∅ ∪ ∅ ∪ ∅ ∪ ∅
    @test length(c2.v) == 1
    @test c2.v[1] == x

    # Don't remove if IntervalUnion is called
    c3 = IntervalUnion([x, ∅])
    @test length(c3.v) == 2
    @test c3.v == [x, ∅]

    # Condense
    d = interval(1, 2) ∪ interval(1.5, 3)
    @test length(d.v) == 1
    @test d.v[1] == interval(1, 3)

    d2 = interval(1, 2) ∪ interval(2, 3)
    @test length(d2.v) == 1
    @test d2.v[1] == interval(1, 3)

    # Comparisons
    @test intervalUnion(1,2) == Interval(1,2) ∪ ∅
    @test !(intervalUnion(1,2) == ∅)
    @test intervalUnion(1,2) == Interval(1,2)
    @test isempty(intervalUnion(∅))

    @test intervalUnion(∅) == intervalUnion(∅) ∪ ∅

end

@testset "close gaps" begin



end
