using Sherlogs
using Test

n = 100

@testset "Compare to Float64" begin

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

@testset "Logbook count 64" begin

    # A SINGLE ENTRY IN THE LOGBOOK
    reset_logbook()
    Sherlog64(0)+Sherlog64(0)
    lb = return_logbook()
    @test 1 == sum(lb)

    # N ENTRIES IN THE LOGBOOK
    reset_logbook()
    a = Sherlog64(1.0)
    for i in 1:n
        a + randn(Float64)         # promotion included
    end
    lb = return_logbook()
    @test n == sum(lb)
end

@testset "Logbook count 32" begin

    # A SINGLE ENTRY IN THE LOGBOOK
    reset_logbook()
    Sherlog32(0)+Sherlog32(0)
    lb = return_logbook()
    @test 1 == sum(lb)

    # N ENTRIES IN THE LOGBOOK
    reset_logbook()
    a = Sherlog32(1.0)
    for i in 1:n
        a + randn(Float32)         # promotion included
    end
    lb = return_logbook()
    @test n == sum(lb)
end

@testset "Logbook count 16" begin

    # A SINGLE ENTRY IN THE LOGBOOK
    reset_logbook()
    Sherlog16(0)+Sherlog16(0)
    lb = return_logbook()
    @test 1 == sum(lb)

    # N ENTRIES IN THE LOGBOOK
    reset_logbook()
    a = Sherlog16(1.0)
    for i in 1:n
        a + randn(Float16)         # promotion included
    end
    lb = return_logbook()
    @test n == sum(lb)
end

@testset "Matrix multiplication" begin

    n = 10      # this can't be too large.
    # Presumably Float64 can be @simd, whereas Sherlog64 can't - yields slightly different results
    # ≈ operator necessary, but tests still might fail if n too large.

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
