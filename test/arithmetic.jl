@testset "arithmetic.jl" begin

    # Sampling based validation

    Nsamps = 10^5

    a = interval(0,2) ∪ interval(3,4)
    b = interval(-10,-9) ∪ interval(20, 25)

    # Sample inside set
    aSamps = [rand(rand(a.v)) for i=1:Nsamps]
    bSamps = [rand(rand(b.v)) for i=1:Nsamps]

    @test all(aSamps .∈ a)
    @test all(bSamps .∈ b)

    BivOps = [+, -, *, / , min, max, ^] # Error with /
    UniOps = [-, sin, cos, tan, exp, log, sqrt]

    for op in BivOps
        cInt = op(a, b)
        cSamps = op.(aSamps, bSamps)
        @test all(cSamps .∈ cInt)
    end

    for op in UniOps
        cInt = op(a)
        cSamps = op.(aSamps)
        @test all(cSamps .∈ cInt)
    end


    # With 0 ∈ b

    a = interval(0,2) ∪ interval(3,4)
    b = interval(-5,5) ∪ interval(20, 25)

    aSamps = [rand(rand(a.v)) for i=1:Nsamps]
    bSamps = [rand(rand(b.v)) for i=1:Nsamps]

    @test all(aSamps .∈ a)
    @test all(bSamps .∈ b)

    BivOps = [+, -, *, / , min, max] # Error with /

    for op in BivOps

        cInt = op(a, b)
        cSamps = op.(aSamps, bSamps)
        @test all( cSamps .∈ cInt)

    end

end
