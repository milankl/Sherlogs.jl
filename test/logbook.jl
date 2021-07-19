@testset "Logbook count 64" begin

    n = 100

    # A SINGLE ENTRY IN THE LOGBOOK
    reset_logbook()
    Sherlog64(0)+Sherlog64(0)
    lb = get_logbook()
    @test 1 == sum(lb)

    # N ENTRIES IN THE LOGBOOK
    reset_logbook()
    a = Sherlog64(1.0)
    for i in 1:n
        a + randn(Float64)         # promotion included
    end
    lb = get_logbook()
    @test n == sum(lb)
end

@testset "Logbook count 32" begin

    n = 100

    # A SINGLE ENTRY IN THE LOGBOOK
    reset_logbook()
    Sherlog32(0)+Sherlog32(0)
    lb = get_logbook()
    @test 1 == sum(lb)

    # N ENTRIES IN THE LOGBOOK
    reset_logbook()
    a = Sherlog32(1.0)
    for i in 1:n
        a + randn(Float32)         # promotion included
    end
    lb = get_logbook()
    @test n == sum(lb)
end

@testset "Logbook count 16" begin

    n = 100

    # A SINGLE ENTRY IN THE LOGBOOK
    reset_logbook()
    Sherlog16(0)+Sherlog16(0)
    lb = get_logbook()
    @test 1 == sum(lb)

    # N ENTRIES IN THE LOGBOOK
    reset_logbook()
    a = Sherlog16(1.0)
    for i in 1:n
        a + randn(Float16)         # promotion included
    end
    lb = get_logbook()
    @test n == sum(lb)
end

@testset "Minimum, maximum logbook Float16" begin

    n = 100

    for T in [Float16,Float32,Float64]

        # MAXIMUM
        for _ in 1:n
            i = rand(1:32)          # pick a random logbook
            reset_logbook(i)        # set it to zero
            x = rand(T)       
            Sherlogs.log_it(Float16,x,i)     # log a random Float16
            logbook = get_logbook(i)
            @test Float16(x) == maximum(logbook)
        end

        # MINIMUM
        for _ in 1:n
            i = rand(1:32)          # pick a random logbook
            reset_logbook(i)        # set it to zero
            x = -rand(Float16)       
            Sherlogs.log_it(Float16,x,i)     # log a random Float16
            logbook = get_logbook(i)
            @test Float16(x) == minimum(logbook)
        end
    end
end
