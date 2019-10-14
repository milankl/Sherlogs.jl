using Sherlogs
using Test

n = 100

@testset "Compare to Float64" begin

    X = randn(n)
    Y = randn(n)

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

@testset "Logbook count" begin

    # A SINGLE ENTRY IN THE LOGBOOK
    reset_logbook()
    Sherlog64(0)+Sherlog64(0)
    lb = return_logbook()
    @test 1 == sum(lb)

    # N ENTRIES IN THE LOGBOOK
    reset_logbook()
    a = Sherlog64(1.0)
    for i in 1:n
        a + randn()         # promotion included
    end
    lb = return_logbook()
    @test n == sum(lb)
end
