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

    include("logbook.jl")
    include("SherlogN.jl")
    include("DrWatson64.jl")
    include("DrWatson32.jl")
    include("DrWatson16.jl")
    include("stacktraces.jl")

end
