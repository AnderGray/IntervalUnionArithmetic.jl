@testset "set operations" begin

    Nsamps = 10^6

    a = interval(0,1) ∪ interval(2,3)
    b = interval(-1, 1) ∪ interval(2,5)

    aSamps = [rand(rand(a.v)) for i=1:Nsamps]
    bSamps = [rand(rand(b.v)) for i=1:Nsamps]

    @test all(aSamps .∈ a)
    @test all(bSamps .∈ b)

    ac = complement(a)

    @test all(.~(aSamps .∈ ac))     # Test all samples are not in complement

    intersec = a ∩ b                 # Intersect

    aSampsB = aSamps[ aSamps .∈ b]
    bSampsA = bSamps[ bSamps .∈ a]

    @test all( aSampsB .∈ intersec)
    @test all( bSampsA .∈ intersec)

    diff = a \ b                 # Set difference

    @test diff[1] == interval(1)
    @test diff[2] == interval(2)

    bi = bisect(a, 0.5)         # Cut at a = 0.5

    @test bi[1] == interval(0, 0.5)
    @test bi[2] == interval(0.5, 1)
    @test bi[3] == interval(2, 3)

    @test a ⊂ interval(0, 3)     # Subset
    @test !(b ⊂ interval(0, 3))


end
