@testset "Compare to Float64" begin

    n = 100

    X = randn(Float64,n)
    Y = randn(Float64,n)

    for i in 1:n                # ADDITION
        r = X[i] + Y[i]
        @test r == Sherlog64(X[i]) + Sherlog64(Y[i])
    end

    for i in 1:n                # SUBTRACTION
        r = X[i] - Y[i]
        @test r == Sherlog64(X[i]) - Sherlog64(Y[i])
    end

    for i in 1:n                # MULTIPLICATION
        r = X[i] * Y[i]
        @test r == Sherlog64(X[i]) * Sherlog64(Y[i])
    end

    for i in 1:n                # DIVISION
        r = X[i] / Y[i]
        @test r == Sherlog64(X[i]) / Sherlog64(Y[i])
    end

    for i in 1:n
        r = sqrt(abs(X[i]))
        @test r == sqrt(Sherlog64(abs(X[i])))
    end
end

@testset "Compare to Float32" begin

    n = 100

    X = randn(Float32,n)
    Y = randn(Float32,n)

    for i in 1:n                # ADDITION
        r = X[i] + Y[i]
        @test r == Sherlog32(X[i]) + Sherlog32(Y[i])
    end

    for i in 1:n                # SUBTRACTION
        r = X[i] - Y[i]
        @test r == Sherlog32(X[i]) - Sherlog32(Y[i])
    end

    for i in 1:n                # MULTIPLICATION
        r = X[i] * Y[i]
        @test r == Sherlog32(X[i]) * Sherlog32(Y[i])
    end

    for i in 1:n                # DIVISION
        r = X[i] / Y[i]
        @test r == Sherlog32(X[i]) / Sherlog32(Y[i])
    end

    for i in 1:n
        r = sqrt(abs(X[i]))
        @test r == sqrt(Sherlog32(abs(X[i])))
    end
end

@testset "Compare to Float16" begin

    n = 100

    X = randn(Float16,n)
    Y = randn(Float16,n)

    for i in 1:n                # ADDITION
        r = X[i] + Y[i]
        @test r == Sherlog16(X[i]) + Sherlog16(Y[i])
    end

    for i in 1:n                # SUBTRACTION
        r = X[i] - Y[i]
        @test r == Sherlog16(X[i]) - Sherlog16(Y[i])
    end

    for i in 1:n                # MULTIPLICATION
        r = X[i] * Y[i]
        @test r == Sherlog16(X[i]) * Sherlog16(Y[i])
    end

    for i in 1:n                # DIVISION
        r = X[i] / Y[i]
        @test r == Sherlog16(X[i]) / Sherlog16(Y[i])
    end

    for i in 1:n
        r = sqrt(abs(X[i]))
        @test r == sqrt(Sherlog16(abs(X[i])))
    end
end

@testset "Matrix multiplication" begin

    n = 10      # this can't be too large.
    # Presumably Float64 uses BLAS or similar, but Sherlog64 will use another implementation

    A = rand(Float64,n,n)
    B = rand(Float64,n,n)

    @test all(A*B .≈ Sherlog64.(A)*Sherlog64.(B))

    A = rand(Float32,n,n)
    B = rand(Float32,n,n)

    @test all(A*B .≈ Sherlog32.(A)*Sherlog32.(B))

    A = rand(Float16,n,n)
    B = rand(Float16,n,n)

    @test all(A*B .≈ Sherlog16.(A)*Sherlog16.(B))

end

@testset "Matrix solve" begin

    n = 10      # see above

    A = rand(Float64,n,n)
    b = rand(Float64,n)

    @test all(A\b .≈ Sherlog64.(A)\Sherlog64.(b))

    A = rand(Float32,n,n)
    b = rand(Float32,n)

    @test all(A\b .≈ Sherlog32.(A)\Sherlog32.(b))

    A = rand(Float16,n,n)
    b = rand(Float16,n)

    @test all(A\b .≈ Sherlog16.(A)\Sherlog16.(b))

end