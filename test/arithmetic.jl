@testset "arithmetic.jl" begin

    # Sampling based validation

    Nsamps = 10^5

    a = interval(0,2) ∪ interval(3,4)
    b = interval(-10,-9) ∪ interval(20, 25)

    aSamps = zeros(Nsamps); bSamps = zeros(Nsamps)

    for i = 1: Nsamps
        if rand() < 0.5
            aSamps[i] = rand() * 2
        else
            aSamps[i] = rand() + 3
        end

        if rand() < 0.5
            bSamps[i] = (rand() * 5) + 20
        else
            bSamps[i] = rand() - 10
        end
    end

    @test all(aSamps .∈ a)
    @test all(bSamps .∈ b)

    BivOps = [+, -, *, / , min, max, ^] # Error with /
    UniOps = [-, sin, cos, tan, exp, log, sqrt]

    for op in BivOps

        cInt = op(a, b)
        cSamps = op.(aSamps, bSamps)
        @test all( cSamps .∈ cInt)

    end


    for op in UniOps

        cInt = op(a)
        cSamps = op.(aSamps)
        @test all( cSamps .∈ cInt)

    end


end
