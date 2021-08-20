module Sherlogs

    export Sherlog64,Sherlog32,Sherlog16,
            DrWatson64,DrWatson32,DrWatson16,
            LogBook,reset_logbook,reset_logbooks,
            get_logbook,get_logbooks,
            get_stacktrace,get_stacktraces, get_st_index,
            entropy

    import Base: +, -, *, /, ^, promote_rule, round, rem
    import StatsBase: entropy
    import Random
    import Random: rand, randn, randexp

    include("logbook.jl")
    include("SherlogN.jl")
    include("DrWatsonN.jl")
    include("stacktraces.jl")

end
